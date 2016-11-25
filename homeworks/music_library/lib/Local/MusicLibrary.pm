package Local::MusicLibrary;

use strict;
use warnings;
use diagnostics;
use Local::MaxLen;
use base qw(Exporter);
our @EXPORT_OK = qw( table_out );
our @EXPORT = qw( table_out );
use DDP;
use feature 'say';

=encoding utf8

=head1 NAME

Local::MusicLibrary - core music library module

=head1 VERSION

Version 1.1

=cut

our $VERSION = '1.2';

=head1 SYNOPSIS

=cut

sub table_out {
    my @coloms;
    my %len_hash;
    my $i = 0;
    my $string_len = 0;
    while ( ref ( $coloms[$i] = shift ) ne "HASH" ) { $i++; }       #считываем данные о столбцах
    unshift(@_,pop (@coloms));
    my @music = @_;                                                 #и считываем массив с треками
    for my $item (@coloms) {
        $len_hash{$item} = max_len($item,@music);
        $string_len+= $len_hash{$item};
    }
    $string_len += @coloms + 1;
    print "/";
    for ($i = 0; $i<$string_len - 2; $i++) { print "-"; }
    print "\\";
    say "";
    $i = 0;
    for (@music) {
        for my $item (@coloms) {
            my $len = int($len_hash{$item}) - 2;
            printf ("| %${len}s ", $music[$i]{$item});
            
        }
        print "|\n";
        last if $i == @music - 1;
        print "|";
        for my $item (@coloms) {
            my $len = int($len_hash{$item});
            for (my $j = 0; $j < $len; $j++) {
                printf ("-");
            }
            print "+";
        }
        printf ("\b|\n");
        $i++;
    }
    print "\\";
    for ($i = 0; $i<$string_len - 2; $i++) { print "-"; }
    print "/";
    say "";
    return @music if wantarray;
    1;
}

1;
