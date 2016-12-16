package Local::MusicLibrary;

use strict;
use warnings;
use diagnostics;
use Local::MaxLen;
use base qw(Exporter);
our @EXPORT_OK = qw( table_out );
our @EXPORT = qw( table_out );
use 5.010;
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
    my %len_hash;
    my $i = 0;
    my $string_len = 0;
    my $columns = shift;
    my $music = shift; 
    if (@$columns == 0 || @$music == 0) {
        exit;
    }
    my $separator = "\n|";
    for my $item (@$columns) {
        if (defined $item) {
            $len_hash{$item} = max_len($item,@$music);
            $string_len+= $len_hash{$item} + 2;
            $separator = $separator.sprintf("%s+", '-'x($len_hash{$item} + 2));
        }
    }
    chop $separator;
    $separator = $separator."|\n";
    $string_len += @$columns + 1;
    printf ("/%s\\\n",'-'x($string_len - 2));
    my @output;
    my $shablon = join ("", map { "| %$len_hash{$_}s " } @$columns);
    $shablon = $shablon."|";
    for my $item (@$music) {
        my $str = sprintf( $shablon, map { $$item{$_} } @$columns );
        $output[ $#output + 1 ] = $str;
    }
    {
        local $, = $separator;
        print @output;
    }
    printf ("\n\\%s/\n",'-'x($string_len - 2));
    return $music if wantarray;
    1;
}

1;
