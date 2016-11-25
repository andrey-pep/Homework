package Local::Parse;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( add_treck make_arg_hash);
our @EXPORT = qw( add_treck make_arg_hash);
use DDP;
use feature 'say';

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
            my @col = split (/[,]/,$work_mas[$i]);
            $out{colums} = \@col;
        }
        elsif ($item =~ /--([\w]{4,6})/) {
            my $key = $1;
            if ($work_mas[$i] =~ /\'(.+)\'/s) {die "problems with keys";}
            say $1;
            $out{$key} = $work_mas[$i];
        }
    }
    return %out;
    
}

1;