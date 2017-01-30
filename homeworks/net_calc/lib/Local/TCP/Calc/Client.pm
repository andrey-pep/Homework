package Local::TCP::Calc::Client;

use strict;
use IO::Socket;
use Local::TCP::Calc;

sub set_connect {
	my $pkg = shift;
	my $ip = shift;
	my $port = shift;
	my $server = IO::Socket::INET -> new (
		PeerAddr => $ip,
		PeerPort => $port,
		Proto => "tcp"
	)
	or die "Can't connect to $ip: $! $/";
	my $answer = <$server>;		# read header before read message
	die if $answer == Local::TCP::Calc->TYPE_CONN_ERR();		# check on Local::TCP::Calc::TYPE_CONN_ERR();
	return $server;
}

sub do_request {
	my $pkg = shift;
	my $server = shift;
	my $type = shift;
	my $message = shift;
	my $i = 0;
	my @answer;
	print $server $type;
	if ( <$server> != Local::TCP::Calc->TYPE_CONN_OK ) {
        die "Can't connect: queue is full, try later\n";
    }
	if ( $type == Local::TCP::Calc::TYPE_START_WORK() ) {
		while( my $c = $$message[$i] ) {
			print $server $c;
		}
		$answer[0] = <$server>;
	}
    elsif ( $type == Local::TCP::Calc->TYPE_CHECK_WORK() ) {
		print $server $message;
		@answer = <$server>;
	}
	my $struct = Local::TCP::Calc->unpack_message( @answer );
	# Проверить, что записанное/прочитанное количество байт равно длине сообщения/заголовка
	# Принимаем и возвращаем перловые структуры

	return \@struct;
}

1;

