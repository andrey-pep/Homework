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
    while ( ref ( $columns[$i] = shift ) ne "HASH" ) { $i++; }       #считываем данные о столбцах
    unshift(@_,pop (@columns));
    if (@columns == 0) {
        exit;
    }
    my @music = @_;                                                 #и считываем массив с треками
    for my $item (@columns) {
        $len_hash{$item} = max_len($item,@music);
        $string_len+= $len_hash{$item} + 2;
    }
    $string_len += @columns + 1;
    print "/";
    print '-' x ($string_len - 2);
    print "\\";
    say "";
    $i = 0;
    for (@music) {       
        for my $item (@columns) {
            printf ("| %$len_hash{$item}s ", $music[$i]{$item});
        }
        print "|\n";
        last if $i == @music - 1;
        print '|';
        for my $item (@columns) {
            print "-" x int($len_hash{$item} + 2);
            print "+";
        }
        print ("\b|\n");
        $i++;
    }
    print '\\';
    print '-' x ($string_len - 2);
    print '/';
    say "";
    return @music if wantarray;
    1;
}

1;
