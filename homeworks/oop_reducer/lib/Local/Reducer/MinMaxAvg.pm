package Local::Reducer::MinMaxAvg;

use strict;
use warnings;
use utf8;
use Moose;
extends 'Local::Reducer';

has 'field' => ( is => 'ro', isa => 'Str' );
has 'amount' => ( is => 'rw', isa => 'Int', default => '0' );
has '+reduced' => ( is => 'rw', lazy => 1, builder => '_build_reduced');

sub _build_reduced {
    my ( $self ) = @_;
    $self -> { reduced } -> { get_max } = $self -> { initial_value };
    $self -> { reduced } -> { get_min } = $self -> { initial_value };
    $self -> { reduced } -> { get_avg } = $self -> { initial_value };
    return bless $self -> { reduced };
}

sub reduce {
    my ( $self ) = @_;
    my $tmp = $self -> {source} -> next or return;
    my $default = "No way";
    my $f = $self -> {row_class} -> new ( str => $tmp ) -> get( $self -> {field}, $default);
    return if $f eq $default;
    if ( $f > $self -> reduced -> { get_max } ) {
         $self -> reduced -> { get_max } = $f;
    }
    if ( $f < $self -> reduced -> { get_min } ) {
         $self -> reduced -> { get_min } = $f;
    }
    $self -> reduced -> { get_avg } = ( $self -> { amount } + $f ) / $self -> { source } -> { pos };
    $self -> { amount } += $f;
    return $self -> { reduced };
}

1