package Local::MusicLibrary;

use strict;
use warnings;
use diagnostics;
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
    my $i = 0;
    while ( ref ( $coloms[$i] = shift ) ne "HASH" ) { $i++; }
    unshift(@_,pop (@coloms));
    my @music = @_;
    p @coloms;
    return @music if wantarray;
    1;
}

1;
