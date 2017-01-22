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

has 'source' => ( is => 'ro' );
has 'row_class' => (is => 'ro' );
has 'initial_value' => ( is => 'ro', isa => 'Int' );
has 'reduced' => ( is => 'rw', builder => '_build_reduced');

sub _build_reduced {
        my ($self) = @_;
        $self -> { reduced } = $self -> { initial_value };
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
