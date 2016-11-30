package Local::MusicLibrary;

use strict;
use warnings;
use diagnostics;
use Local::MaxLen;
use base qw(Exporter);
our @EXPORT_OK = qw( table_out );
our @EXPORT = qw( table_out );
use feature 'say';
use utf8;

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
    my @columns;
    my %len_hash;
    my $i = 0;
    my $string_len = 0;
    my $columns = shift;
    #while ( ref ( $columns[$i] = shift ) ne "HASH" ) { $i++; }       #считываем данные о столбцах
    #unshift(@_,pop (@columns));
    if (@columns == 0) {
        exit;
    }
    my $music = shift;                                                 #и считываем массив с треками
    my $separator = '|';
    for my $item (@columns) {
        if (defined $item) {
            $len_hash{$item} = max_len($item,@music);
            $string_len+= $len_hash{$item} + 2;
            $separator = $separator.sprintf("%s+", '-'x($len_hash{$item} + 2));
        }
    }
    chop $separator;
    $separator = $separator.'|';
    $string_len += @columns + 1;
    printf ("/%s\\\n",'-'x($string_len - 2));
    $i = 0;
    for (@music) {       
        for my $item (@columns) {
            printf ("| %$len_hash{$item}s ", $music[$i]{$item});
        }
        print "|\n";
        last if $i == @music - 1;
        say $separator;
        $i++;
    }
    printf ("\\%s/\n",'-'x($string_len - 2));
    return @music if wantarray;
    1;
}

1;
