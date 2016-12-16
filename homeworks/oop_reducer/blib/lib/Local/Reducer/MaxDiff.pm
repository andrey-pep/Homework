package Local::Reducer::MaxDiff;

use strict;
use warnings;
use utf8;
use parent 'Local::Reducer';

sub reduce {
    my $self = shift;
    my $tmp = $self -> {source} -> next;
    return if !$tmp;
    my $default = "Wrong argument input";
    my $row_class = $self -> {row_class} -> new (str => $tmp);
    my $top = $row_class -> get( $self -> {top}, $default);
    my $bottom = $row_class -> get( $self -> {bottom}, $default);
    return if ( $top or $bottom ) eq $default;
    my $difference = abs($top-$bottom);
    if ( $difference > $self -> {reduced} ) { return $self -> {reduced} = $difference }
    else { return $self -> {reduced}; }
}
1
