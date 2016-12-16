package Local::Row;
use strict;
use warnings;
use utf8;

sub new {
    my ($class, %params) = @_;
    my $str = $class -> parse( $params{str} );
    bless $str,$class;
}

sub get {
    my ($self, $name, $default) = @_;
    if ( defined $self -> {$name} ) { return $self -> {$name}; }
    else { return $default; }
}
1