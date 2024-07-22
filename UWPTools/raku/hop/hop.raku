

my $dice     = 10;
my $target   = 10 + 10 + 5;  


for 1..10 {
	
	my $weeks    = 0;
	my $distance = 10;

	loop {
		$weeks;
		$distance = hop($distance, $dice, $target);
		last unless $distance > 0;
	}

	say "Hopping $distance parsecs took $weeks discrete hops.";

}

sub hop( Int $distance, Int $dice, Int $target ) {
	my ($done, $blockage) = test( $dice, $target );
	say "Blockage at $blockage parsecs";
	return $
}

sub test( Int $dice, Int $target ) {
	my $result = 0;
	my $sixes  = 0;

	for 1..$dice {
		my $value = (1..6).pick;
		$sixes++ if $value == 6;
		$sixes-- if $value == 1;

		$result += $value;
	}
	return ($result <= $target, $sixes);
}
