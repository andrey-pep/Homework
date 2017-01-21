package Local::Source;
use strict;
use warnings;
use utf8;
use Moose;

has 'array' => ( is => 'rw', isa => 'ArrayRef' );
has 'pos' => ( is => 'rw', isa => 'Int',  default => 0 );

1;
