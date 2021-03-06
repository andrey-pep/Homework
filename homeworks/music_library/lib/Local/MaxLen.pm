package Local::MaxLen;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( max_len );
our @EXPORT = qw( max_len );
use 5.010;

our $VERSION = '1.2';

sub max_len {
    my $part = shift @_;
    my @music = @_;
    my $max = 0;
    my $i = 0;
    for (@music) {
        if ((my $tmp = length($music[$i++]{$part})) > $max ) {
            $max = $tmp;
        }
    }
    return $max;
    1;
}
1;