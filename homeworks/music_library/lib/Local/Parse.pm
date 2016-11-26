package Local::Parse;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( add_treck make_arg_hash);
our @EXPORT = qw( add_treck make_arg_hash);
use DDP;
use feature 'say';

our $VERSION = '1.2';

sub add_treck {
    my $source = shift;
    if (/\.\/(.+)\/(\d+) - (.+)\/(.+)\.([\w]+)\s?/g) {
        my %hash_out = (band => $1, year =>0+$2, album => $3, treck => $4, format => $5);
        return \%hash_out;
    }
    1;
}

sub make_arg_hash {
    my %out;
    my $i = 0;
    my @work_mas = @_;
    while (my $item = $work_mas[$i++]) {
        if ($item =~ /--colums/) {
            if (!( defined $work_mas[$i])) {
            exit;
        }
            my @col = split (/[,]/,$work_mas[$i]);
            $out{colums} = \@col;
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