package Local::Row::Simple;

use strict;
use warnings;
use utf8;
use Moose;
extends 'Local::Row';

sub _build_str {
    my ($self,$source) = @_;
    my %output;
    my @res = split (/,/, $source);
    for (@res) {
        if (/\s*(\w+):(\w+)\s*/) {
            $output{$1} = $2;
        }
        else { die "Wrong Key:Value input"; }
    }
    return \%output;
}
1