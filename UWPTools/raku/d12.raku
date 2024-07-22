
my @value;
my $total = 0;

for (^12) -> $a {
	for (^12) -> $b {
		@value[ $a + $b ]++;
		++$total;
	}
}

say "total = $total\n";

my $index = 2;
for @value -> $a {
   my $p = "%.1f".sprintf(100 * $a/$total + 0.5);
   say $index, ' ', $p, ' %';
   ++$index;
}
