use strict;
use warnings;

use Local::Reducer::MaxDiff;
use Local::Source::Text;
use Local::Row::Simple;
use Local::Reducer::Sum;
use Local::Source::Array;
use Local::Row::JSON;
use Local::Source::FileHandler;
use Local::Reducer::MinMaxAvg;
use DDP;

my $diff_reducer = Local::Reducer::MinMaxAvg->new(
    field => 'received',
    source => Local::Source::FileHandler->new(fh =>"Source"),
    row_class => 'Local::Row::Simple',
    initial_value => 0,
);


my $diff_result;

$diff_result = $diff_reducer->reduce_n(1);
p $diff_reducer -> source;
p $diff_reducer -> reduced;

$diff_result = $diff_reducer->reduce_all();
p $diff_reducer -> source;
p $diff_reducer -> reduced;
