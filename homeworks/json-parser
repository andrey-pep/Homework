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
	my @parts =split (/(?<=[\"\d\}\]\n]),(?=[\"\n\s])/, $source);
	while (my $string = $parts[$i])
	{
		my @t = ();
		@t = $string =~ /(".+": .*)/g;
		if(defined $t[0]) {$parts[$i] = $t[0];};
		$i++;
	}
	$i = 0;
	my %hash;
	p @parts;
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
	return {%hash};
}
1;
