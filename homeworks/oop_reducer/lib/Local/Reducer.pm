package Local::Reducer; 

use strict;
use warnings;
use utf8;
use Moose;

=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 2.00

=cut

our $VERSION = '2.0';

has 'source' => ( is => 'rw' );
has 'row_class' => (is => 'rw' );
has 'initial_value' => ( is => 'ro', isa => 'Int' );
has 'amount' => ( is => 'rw', isa => 'Int', builder => '_build_amount' );

sub _build_amount {
        my ($self) = @_;
        return $self -> initial_value;
}

sub reduced {
    my ($self) = @_;
    return $self-> { amount };
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

1;
