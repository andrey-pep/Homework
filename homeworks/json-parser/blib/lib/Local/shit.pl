#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use DDP;
use JSON::XS;

@ARGV or die "Usage:\n\tperl $0 file\n";
my $file = shift @ARGV;

open my $f, '<:raw', $file or die "Can't open file `$file': $!\n";
my $source = do { local $/; <$f> };
close $f;

my $data = JSON::XS->new->utf8->decode($source);
p $data;