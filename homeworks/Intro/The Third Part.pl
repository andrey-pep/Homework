#!/usr/bin/perl
use strict;
use Data::Dumper;
use warnings;

my @massofmass=();
my $count=0;
my $input = 'text.txt';
open(my $fl, '<', $input)
        or die "Counld not open file '$input' $!";
      
while (<$fl>) {
my @timemas=();
@timemas=split(/;|\n/, $_);
@massofmass[$count] = \@timemas;
$count++;
}
print Dumper(@massofmass);
close($fl)
  or die "Counld not close file '$input' $!";
