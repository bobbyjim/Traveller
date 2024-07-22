use lib '.';
use Sector;
use UWP;

my $description = q:to/END/;
*********************************************************
*                                                       *
*   Let's find the total RU of a sector. 				*
*                                                       *
*********************************************************
END

my Sector $sector = Sector.new;

sub MAIN( $sectorName ) {

    my $source = "output/$sectorName.tab";
	$sector.readFile( $source );

	my $sector-ru = $sector.calculate-sector-ru-by-polity("Rr");

    print "sector $sectorName RU = ", $sector-ru, "\n";
}