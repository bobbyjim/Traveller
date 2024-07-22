use lib '.';
use Sector;

my $description = q:to/END/;
*********************************************************
*                                                       *
*   Hot Zones are zones that are resistant to jump due 	*
*   to the accumulation of heat in jumpspace. They are 	*
*   random areas with a short random walk.              *
*                                                       *
*********************************************************
END

my Sector $sector = Sector.new;

sub MAIN( $sectorName ) {

    my $source = "output/$sectorName.tab";
	$sector.readFile( $source );

	my $epochs = (^6).pick + 1 + (^6).pick + 1;

    for 1..$epochs -> $iteration {
		my $col = (^21).pick + 6;
		my $row = (^29).pick + 6;
		my $heat = (^6).pick + 1 + (^6).pick + 1 + (^6).pick + 1;

		#
		#  Apply something like a cellular automaton algorithm here.
		#
		propagateHotzone( $row, $col, $heat, $iteration );
	}

	$sector.dump;
}

sub propagateHotzone( $row, $col, $heat, $iter ) {

    return if $row < 1 || $row > 40 || $col < 1 || $col > 32;
	return if $heat < 1;

	my $hex = sprintf( "%02d%02d", $col, $row );
	
   	$sector.set-allegiance( $hex, 'HoZ' ~ $iter );

	my $next = (^4).pick;
	my $d    = ($heat % 2) + 1;

	propagateHotzone( $row+$d, $col, $heat-1, $iter ) if $next == 0;
	propagateHotzone( $row, $col-$d, $heat-1, $iter ) if $next == 1;
	propagateHotzone( $row-$d, $col, $heat-1, $iter ) if $next == 2;
	propagateHotzone( $row, $col+$d, $heat-1, $iter ) if $next == 3;
}
