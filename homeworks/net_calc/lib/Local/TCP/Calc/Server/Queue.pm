package Local::TCP::Calc::Server::Queue;

use strict;
use warnings;

use Mouse;
use Local::TCP::Calc;
use Fcntl ':flock';
use JSON::XS;

has f_handle       => (is => 'rw', isa => 'FileHandle');
has queue_filename => (is => 'ro', isa => 'Str', default => '/tmp/local_queue.log');
has max_task       => (is => 'rw', isa => 'Int', default => 0);

sub init {
	my $self = shift;
	my $default= {};

	$self->Local::TCP::Calc::Server::Queue->open( Local::TCP::Calc->TYPE_START_WORK() );
	for $temp (1 .. $self->{ max_task } ) {
		$default->{ $temp }->{ status } =  Local::TCP::Calc->STATUS_NEW);
	}
	$self->Local::TCP::Calc::Server::Queue->close( $default );
	# Подготавливаем очередь к первому использованию если это необходимо
}

sub open {
	my $self = shift;
	my $open_type = shift;
	my $source;

	if ( $open_type == Local::TCP::Calc -> TYPE_START_WORK() ) {					# Открваем файл с очередью
        open( $self -> { f_handle }, '+<', $self -> queue_filename ) or die "$!";
    }
    elsif( $open_type == Local::TCP::Calc -> TYPE_CHECK_WORK() ) {
		open( $self -> { f_handle }, '+<', $self -> queue_filename ) or die "$!";
	}
	else die "$!";
	flock( $self -> { f_handle }, LOCK_EX );		#не забываем про локи
	while ( <$self -> { f_handle }> ) {
        $source = $source.$_;
    }
    my $output = JSON::XS->new->decode( $source ); # возвращаем содержимое (перловая структура)
	return $output;
}

sub close {
	my $self = shift;
	my $struct = shift;

	if ( defined $struct ) {				# Перезаписываем файл с данными очереди (если требуется)
        truncate( $self->{ f_handle }, 0) or die "$!";
		my $source = JSON::XS->new->encode->%$struct;
		seek($self->{ f_handle }, 0 );
		print $self->{ f_handle } $source;
    }
	flock( $self->{ f_handle }, LOCK_UN );		#снимаем лок 
    close ( $self->{ f_handle } ) or die "$!";		#закрываем файл.
}

sub to_done {
	my $self = shift;
	my $task_id = shift;
	my $file_name = shift;

	my $source = $self->Local::TCP::Calc::Server::Queue->open( Local::TCP::Calc->TYPE_CHECK_WORK() );
	$source->{ $task_id }->{ status } = Local::TCP::Calc->STATUS_DONE;			# Переводим задание в статус DONE
	$source->{ $task_id }->{ file_name } = $file_name; 		#сохраняем имя файла с резуьтатом работы
	$self->Local::TCP::Calc::Server::Queue->close( $source );
}

sub get_status {
	my $self = shift;
	my $id = shift;
	my @output;
	
	my $source = $self->Local::TCP::Calc::Server::Queue->open( Local::TCP::Calc->TYPE_CHECK_WORK() );
	$output[0] = $source->{ $id }->{ status };			# Возвращаем статус задания по id
	if( defined $source->{ status } == ( Local::TCP::Calc->STATUS_DONE or Local::TCP::Calc->STATUS_ERROR )) {		# и в случае DONE или ERROR имя файла с результатом
		$output[1] = $source->{ $id }->{ file_name };
		delete $source->{ $id };
	}
	$self->Local::TCP::Calc::Server::Queue->close( $source );
	return \@output;
}

sub delete {
	my $self = shift;
	my $id = shift;
	my $status = shift;

	my $source = $self->Local::TCP::Calc::Server::Queue->open( Local::TCP::Calc->TYPE_CHECK_WORK() );
	delete $source->{ $id }->{ tasks };			# Удаляем задание из очереди в соответствующем статусе
	$source->{ status } = $status;
	$self->Local::TCP::Calc::Server::Queue->close( $source );
}

sub get {
	my $self = shift;

	my $source = $self->Local::TCP::Calc::Server::Queue->open( Local::TCP::Calc->TYPE_CHECK_WORK() );
	my $to_do_amount = grep { $self->{ $_ }->{ status } == ( Local::TCP::Calc->STATUS_WORK() ) } 1..$self->{ max_task };					#количество элементов в очереди со статусом "В работе"
	return $to_do_amount,$self->{ $to_do_amount }->{ tasks };		# Возвращаем задание, которое необходимо выполнить (id, tasks)
}

sub add {
	my $self = shift;
	my $new_work = shift;

	my $source = $self->Local::TCP::Calc::Server::Queue->open( Local::TCP::Calc->TYPE_START_WORK() );
	my $free_amount = grep { $self->{ $_ }->{ status } == ( Local::TCP::Calc->STATUS_WORK() ) } 1..$self->{ max_task };		#последний свободный участок в очереди
	my $id = $free_amount + 1;
	if ( $id >= $self-> { max_tasks } ) {						# Добавляем новое задание с проверкой, что очередь не переполнилась
		$self->Local::TCP::Calc::Server::Queue->close();
        return "Queue is full. Try later please\n";
    }
	else {
		$source->{ $id }->{ tasks } = @$new_work;
		$source->{ status }=Local::TCP::Calc->STATUS_WORK();
		$self->Local::TCP::Calc::Server::Queue->close( $source );
		return $id, "Calculating started\n";
	}
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
__DATA__
разобраться с open_type в сабе open: зачем и почему