#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;
use diagnostics;
use Data::Dumper;

my $c;
my @rpn;
my $i=0;
my $a ="- 16 + 2 * 0.3e+2 - .5 ^ ( 2 - 3 )";

$a =~ tr/ //d;
my @chars= split m{((?<!e)[-+]|[*()/^]| \s+)}, $a;
while($chars[$i++]){
if($chars[$i]=~ /(\.(?=[0-9]))|[eE]/){$chars[$i]=0+$chars[$i]};
}

while ($c=$chars[$i])
{
    if($c =~ m[\s]) { }
    else {$rpn[$i]=$c; $i++;}
}

print Dumper(@rpn);
