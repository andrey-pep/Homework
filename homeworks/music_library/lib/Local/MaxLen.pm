package Local::MaxLen;
use DDP;
use strict;
use warnings;
use diagnostics;
use base qw(Exporter);
our @EXPORT_OK = qw( max_len );
our @EXPORT = qw( max_len );
use feature 'say';

sub max_len {
    my $part = shift @_;
    my @music = @_;
    say $part;
    my $max = 0;
    my $i = 0;
    say $music[19]{"album"};
    for my $item (@music) {
        if ((my $tmp = length($music[$i++]{$part})) > $max ) {
            $max = $tmp;
            say $max;
        }
    }
}