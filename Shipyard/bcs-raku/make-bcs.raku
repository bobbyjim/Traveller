use v6;

my @jp = 0, 3, 5, 7,  9, 11, 13, 15, 17, 19;
my @mp = 0, 2, 4, 6, 12, 16, 18, 19, 20, 21;
my @pp = 0, 2, 3, 5,  6,  8,  9, 11, 12, 14;

my @secondaries-defense-by-tl = 0,0,0,0,0,0,0,0, 1,  8, 15, 22, 30, 38, 46,  54,  62,  70;
my @support-defense-by-tl     = 0,0,0,0,0,0,0,0, 2,  8, 14, 20, 26, 32, 36,  42,  50,  56;
my @secondaries-offense-by-tl = 0,0,0,0,0,0,0,0, 5, 15, 25, 40, 55, 70, 85,  95, 110, 125;
my @support-offense-by-tl     = 0,0,0,0,0,0,0,0, 4, 10, 20, 26, 32, 40, 45,  55,  65,  75;

sub MAIN( $name, 
		  $mission-code,
		  $TL, 
		  $armor-layers, 
		  $j, 
		  $m, 
		  $spine-vol, 
		  $spine-hits,
		  $secondary-off-vol,
		  $secondary-def-vol,
		  $support-off-vol,
		  $support-def-vol,
		  $additional-payload ) 
{
	my $av = $TL * ($armor-layers + 1);
	my $pp = ($j,$m).max;

	my $percent = ($armor-layers-1)*4;
	$percent += @jp[$j] + @mp[$m] + @pp[$pp];
	$percent += $j * 10 + $m;
	$percent += 4; # bridge and crew

	my $total-payload = $spine-vol + $secondary-def-vol + $secondary-off-vol + $support-def-vol + $support-off-vol + $additional-payload;
	my $volume = 100 * $total-payload / (100 - $percent);

    #say "$name $percent % $total-payload t payload " ~ $volume.Int ~ " tons";

	my $secondary-offense-power = calculateTotalPower(@secondaries-offense-by-tl[ $TL ].Int, $secondary-off-vol );
	my $secondary-defense-power = calculateTotalPower(@secondaries-defense-by-tl[ $TL ].Int, $secondary-def-vol );
	my $support-offense-power   = calculateTotalPower(@support-offense-by-tl[ $TL ].Int,     $support-off-vol   );
	my $support-defense-power   = calculateTotalPower(@support-defense-by-tl[ $TL ].Int,     $support-def-vol   );

    #printf( "\n\n%-15s  %2s-$m$j   %-7d tons\n\n", $name, $mission-code, $volume);
	#printf( "    armor: %2d              primary: %2d\n", $av/8, $spine-hits/8);
    #printf( "  cruiser: %2d            secondary: %2d\n", $secondary-defense-power, $secondary-offense-power);
	#printf( "  support: %2d              support: %2d\n", $support-defense-power,   $support-offense-power);

	printf("%-15s  %2s-$m$j  %2d-%d%d %d-%d%d   %7d tons. TL-%d.\n",
		$name,
		$mission-code,
		$av/8,
		$secondary-defense-power,
		$support-defense-power,
		$spine-hits/8,
		$secondary-offense-power,
		$support-offense-power,
		$volume,
		$TL
	);
}

sub calculateTotalPower( Int $rating, Int $totalVolume )
{
	return logtab(($totalVolume * $rating/100).Int);
}

sub logtab($val)
{
	return 0 if $val < 6;
	return 1 if $val < 20;
	return 2 if $val < 60;
	return 3 if $val < 200;
	return 4 if $val < 600;
	return 5 if $val < 1500;
	return 6 if $val < 4500;
	return 7 if $val < 14000;
	return 8 if $val < 40000;
	return 9; 
}
