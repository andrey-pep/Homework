package Local::MusicLibrary;

use strict;
use warnings;
use diagnostics;
use Local::MaxLen;
use base qw(Exporter);
our @EXPORT_OK = qw( table_out );
our @EXPORT = qw( table_out );
use DDP;

=encoding utf8

=head1 NAME

Local::MusicLibrary - core music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub table_out {
    my @coloms;
    my %len_hash;
    my $i = 0;
    while ( ref ( $coloms[$i] = shift ) ne "HASH" ) { $i++; }       #считываем данные о столбцах
    unshift(@_,pop (@coloms));
    my @music = @_;                                                 #и считываем массив с треками
    
    for my $item (@coloms) {
        $len_hash{$item} = max_len(@music);
    }
    
    p @coloms;
    return @music if wantarray;
    1;
}

1;
