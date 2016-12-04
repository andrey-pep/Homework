package Local::KeyWork;

use strict;
use warnings;
use diagnostics;
use base qw(Exporter);
our @EXPORT_OK = qw( reduce_mus sort_mus);
our @EXPORT = qw( reduce_mus sort_mus);
use 5.010;

our $VERSION = '1.2';

sub reduce_mus {
    my $the_chosen_one = shift;
    my $category = shift;
    my @music = @_;
    my $i = 0;
    my @res;
    my @out;
    if ($category eq "year") {
        @res = grep { $music[$_]->{$category} == $the_chosen_one } 0..$#music;
    }
    else {
        @res = grep { $music[$_]->{$category} eq $the_chosen_one } 0..$#music;
    }
    foreach ($i = 0; $i < @res; $i++) { $out[$i] = $music[$res[$i]];}
    return @out;
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