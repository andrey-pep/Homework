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
	my $op;	
	$op = shift;
	if ($op eq "(" || $op eq ")")   { return 0; };
	if ($op eq "^")                 { return 3; };
	if ($op eq "/" || $op eq "*")   { return 2; };
	if ($op eq "U-" || $op eq "U+") { return 4; };
	if ($op eq "+" || $op eq "-")   { return 1; };
	42;
}

sub op_assotiation
{
	my $op;
	$op = shift;
	my $out;
	if ($op eq "U+" || $op eq "U-" || $op eq "^") { return 1; };
    if ($op eq "+" || $op eq "*" || $op eq "/" || $op eq "-") { return 0; };
	if ($op eq "(" || $op eq ")") { return 2; };
}

sub rpn {
	my $expr = shift;
	my $source = tokenize($expr);
	my @stack;
	my @rpn;
	my $i=0;
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
				}
				else
				{
					while ((my $el = shift(@stack)) ne "(")
					{
						push(@rpn,$el);
					}
				}
            }
            
		}
		$i++;
	}
	push (@rpn,@stack);
	return \@rpn;
	1;
}

1;
