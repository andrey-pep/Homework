package Local::TCP::Calc::Server;

use strict;
use POSIX;
use Fcntl ':flock';
use Local::TCP::Calc;
use Local::TCP::Calc::Server::Queue;
use Local::TCP::Calc::Server::Worker;
use 5.010;

my $max_worker;
my $in_process = 0;

my $pids_master = {};
my $receiver_count = 0;
my $max_forks_per_task = 0;


sub REAPER {
	while( my $pid = waitpid(-1, WNOANG)) {
		last if $pid == -1;
		if ( WIFEXITED($?) ) {		#если процесс завершился
            check_queue_workers( $pid, $q );	#запускается функция запуска обработчика задания
        }  
	}
	# Функция для обработки сигнала CHLD
};
$SIG{CHLD} = \&REAPER;

sub start_server {
	my ($pkg, $port, %opts) = @_;
	$max_worker         = $opts{ max_worker } // die "max_worker required"; 
	$max_forks_per_task = $opts{ max_forks_per_task } // die "max_forks_per_task required";
	my $max_receiver    = $opts{ max_receiver } // die "max_receiver required"; 
	my $max_queue_task  = $opts{ max_queue_task } // die "max_queue_task required";

	my $fh;
	my $server = IO::Socket::INET->new(
	LocalPort => $port,
	Type      => SOCK_STREAM,
	ReuseAddr => 1,
	Proto = "tcp",
	Listen    => $max_queue_task )		# Инициализируем сервер
	or die "Can't create server on port $port : $@ $/";
	my $q = Local::TCP::Calc::Server::Queue->new(
	f_handle = $fh,
	max_task = $max_receiver
	);		# Инициализируем очередь
	
	$q->init();

	while( my $client = $server -> accept() ) {		# Начинаем accept-тить подключения
		my $child = fork();
		if ( $child ) {
            close ($client);
			next;
        }
        if( defined $child ) {
			close( $server );
			$client -> autoflush(1);
			if ( $$receiver_count <= $max_receiver ) { 					# Проверяем, что количество принимающих форков не вышло за пределы допустимого ($max_receiver)
				$receiver_count++;
				print $client TYPE_CONN_OK();		# Если все нормально отвечаем клиенту TYPE_CONN_OK()
			}
			else {
				print $client TYPE_CONN_ERR();		#в противном случае TYPE_CONN_ERR()
			}
			my $message = <$client>;		# В каждом форке читаем сообщение от клиента, анализируем его тип (TYPE_START_WORK(), TYPE_CHECK_WORK())
			if( $message == TYPE_START_WORK() ) {				# Если необходимо добавляем задание в очередь (проверяем получилось или нет) 
                my @examples = <$client>;
				my @answer = $q -> add( \@examples );
				print $client @answer;
				close $client;
				$receiver_count--;
            }
			elsif ( $message == TYPE_CHECK_WORK() ) {
                $message = <$client>;
				my $answer = $q -> get_status( $message );		# Если пришли с проверкой статуса, получаем статус из очереди и отдаём клиенту
				print $client $answer[0];
				if ( $$answer[1] == ( Local::TCP::Calc -> STATUS_DONE() or Local::TCP::Calc -> STATUS_ERROR() ) {		# В случае если статус DONE или ERROR возвращаем на клиент содержимое файла с результатом выполнения  
					$$answer[1] = Local::TCP::Calc -> pack_message( $$answer[1] );
					print $client $$answer[1];
					close ( $client );
					$receiver_count--;
                }
            }
			exit;
		}
	} 
	# Не забываем проверять количество прочитанных/записанных байт из/в сеть
	# После того, как результат передан на клиент зачищаем файл с результатом
	close ( $server );
}

sub calc {
	my $example = shift;
	my $command = "echo '$example' | bc >> $fh_for_res";
	my $results = `$command`;
	return $results;
}

sub check_queue_workers {
	my $self = shift;
	my $q = shift;

	# Функция в которой стартует обработчик задания
	eval {
		if( $in_process < $max_worker ) {			# Должна следить за тем, что бы кол-во обработчиков не превышало мексимально разрешённого ($max_worker)
			my $worker = Local::TCP::Calc::Server::Worker->new( cur_task_id => $self, calc_ref => \&calc, max_forks => $max_forks_per_task );
		}
	}
	$worker -> start( $q -> get() );
	# Но и простаивать обработчики не должны
	# $worker->start(...);
	# $q->to_done ...
}

1;
