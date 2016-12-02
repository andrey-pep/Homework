package Local::Parse;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( add_treck make_arg_hash);
our @EXPORT = qw( add_treck make_arg_hash);

our $VERSION = '1.2';

sub add_treck {
        my %hash_out = (band => shift, year =>shift, album => shift, track => shift, format => shift);
        return \%hash_out;
}
