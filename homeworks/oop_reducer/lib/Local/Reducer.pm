package Local::Reducer; {

use strict;
use warnings;
use utf8;

=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

sub new {
        my ($class, %params) = @_;
        $params{reduced} = $params{initial_value};
	return bless \%params, $class;
}

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
