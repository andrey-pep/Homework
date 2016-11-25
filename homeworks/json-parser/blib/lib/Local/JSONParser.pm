package Local::JSONParser;
use JSON::XS;

use strict;
#use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( parse_json );
our @EXPORT = qw( parse_json );
use DDP;
use feature 'say';
use Encode qw(encode decode);
use charnames ':full';

sub parse_json {
	my $source = shift;
	my $new_str;
	my $scope_amount1 = 0;
	my $scope_amount2 = 0;
	my $fp = -1;
my $hash;
say "this is source \n $source";
#return JSON::XS->new->utf8->decode($source);
for ($source) {
	while (pos() < length()) {
		my $key;
		if (/\G[,\s]*"([^\{\[\(\]\}\)]+?)":\s?/gsc) {				#разобраться с положением ифов, до этого это стояло в конце
			$key = $1;
			say "this is key: $1";
        }
		if (/\G[,\s]*"(["\w\\\s]+)"[,\s]*/gsc) {
			my $str = $1;
			$str =~ s/\\u(.{3,4})/my $num = hex($1); chr($num)/ge;
			$str =~ s/(\\n)/chr(10)/ge;
			$str =~ s/(\\t)/chr(9)/ge;
			$str =~ s/(\\")/chr(34)/ge;
			#$hash{$key} = $str;
			say "that1: $str";
			return $str;
		}
		elsif (/\G[,\s]*(-?\d+?[\.eE]?\d*[-+]*\d*)[,\s]*/gc) {
			#$hash{$key} = 0+$1;
			say "that2: $1";
			return $1;
		}
		elsif (/\G[\,\s]*[\[]\s*/gc) {
			my $str = "";
			$scope_amount1 = 1;
			$scope_amount2 = 0;
			while ($scope_amount1 > $scope_amount2) {
            if (/\G(.*?)(\[|\])\s?/gcs) {
				if ($2 eq '[') {$scope_amount1++; $str = $str.$1.$2;}
				elsif ($2 eq ']') {$str = $str.$1.$2; $scope_amount2++;};
			    }
			}
			chop $str;
			my @t = split (/(?<!\\[\"]),\s?/g,$str);
			say $str;
			p @t;
			my $i = 0;
			for my $item (@t) {
				say "item: '$item'";
				$item =~ s/\\u(.{3,4})/my $num = hex($1); chr($num)/ge;
				$item =~ s/(\\n)/chr(10)/ge;
				$item =~ s/(\\t)/chr(9)/ge;
				$item =~ s/(\\")/chr(34)/ge;
			}
			if ($key) {;
				$hash{$key} = (\@t);
			}
			else {return parse_json($str);}
			say "that3: $1";
		}
		elsif (/\G[\,\s]*[\{]\s*/gc) {
			my $str = "";
			$scope_amount1 = 1;
			$scope_amount2 = 0;
			while ($scope_amount1 > $scope_amount2) {
            if (/\G(.*?)(\{|\})\s?/gcs) {
				if ($2 eq '{') {$scope_amount1++; $str = $str.$1.$2;}
				elsif ($2 eq '}') {$str = $str.$1.$2; $scope_amount2++;};
			    }
			}
			chop $str;
			say $str;
			if ($key) {
				$hash{$key} = parse_json($str);
            }
			else {return parse_json($str);}
            }
	}
}
	return {%hash};
}
1;


__DATA__
elsif (/\G[\,\s]*[\{]\s*/gc) {
			$scope_amount1++;
			$fp = pos();
			my $str = "";
			my $i = $scope_amount1;
			say "am1    $scope_amount1";
			while ($scope_amount1 != $scope_amount2) {
				#say pos();
			if (/\G\s*.+?\{{$scope_amount1}\s*/cs) {
                $scope_amount1++;
				say "am1 $scope_amount1";
				say pos();
                }
			if (/\G\s*(.+?\})[,\s]*/gcs) {
                    $scope_amount2++;
					$str = $str.$1;
					say "am2  $scope_amount2";
                }
			}
			say "SHIT";
			$str = substr($source, $fp, length($str));
			say "WTF  ".$str;
			$hash{$key} = parse_json($str);
			$scope_amount1 = 0;
			$scope_amount2 = 0;
			$i = 0;
		}
		
		
		
				elsif (/\G[\,\s]*[\{]\s*/gc) {
			$fp = pos();
			my $str = "";
			my $i = $scope_amount1;
			$scope_amount1 = s/\{/\{/cg;
			pos() = $fp;
			say pos();
			say "am1    $scope_amount1";
			while ($scope_amount1 != $scope_amount2) {
			if (/\G\s*(.+?\})[,\s]*/gcs) {
                    $scope_amount2++;
					$str = $str.$1;
					say "now \n$str";
					say "am2  $scope_amount2";
                }
			}
			say "WTF1  ".$str;
			$hash{$key} = parse_json($str);
			$scope_amount1 = 0;
			$scope_amount2 = 0;
			$i = 0;
		}
		
		
		
		
package Local::JSONParser;
use JSON::XS;

use strict;
#use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( parse_json );
our @EXPORT = qw( parse_json );
use DDP;
use feature 'say';
use Encode qw(encode decode);
use charnames ':full';

sub parse_json {
	my $source = shift;
	my $new_str;
	my $scope_amount1 = 0;
	my $scope_amount2 = 0;
	my $fp = -1;
my $hash;
say "this is source \n $source";
#return JSON::XS->new->utf8->decode($source);
for ($source) {
	while (pos() < length()) {
		my $key;
		if (/\G[,\s]*"([^\{\[\(\]\}\)]+?)":\s?/gsc) {				#разобраться с положением ифов, до этого это стояло в конце
			$key = $1;
			say "this is key: $1";
        }
		if (/\G[,\s]*"(["\w\\\s]+)"[,\s]*/gsc) {
			my $str = $1;
			$str =~ s/\\u(.{3,4})/my $num = hex($1); chr($num)/ge;
			$str =~ s/(\\n)/chr(10)/ge;
			$str =~ s/(\\t)/chr(9)/ge;
			$str =~ s/(\\")/chr(34)/ge;
			#$hash{$key} = $str;
			say "that1: $str";
			return $str;
		}
		elsif (/\G[,\s]*(-?\d+?[\.eE]?\d*[-+]*\d*)[,\s]*/gc) {
			#$hash{$key} = 0+$1;
			say "that2: $1";
			return $1;
		}
		elsif (/\G[\,\s]*[\[]\s*/gc) {
			my $str = "";
			$scope_amount1 = 1;
			$scope_amount2 = 0;
			while ($scope_amount1 > $scope_amount2) {
            if (/\G(.*?)(\[|\])\s?/gcs) {
				if ($2 eq '[') {$scope_amount1++; $str = $str.$1.$2;}
				elsif ($2 eq ']') {$str = $str.$1.$2; $scope_amount2++;};
			    }
			}
			chop $str;
			my @t = split (/(?<!\\[\"]),\s?/g,$str);
			say $str;
			p @t;
			my $i = 0;
			for my $item (@t) {
				say "item: '$item'";
				$item =~ s/\\u(.{3,4})/my $num = hex($1); chr($num)/ge;
				$item =~ s/(\\n)/chr(10)/ge;
				$item =~ s/(\\t)/chr(9)/ge;
				$item =~ s/(\\")/chr(34)/ge;
			}
			if ($key) {;
				$hash{$key} = (\@t);
			}
			else {return parse_json($str);}
			say "that3: $1";
		}
		elsif (/\G[\,\s]*[\{]\s*/gc) {
			my $str = "";
			$scope_amount1 = 1;
			$scope_amount2 = 0;
			while ($scope_amount1 > $scope_amount2) {
            if (/\G(.*?)(\{|\})\s?/gcs) {
				if ($2 eq '{') {$scope_amount1++; $str = $str.$1.$2;}
				elsif ($2 eq '}') {$str = $str.$1.$2; $scope_amount2++;};
			    }
			}
			chop $str;
			say $str;
			if ($key) {
				$hash{$key} = parse_json($str);
            }
			else {return parse_json($str);}
            }
	}
}
	return {%hash};
}
1;