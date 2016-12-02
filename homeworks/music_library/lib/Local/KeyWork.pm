package Local::KeyWork;

use strict;
use warnings;
use diagnostics;
use base qw(Exporter);
our @EXPORT_OK = qw( reduce_mus sort_mus);
our @EXPORT = qw( reduce_mus sort_mus);

our $VERSION = '1.2';

sub reduce_mus {
    my $the_chosen_one = shift;
    my $category = shift;
    my @music = @_;
    my $i = 0;
    if ($category eq "year") {
        while (defined $music[$i]) {
            if ($music[$i]{$category} != $the_chosen_one) {splice (@music,$i,1);}
            else { $i++; }
        }
    }
    else {
        while (defined $music[$i]) {
            if ($music[$i]{$category} ne $the_chosen_one) {splice (@music,$i,1);}
            else { $i++; }
        }
    }
    return @music;
}

sub sort_mus {
    my $category = shift;
    my @music = @_;
    if ($category eq "year") {
        @music = sort { $a->{$category} <=> $b->{$category} } @music;
    }
    else { @music = sort {$a->{$category} cmp $b->{$category} } @music}
    return @music;
}