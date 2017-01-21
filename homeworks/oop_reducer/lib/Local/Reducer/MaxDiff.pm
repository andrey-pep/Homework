package Local::Reducer::MaxDiff;

use strict;
use warnings;
use utf8;
use Moose;
use Local::Row::Simple;
extends 'Local::Reducer';

has 'top' => ( is => 'rw', isa => 'Str' );
has 'bottom' => ( is => 'rw', isa => 'Str' );

sub reduce {
    my $self= shift;
    my $tmp = $self -> {source} -> next or return;
    my $default = "Wrong argument input";
    my $row_class = $self -> {row_class} -> new ( str => $tmp);
    my $top = $row_class -> get( $self -> {top}, $default);
    my $bottom = $row_class -> get( $self -> {bottom}, $default);
    return if ( $top or $bottom ) eq $default;
    my $difference = abs( $top-$bottom );
    $difference > $self -> reduced ? return $self -> {reduced} = $difference : return $self -> reduced;
}
1
