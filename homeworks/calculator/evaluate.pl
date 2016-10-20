=head1 DESCRIPTION

Эта функция должна принять на вход ссылку на массив, который представляет из себя обратную польскую нотацию,
а на выходе вернуть вычисленное выражение

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

sub evaluate {
	my $rpn = shift;
	my $i = 0;
	my @calc_stack = ();
while (my $c=@$rpn[$i])
{
	if ($c =~ /\d/) {push(@calc_stack,$c);}
	if ($c eq '+')
	{
		my $first_op = pop(@calc_stack);
		my $second_op = pop(@calc_stack);
		push(@calc_stack, $first_op + $second_op);
	}
	if ($c eq "U+")
	{
		my $first_op = pop(@calc_stack);
		push(@calc_stack, abs($first_op));
	}
	if ($c eq "U-")
	{
		my $first_op = pop(@calc_stack);
		push(@calc_stack, $first_op * (-1));
	}
	if ($c eq '-')
	{
		my $first_op = pop(@calc_stack);
		my $second_op = pop(@calc_stack);
		push(@calc_stack, $second_op - $first_op);
	}
	if ($c eq '*')
	{
		my $first_op = pop(@calc_stack);
		my $second_op = pop(@calc_stack);
		push(@calc_stack, $first_op*$second_op);
	}
	if ($c eq '/')
	{
		my $first_op = pop(@calc_stack);
		my $second_op = pop(@calc_stack);
		push(@calc_stack, $second_op/$first_op);
	}
	if ($c eq '^')
	{
		my $first_op = pop(@calc_stack);
		my $second_op = pop(@calc_stack);
		push(@calc_stack, $second_op**$first_op);
	}
	$i++;
}
	$i = 0;
	return $calc_stack[0];
}

1;

