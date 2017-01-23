package Local::TCP::Calc::Client;

use strict;
use IO::Socket;
use Local::TCP::Calc;

sub set_connect {
	my $pkg = shift;
	my $ip = shift;
	my $port = shift;
	...
	my $server = IO::Socket::INET -> new (
		PeerAddr => $ip,
		PeerPort => $port,
		Proto => 'tcp'
	)
	or die "Can't connect to $ip: $! $/";
	my $answer = <$server>;		# read header before read message
	die if $answer == Local::TCP::Calc::TYPE_CONN_ERR();		# check on Local::TCP::Calc::TYPE_CONN_ERR();
	...
	return $server;
}

sub do_request {
	my $pkg = shift;
	my $server = shift;
	my $type = shift;
	my $message = shift;

	...
	# Проверить, что записанное/прочитанное количество байт равно длинне сообщения/заголовка
	# Принимаем и возвращаем перловые структуры
	...

	return $struct;
}

1;

