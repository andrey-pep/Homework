package Local::Source;
use strict;
use warnings;
use utf8;
use Moose;

has 'array' => ( is => 'rw', isa => 'ArrayRef');
has 'pos' => ( is => 'rw', default => 0, isa => 'Int' );

#sub BUILD {
 #   my ($self, %array) = @_;
  #  $array{pos} = 0;
   # return bless \%array, $self;
#}

1