package Local::Reducer;

use strict;
use warnings;
use diagnostics;
use base qw(Exporter);
our @EXPORT_OK = qw( reduce_mus );
our @EXPORT = qw( reduce_mus );
use DDP;
use feature 'say';

sub reduce_mus {
    my $the_chosen_one = shift;
    my $category = shift;
    my @music = @_;
    my $i = 0;
    while (defined $music[$i]) {
        if ($music[$i]{$category} ne $the_chosen_one) {splice (@music,$i,1);}
        else { $i++; }
    }
    if (@music == 0) {die "wrong key";}
    return @music;
}