use strict;
use warnings;
use Local::Reducer::Sum;
use Local::Source::Array;
use Local::Row::JSON;
use Local::Source::Text;
use Local::Reducer::MaxDiff;
use 5.010;
use DDP;

my $sum_reducer = Local::Reducer::MaxDiff->new(
    top => 'received',
    bottom => 'sended',
    source => Local::Source::Text->new(text =>"sended:1024,received:2048\nsended:0,received:0\nsended:2048,received:10240"),
    row_class => 'Local::Row::Simple',
    initial_value => 0,
);


my $sum_result;

$sum_result = $sum_reducer->reduce_n(2);
print $sum_result."\n";
p $sum_reducer -> reduced;

$sum_result = $sum_reducer->reduce_all();

print $sum_result."\n";
print $sum_reducer -> reduced;

p $sum_reducer -> source;