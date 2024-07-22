use lib '.';
use Sector;
use UWP;

my $description = q:to/END/;
*********************************************************
*                                                       *
*   Let's find size 4 atmosphere 3 worlds. 				*
*                                                       *
*********************************************************
END

my Sector $sector = Sector.new;

sub MAIN( $sectorName ) {

    my $source = "output/$sectorName.tab";
	$sector.readFile( $source );

    my $count = 0;
	for $sector.get-hex-list -> $hex {
		my UWP $uwp = $sector.get-uwp( $hex );

		$count++ # say $uwp.get-hex ~ ' ' ~ $uwp.show-uwp ~ ' ' ~ $uwp.get-name
			if $uwp.get-siz == 4
			&& $uwp.get-atm == 3;
	}
	say "($count) $sectorName";
}
