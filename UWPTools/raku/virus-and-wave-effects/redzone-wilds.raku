use lib '.';
use Sector;

my $description = q:to/END/;
*********************************************************
*                                                       *
*   Red Zones are zones that are especially dangerous 	*
*   to to travellers. They are random areas with a   	*
*   center and a relatively uniform radius.             *
*                                                       *
*********************************************************
END

my Sector $sector = Sector.new;
my %visited;

sub MAIN( $sectorName, $col, $row, $heat ) {

    my $source = "output/$sectorName.tab";

	$sector.readFile( $source );

	#my $col = (^21).pick + 6;
	#my $row = (^29).pick + 6;
	#my $heat = 10;

	#
	#  Apply something like a cellular automaton algorithm here.
	#
	propagateRedWilds( $row, $col, $heat );

	$sector.dump;
}

sub propagateRedWilds( $row, $col, $heat ) {

    return if $row < 1 || $row > 40 || $col < 1 || $col > 32;
	return if $heat < 1;

	my $hex = sprintf( "%02d%02d", $col, $row );

	return if %visited{ $hex };
	%visited{ $hex } = 1;

	if $sector.is-wilds( $hex ) {
    	$sector.set-allegiance( $hex, 'WiFo' );
	}

	return if rand < 0.2;

	propagateRedWilds( $row+1, $col, $heat-1 );
	propagateRedWilds( $row, $col-1, $heat-1 );
	propagateRedWilds( $row-1, $col, $heat-1 );
	propagateRedWilds( $row, $col+1, $heat-1 );
}
