package Local::TCP::Calc;

use strict;
use PerlIO::via::gzip;
use feature 'say';

sub TYPE_START_WORK {1}
sub TYPE_CHECK_WORK {2}
sub TYPE_CONN_ERR   {3}
sub TYPE_CONN_OK    {4}

sub STATUS_NEW   {1}
sub STATUS_WORK  {2}
sub STATUS_DONE  {3}
sub STATUS_ERROR {4}

sub pack_header {
	my $pkg = shift;
	my $type = shift;
	my $size = shift;
}

sub unpack_header {
	my $pkg = shift;
	my $header = shift;
}

sub pack_message {
	my $pkg = shift;
	my $messages = shift;
	
	open( my $packed_fh, '>:via(gzip)', "$messages.gz" ) or die "Can't open $messages: $!";
	open( my $fh, "<", $messages ) or die $!;
	while( <$fh>) {
        print $packed_fh $_;
    }
	close $fh;
	unlink $messages;
    return $packed_fh;
}

sub unpack_message {
	my $pkg = shift;
	my $message = shift;
	my @unpacked_fh;
	
	open( my $fh, '<:via(gzip)', $message ) or die "Can't open $message: $!";
	while( <$fh> ) {
		chomp;
		$unpacked_fh[ $#unpacked_fh + 1 ] = $_;
    }
	close $fh;
    return \@unpacked_fh;
}

1;
