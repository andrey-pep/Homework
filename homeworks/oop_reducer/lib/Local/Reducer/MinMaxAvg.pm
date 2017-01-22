package Local::Reducer::MinMaxAvg;

use strict;
use warnings;
use utf8;
use Moose;
extends 'Local::Reducer';

has 'field' => ( is => 'ro', isa => 'Str' );
has '+reduced' => ( is => 'rw', builder => '_build_reduced');

sub _build_reduced {
    my ( $self ) = @_;
    $self -> { get_max } = $self -> initial_value;
    $self -> { get_min } = $self -> initial_value;
    $self -> { get_avg } = $self -> initial_value;
}

sub reduced {
    my ( $self ) = @_;
    return $self -> { reduced };
}

sub reduce {
    my ( $self ) = @_;
    my $tmp = $self -> {source} -> next or return;
    my $default = "No way";
    my $f = $self -> {row_class} -> new ( str => $tmp ) -> get( $self -> {field}, $default);
    return if $f eq $default;
    if ( $f > $self -> get_max ) {
         $self -> { get_max } = $f;
    }
    if ( $f < $self -> get_min ) {
         $self -> { get_min } = $f;
    }
    $self -> { avg } += ( $f / 2 );
    return $self -> { reduced };
}

sub get_max {
    my ( $self ) = @_;
    return $self -> { get_max };
}

sub get_min {
    my ( $self ) = @_;
    return $self -> { get_min };
}

sub get_avg {
    my ( $self ) = @_;
    return $self -> { avg };
}

1