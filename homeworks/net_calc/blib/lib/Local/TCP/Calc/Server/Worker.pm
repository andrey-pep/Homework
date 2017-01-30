package Local::TCP::Calc::Server::Worker;

use strict;
use warnings;
use Mouse;
use threads;
use threads::shared;
use Fcntl ':flock';

has cur_task_id => (is => 'ro', isa => 'Int', required => 1);
has forks       => (is => 'rw', isa => 'HashRef', default => sub {return {}});
has calc_ref    => (is => 'ro', isa => 'CodeRef', required => 1);
has max_forks   => (is => 'ro', isa => 'Int', required => 1);

sub write_err {
	my $self = shift;
	my $error = shift;

	# Записываем ошибку возникшую при выполнении задания
}

sub write_res {
	my $self = shift;
	my $res = shift;
	
	if ( $res =~ /\d+/ ) {
        
    }
    
	# Записываем результат выполнения задания
}

sub child_fork {
	my $self = shift;

	# Обработка сигнала CHLD, не забываем проверить статус завершения процесс и при надобности убить оставшихся
}

sub start {
	my $self = shift;
	my $task = shift;
	my $last_task = 0;
	my $file_name = "result".$self->{ cur_task_id } ;

	#my @threads;
	#ur $last_task:shared = 0;
	#while ( $last_task <= $#$task ) {
    #    for my $term( 0 .. $#$task / $self->{ max_forks } - $last_task ) {
	#		push @threads, threads->create( \&child_fork );
	#	}
    #}
	#for my $term( @threads ) {
	#	$term->join();
	#}
	
	while ( $last_task <= $#$task ) {
		foreach ( 1 .. $#$task / $self->{ max_forks } - $last_task ) {			# Начинаем выполнение задания. Форкаемся на нужное кол-во форков для обработки массива примеров
			my $pid = fork();
			if ($pid) {
		        next;
		    }
		    elsif( defined $pid) {
				my $result = $self->calc_ref($$task[$last_task++]);
				open(my $fh, '>', $file_name) or die $!;
				flock( $fh, LOCK_EX );							# локи, чтобы форки друг другу не портили результат
				$self->write_res( $result );					# В форках записываем результат в файл
				flock( $fh, LOCK_UN );
			}
			else {
				die "Can't fork: $!";
			}
		}
	}
	# Вызов блокирующий, ждём  пока не завершатся все форки
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
