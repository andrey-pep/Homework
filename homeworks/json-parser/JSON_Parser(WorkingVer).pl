package Local::JSONParser;
use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( parse_json );
our @EXPORT = qw( parse_json );

sub parse_json {
	my $source = shift;
my %hash;
for ($source) {
	while (pos() < length()) {
		my $key;
		if (/\G[,\s]*"([^\{\[\(\]\}\)]+?)":\s?/gsc) {
			$key = $1;
        }
		if (/\G\s*\"([^"\\]*)\s*/gc) {
			my $str = $1;
			while(!(/\G"/gc)) {
				if (/\G\\([nt])/gc)
                {
                    if ($1 eq 'n')
                    {
                       $str = $str."\n";
                    }
                    else
                    {
                       $str = $str."\t";
                    }
                }
                elsif(/\G\\"/gc)
                {
                    $str = $str.'"';
                }
                elsif(/\G\\u(\d{3,4})/gc)
                {
                    my $tmp = chr(hex $1);
                    $str = $str.$tmp;
                }
                elsif (/\G\\/gc)
                {
                    die "error";
                }
                else
                {
                    /\G([^"\\]*)\s*/gc;
                    $str = $str.$1;
                }
			}
			if ($key) {
				$hash{$key} = $str;
			}
			else {return $str;}
		}
		elsif (/\G[,\s]*(-?\d+?[\.eE]?\d*[-+]*\d*)[,\s]*/gc) {
			if ($key) {
				$hash{$key} = $1;
            }
			else {return $1;}
		}
		elsif (/\G[\,\s\:]*[\[]\s*/gc) {
			my $str = "";
			my $scope_amount1 = 1;
			my $scope_amount2 = 0;
			my @t;
			my $i = 0;
			while ($scope_amount1 > $scope_amount2) {
            if (/\G(.*?)(\[|\])\s?/gcs) {
				if ($2 eq '[') {$scope_amount1++; $str = $str.$1.$2;}
				elsif ($2 eq ']') {$str = $str.$1.$2; $scope_amount2++;};
			    }
			}
			chop $str;
			p @t;
			if ($str =~ /^[\{\[]/m) { $t[$i++] = parse_json($str);}
			else {
			@t = split (/(?<!\\["])(?<=["\d]),(?= ?[\"\d\}\]])\s?/s,$str);
			p @t;
			for(@t) {
				$t[$i]= parse_json($t[$i]);
				$i++;
			}
			}
			if ($key) {
				$hash{$key} = \@t;
            }
			else {return \@t;}
        }
		elsif (/\G[\,\s]*[\{]\s*/gc) {
			my $str = "";
			my $scope_amount1 = 1;
			my $scope_amount2 = 0;
			while ($scope_amount1 > $scope_amount2) {
            if (/\G(.*?)\s?(\{|\})\s?/gcs) {
				if ($2 eq '{') {$scope_amount1++; $str = $str.$1.$2;}
				elsif ($2 eq '}') {$str = $str.$1.$2; $scope_amount2++;};
			    }
			}
			chop $str;
			if ($key) {
				$hash{$key} = parse_json($str);
            }
			else {return parse_json($str);}
            }
		else
			{die "There's some problems with JSON";}
	}
}
	return {%hash};
}
1;
