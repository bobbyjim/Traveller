use lib '.';
use UWP;

my ($header, @lines) = @*ARGS[0].IO.lines;
my @header = $header.split(/\t/);
my $uwp = UWP.new;

say "Stage \t Sector \t Hex \t Name \t UWP \t Bases \t Zone \t Pop Mult";
for @lines -> $line {

	next if $line ~~ /\?\?\?\?\?\?\?\-\?/;

	my @field = $line.split(/\t/);
	my %fieldHash = @header Z=> @field; # Zip into a hash!
    $uwp.build( %fieldHash );	

	say "1105 Starting Data\t", @field[0], "\t", @field[2], "\t", @field[3], "\t", $uwp.show-uwp, "\t", $uwp.get-bases, "\t", $uwp.get-zone, "\t", $uwp.get-pm;

    $uwp.wave0-init;
    $uwp.wave1-check-ni;
	sayTheCurrentState "1 Check Ni";

    $uwp.wave2-check-lo;
	sayTheCurrentState "2 Check Lo";

	$uwp.wave3-check-he;
	sayTheCurrentState "3 Check He";

	if ! $uwp.is-dieback {

		$uwp.halve-pm;
		sayTheCurrentState "4 Halve PM";

		my $tlReduction = 2;
		$uwp.adjust-tl( -$tlReduction );
		sayTheCurrentState "5 Reduce TL";
	}

    #
	#  Recovery process
	#
	for 1500, 1900 -> $year {
		$uwp.wave4-do-one-recovery-epoch;
		sayTheCurrentState "Y" ~ $year;
	}

	say '';
}

sub sayTheCurrentState( Str $rowTitle )
{
	say "$rowTitle \t", '', "\t", '', "\t", '', "\t", $uwp.show-uwp, "\t", $uwp.get-bases, "\t", $uwp.get-zone, "\t", $uwp.get-pm;
}