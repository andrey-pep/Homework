package Local::Parse;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( add_treck make_arg_hash);
our @EXPORT = qw( add_treck make_arg_hash);
use DDP;

sub add_treck {
    my $source = shift;
    if (/\.\/(.+)\/(\d{4}) - (.+)\/(.+)\.([\w]+)\s?/g) {
        my %hash_out = (band => $1, year =>$2, album => $3, treck => $4, form => $5);
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
            print "$work_mas[$i]\n";
            my @col = split (/[,]/,$work_mas[$i]);
            $out{colums} = \@col;
        }
        
    }
    return %out;
    
}

1;