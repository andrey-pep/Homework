=head1 DESCRIPTION
Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, содержащий обратную польскую нотацию
Один элемент массива - это число или арифметическая операция
В случае ошибки функция должна вызывать die с сообщением об ошибке
=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
use Data::Dumper;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
use FindBin;
require "$FindBin::Bin/../lib/tokenize.pl";

sub op_priorit
{
	my $oper;
	($oper) = @_;
	if (!(defined $oper))               { return 0; };
	if ($oper eq "(" || $oper eq ")")   { return 0; };
	if ($oper eq "^")                   { return 3; };
	if ($oper eq "/" || $oper eq "*")   { return 2; };
	if ($oper eq "U-" || $oper eq "U+") { return 4; };
	if ($oper eq "+" || $oper eq "-")   { return 1; };
	1;
}

sub op_assotiation
{
	my $op;
	($op) = @_;
	if (!(defined $op))                               		  { return 0; };
	if ($op eq "U+" || $op eq "U-" || $op eq "^") 			  { return 1; };
    if ($op eq "+" || $op eq "*" || $op eq "/" || $op eq "-") { return 0; };
	if ($op eq "(" || $op eq ")") 							  { return 2; };
	1;
}

sub rpn {
	my $expr = shift;
	my $source = tokenize($expr);
	my @stack;
	my @rpn;
	my $i=0;
	my $scope_flag = 0;
	while (my $c=@$source[$i])
	{
        if($c =~ /\d/) {push(@rpn,$c);}
		else
		{
			if (op_assotiation($c) == 1)
			{
                if (op_priorit($c) < op_priorit($stack[$#stack]))
				{
                    while (my $el = pop(@stack))
					{
						if ($el eq "(") {last;}
                        push(@rpn,$el);
                    }
				}
				push(@stack,$c);
            }
			if (op_assotiation($c) == 0)
			{
                if (op_priorit($c) <= op_priorit($stack[$#stack]))
				{
                    while (my $el = pop(@stack))
					{
						if ($el eq "(") {last;}
                        push(@rpn,$el);
                    }
				}
				push(@stack,$c);
			}
			if (op_assotiation($c) == 2)
			{
                 if ($c eq "(")
				{
					push(@stack,$c);
					$scope_flag += 1;
				}
				else
				{
					if ($scope_flag == 0)
						{die "Problems with scopes\n";}
					$scope_flag -= 1;
					while ((my $el = pop(@stack)))
					{
						if ($el eq "(") {last;}
						else {push(@rpn,$el);}
					}
				}
            }
            
		}
		$i++;
	}
	while (my $el = pop(@stack))
	{
        push(@rpn,$el);
    }
	$i = 0;
	return \@rpn;
	1;
}

1;
