package Local::JSONParser;
use JSON::XS;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( parse_json );
our @EXPORT = qw( parse_json );
use DDP;
use feature 'say';

sub parse_json {
	my $source = shift;
my %hash;
my $kek;
my $now_key;
#return JSON::XS->new->utf8->decode($source);
for ($source) {
	while (pos()+1 < length()) {
		if    (/\G[,\t\n]*?\G"([^\{\[\(\]\}\)]+?)": (\{.+?\})[,\t\n\s]+/gc) {				#разобраться с положением ифов, до этого это стояло в конце
			$hash{$1} = parse_json($2);
			say "that: $1 and $2";
        }
		elsif (/\G[,\t\n]*?"([^\{\[\(\]\}\)]+?)": "(.+?)"[,\t\n\s]*/gc) {
			my $key = $1;
			my $string = $2;
			#chop $string;
			#chop $string;
			$hash{$key} = $string;
			say "that: $1 and $2";
		}
		elsif (/\G[,\t\n]*?"([^\{\[\(\]\}\)]+?)": (-?\d+?[\.]?\d*)[,\t\n\s]*/gc) {
			$hash{$1} = 0+$2;
			say "that: $1 and $2";
		}
		elsif (/\G[,\t\n]*?"([^\{\[\(\]\}\)]+)?": \[(.+?)\][,\t\n\s]*/gcs) {
			my @t = split (/,[\s]?/,$2);
			my $i = 0;
			for my $item (@t) {
				if (/\D+/) {
				$t[$i++] =~ s/\"//gc;
				}
			}
			$hash{$1} = (\@t);
			say "that: $1 and $2";
		}
	else { pos()++; };
	}
}
say pos($source);
	say length($source);
	return {%hash};
}
1;