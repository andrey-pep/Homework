package Local::Reducer::Sum;

use strict;
use warnings;
use utf8;
use Moose;
extends 'Local::Reducer';

has 'field' => ( is => 'rw', isa => 'Str' );

sub reduce {
    my $self = shift;
    my $tmp = $self -> {source} -> next or return;
    my $default = "No way";
    my $f = $self -> {row_class} -> new ( str => $tmp ) -> get( $self -> {field}, $default);
    return if $f eq $default;
    return $self -> {amount} += $f;
}
1