use lib '.';
use UWP;
use Sector;

my $description = q:to/END/;
*********************************************************
*                                                       *
*  Reprocess Sector.   This is useful when you're       *
*  manually editing the sector.                         *
*                                                       *
*********************************************************
END

my Sector $sector = Sector.new;

sub MAIN( $sectorName, *@hexes ) {

    my $source = "output/$sectorName.tab";
	$sector.readFile( $source );

	@hexes = $sector.get-hex-list unless @hexes;

    for @hexes -> $hex {
		if $sector.has-system($hex) {
			my UWP $uwp = $sector.get-uwp( $hex );
			$uwp.calc-tl(0);
			$uwp.calc-extensions-and-RU;
		}
	}

	$sector.dump;
}
