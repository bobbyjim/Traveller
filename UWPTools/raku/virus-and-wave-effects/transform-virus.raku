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

    $uwp.virus0-init;
	if ! $uwp.virus1a-kill-inhospitable-worlds {
		$uwp.virus1b-cap-population;
	}
	sayTheCurrentState "1 Hit POP";

	$uwp.virus23-damage-tl;
	sayTheCurrentState "2,3 Damage TL";

    $uwp.virus4-low-pop;
	sayTheCurrentState "4 Low Pops";

	$uwp.virus56-starport-and-bases;
	sayTheCurrentState "5,6 Starport and Bases";

	$uwp.virus78-balkanized-ted;
	sayTheCurrentState "7,8 Balkanize and TED";

	$uwp.virus9-recovery;
	sayTheCurrentState "9 Recovery";

	say '';
}

sub sayTheCurrentState( Str $rowTitle )
{
	say "$rowTitle \t", '', "\t", '', "\t", '', "\t", $uwp.show-uwp, "\t", $uwp.get-bases, "\t", $uwp.get-zone, "\t", $uwp.get-pm;
}