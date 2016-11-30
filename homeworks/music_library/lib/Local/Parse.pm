package Local::Parse;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( add_treck make_arg_hash);
our @EXPORT = qw( add_treck make_arg_hash);
use utf8;

our $VERSION = '1.2';

sub add_treck {
        my %hash_out = (band => shift, year =>shift, album => shift, track => shift, format => shift);
        return \%hash_out;
}

sub make_arg_hash {
    my %out;
    my $i = 0;
    my @work_mas = @_;
    while (my $item = $work_mas[$i++]) {
        if ($item =~ /--columns/) {
            if (!defined $work_mas[$i]) {
                exit -1;
            }
            my @col = split (/[,]/,$work_mas[$i]);   
            $out{columns} = \@col;
        }
        elsif ($item =~ /--([\w]{4,6})/) {
            if ($1 eq "year") {
                $work_mas[$i] = 0+$work_mas[$i];
            }
            $out{$1} = $work_mas[$i++];
        }
    }
    return %out;
    
}

1;