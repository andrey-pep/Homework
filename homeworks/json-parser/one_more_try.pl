package Local::JSONParser;

use strict;
#use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( parse_json );
our @EXPORT = qw( parse_json );
use DDP;

sub parse_json {
	my $source = shift;
	my @l = ();
	my @elements = ();
	my @keys = ();
	my $i = 0;
	my $j = 0;
	my @n_parts = ();
	my @parts =split (/(".*": \[.*\],)|(".*": \{.*\},)|(".*" :\(*\),)|(".*": "\w+")| (".*": -?\d+\.?\d*)/, $source);
	while ($i<$#parts)
	{
		if (defined $parts[$i])
		{
            $n_parts[$j++] = $parts[$i];
        }
        $i++;
    }
    @parts = @n_parts;
	while (my $string = $parts[$i])
	{
		my @t = ();
		@t = $string =~ /(".+": .*)/g;
		if(defined $t[0]) {$parts[$i] = $t[0];};
		$i++;
	}
	$i = 0;
	my %hash;
	p @n_parts;
	while (my $string = $parts[$i])
	{
		my $pack;
		my $st;
		$string =~ s{^"([^\{\[\(]+)": "(.*)"}{$st = $1; $pack = $2;}e;
		$string =~ s{"(.+)": (-?\d+\.?\d*[,\n\s]?)}{$st = $1; $pack = $2;}ge;
		if(defined $st)
		{
			$hash{$st} = $pack;
		}
		if($string =~ s{^"([^\{\[\(]+)": \["?(.*?)"?\]}{$st = $1; $pack = $2;}gse)
		{
			my @t = split (/,/,$pack);
			$hash{$st} = (\@t);
		}
		if ($string =~ s{^"([^\{\[\(]+)": \{(.*)\}}{$st = $1; $pack = $2;}ge)
		{
            my %t;
			$pack =~ s{"([^\{\[\(]+)": "(.*)"}{$t{$1} = $2;}e,$pack;
			$hash{$st} = {%t};
        }
		$i++;
	}
	#p %hash;
	#print "lol\n";
	#my $string = $source;
	#while ($string)
	#{
	 #   my @t = ();
		#@t = $string =~ /(".+": -?\d+\.?\d*[,\n\s]?)/g;
		#@keys = (@keys, @t);
		#@t = $string =~ m/(".+": ".*")[,\n]/g;
	#	@keys = (@keys, @t);
	#}
	#p @keys;
	  #JSON::XS->new->utf8->decode($source);
	return {%hash};
}
1;
