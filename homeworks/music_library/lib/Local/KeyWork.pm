package Local::KeyWork;

use strict;
use warnings;
use diagnostics;
use base qw(Exporter);
our @EXPORT_OK = qw( reduce_mus sort_mus);
our @EXPORT = qw( reduce_mus sort_mus);
use Scalar::Util qw( looks_like_number );
use 5.010;

our $VERSION = '1.2';

sub reduce_mus {
    my $the_chosen_one = shift;
    my $category = shift;
    my @music = @_;
    my $i = 0;
    my @res;
    my @out;
    if (looks_like_number $_) {
        @res = grep { $_->{$category} == $the_chosen_one } @music;
    }
    else {
        @res = grep { $_->{$category} eq $the_chosen_one } @music;
    }
    return @res;
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