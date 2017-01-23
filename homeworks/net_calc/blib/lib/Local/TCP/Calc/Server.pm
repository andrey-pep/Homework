package Local::TCP::Calc::Server;

use strict;
use Local::TCP::Calc;
use Local::TCP::Calc::Server::Queue;
use Local::TCP::Calc::Server::Worker;

my $max_worker;
my $in_process = 0;

my $pids_master = {};
my $receiver_count = 0;
my $max_forks_per_task = 0;

sub REAPER {
	...
	# Функция для обработки сигнала CHLD
};
$SIG{CHLD} = \&REAPER;

sub start_server {
	my ($pkg, $port, %opts) = @_;
	$max_worker         = $opts{ max_worker } // die "max_worker required"; 
	$max_forks_per_task = $opts{ max_forks_per_task } // die "max_forks_per_task required";
	my $max_receiver    = $opts{ max_receiver } // die "max_receiver required"; 
	my $max_queue_task  = $opts{ max_queue_task } // die "max_queue_task required";
	...
	my $fh;
	my $server = IO::Socket::INET->new(
	LocalPort => $port,
	Type      => SOCK_STREAM,
	ReuseAddr => 1,
	Proto = 'tcp',
	Listen    => $max_queue_task )		# Инициализируем сервер
	or die "Can't create server on port $port : $@ $/";
	my $q = Local::TCP::Calc::Server::Queue->new(
	f_handle = $fh,
	max_task = $max_receiver
	);		# Инициализируем очередь
  	...
	$q->init();
	...
	while( my $client = $server -> accept() ) {		# Начинаем accept-тить подключения
		my $chiled = fork();
		if ( $child ) {
            close ($client);
			next;
        }
        if( defined $child ) {
			close( $server );
			if ( $in_process <= $max_receiver ) { 					# Проверяем, что количество принимающих форков не вышло за пределы допустимого ($max_receiver)
				print $client Local::TCP::Calc -> TYPE_CONN_OK();		# Если все нормально отвечаем клиенту TYPE_CONN_OK()
			}
			else {
				print $client Local::TCP::Calc -> TYPE_CONN_ERR();		#в противном случае TYPE_CONN_ERR()
			}
		}
	}
	# В каждом форке читаем сообщение от клиента, анализируем его тип (TYPE_START_WORK(), TYPE_CHECK_WORK()) 
	# Не забываем проверять количество прочитанных/записанных байт из/в сеть
	# Если необходимо добавляем задание в очередь (проверяем получилось или нет) 
	# Если пришли с проверкой статуса, получаем статус из очереди и отдаём клиенту
	# В случае если статус DONE или ERROR возвращаем на клиент содержимое файла с результатом выполнения
	# После того, как результат передан на клиент зачищаем файл с результатом
}

sub check_queue_workers {
	my $self = shift;
	my $q = shift;
	...
	# Функция в которой стартует обработчик задания
	# Должна следить за тем, что бы кол-во обработчиков не превышало мексимально разрешённого ($max_worker)
	# Но и простаивать обработчики не должны
	# my $worker = Local::TCP::Calc::Server::Worker->new(...);
	# $worker->start(...);
	# $q->to_done ...
}

1;
