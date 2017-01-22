use strict;
use warnings;

use Local::Reducer::MaxDiff;
use Local::Source::Text;
use Local::Row::Simple;
use Local::Reducer::Sum;
use Local::Source::Array;
use Local::Row::JSON;
use Local::Source::FileHandler;
use DDP;

my $diff_reducer = Local::Reducer::MaxDiff->new(
    top => 'received',
    bottom => 'sended',
    source => Local::Source::FileHandler->new(fh => 'Source.JSON'),
    row_class => 'Local::Row::JSON',
    initial_value => 0,
);

my $diff_result;

$diff_result = $diff_reducer->reduce_n(1);
p $diff_reducer -> reduced;
p $diff_reducer -> source;

$diff_result = $diff_reducer->reduce_all();
p $diff_reducer -> reduced;
p $diff_reducer -> source;
