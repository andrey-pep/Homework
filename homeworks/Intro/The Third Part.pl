#!/usr/bin/perl
use strict;
use Data::Dumper;
use warnings;

my @massofmass=();
my $count=0;
my $input = 'text.txt';
open(my $fl, '<', $input)
        or die "Counld not open file '$input' $!";
      
while (my $row = <$fl>) {
my @timemas=();
@timemas=split(/;|\n/, $row);
@massofmass[$count] = \@timemas;
$count++;
}
print Dumper(@massofmass);
close($fl)
  or die "Counld not close file '$input' $!";
