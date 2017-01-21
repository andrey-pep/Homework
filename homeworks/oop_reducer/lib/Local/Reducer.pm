package Local::Reducer; {

use strict;
use warnings;
use utf8;
use Moose;

=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 1.00

=cut

has 'source' => (is => 'rw' );
has 'row_class' => (is => 'rw' );
has 'initial_value' => (is => 'rw' );

our $VERSION = '1.00';

sub reduced {
    my $self = shift;
    return $self->{'reduced'};
}

sub reduce_n {
        my ($self, $n) = @_;
        for (0..$n-1) { last if !(defined $self -> reduce()); }
        return $self -> reduced;
}

sub reduce_all {
        my $self= shift;
        while ( defined $self -> reduce() ) {}
        return $self -> reduced;
}
=head1 SYNOPSIS

=cut
}
1;
