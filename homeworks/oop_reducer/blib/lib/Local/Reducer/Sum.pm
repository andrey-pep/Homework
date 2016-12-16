package Local::Reducer::Sum;

use strict;
use warnings;
use utf8;
use parent 'Local::Reducer';

sub reduce {
    my $self = shift;
    my $tmp = $self -> {source} -> next;
    return if !(defined $tmp);
    my $default = "No way";
    my $f = $self -> {row_class} -> new ( str => $tmp ) -> get( $self -> {field}, $default);
    return if $f eq $default;
    return $self -> {reduced} += $f;
}
1