use lib '.';
use UWP;
use Sector;

my $description = q:to/END/;
*********************************************************
*                                                       *
*   Survivor States are pocket empires. They typically  *
*   have an irregular radius.                         	*
*                                                       *
*********************************************************
END

my Sector $sector = Sector.new;
my %visited;

sub MAIN( $sectorName ) {

    my $source = "$sectorName.tab";
	$sector.readFile( $source );

	my $chosen = pickAStrongWorld( $sector, $sectorName );				# random strong world
	my $alleg = ('A'..'Z').pick ~ ('a','e','i','o','u','y').pick;		# random 2 char allegiance
	$chosen.set-allegiance( $alleg );

    #*****************************************************************
    #
	#  Now use a combination of random walk and cellular operations
	#  to grow a pocket empire. 
	#
    #*****************************************************************
	my $col = $chosen.get-col;
	my $row = $chosen.get-row;
	my $run = (^6).pick + 1;

	for 1..$run {
		claimArea($row-1, $col, $alleg) if rand < 0.5;
		claimArea($row+1, $col, $alleg) if rand < 0.5;
		claimArea($row, $col-1, $alleg) if rand < 0.5;
		claimArea($row, $col+1, $alleg) if rand < 0.5;
	}

    #*****************************************************************
    #
	#  Now scan the sector and normalize any split empires.
	#
    #*****************************************************************
#	%visited = ();
#	for $sector.get-hex-list -> $hex {
#		next if %visited{ $hex };			
#
#		my $uwp = $sector.get-uwp( $hex );
#		%visited{ $hex }++;
#
#		my $oldAlleg = $uwp.get-allegiance;
#		next if $oldAlleg eq 'Wild';
#
#		my $newAlleg = ('A'..'Z').pick ~ ('a','e','i','o','u','y').pick;
#		$uwp.set-allegiance( $newAlleg );
#		spread-by-allegiance( $uwp.get-col, $uwp.get-row, $oldAlleg, $newAlleg );
#	}

	$sector.dump;
}

sub pickAStrongWorld( $sector, $sectorName ) {
	#
	#  Let's put the strong worlds in a list and pick one randomly.
	#
	my @strongWorlds = $sector.find-strong-worlds;
	die "No strong worlds found in $sectorName!\n" unless @strongWorlds.elems > 0;

	my $choice = (0..@strongWorlds.elems-1).pick;	
	my $chosen = @strongWorlds[ $choice ];

    my $ok = so $chosen;

    unless $ok {
		die @strongWorlds.elems, " strong worlds found in $sectorName\n";
		exit;
	}

	return $chosen;
}

sub claimArea( $row, $col, $alleg ) {

    return if $row < 1 || $row > 40 || $col < 1 || $col > 32;
	my $hex = sprintf( "%02d%02d", $col, $row );

	return if %visited{ $hex };
	%visited{ $hex } = 1;

	$sector.set-allegiance( $hex, $alleg );

	claimArea($row-1, $col, $alleg) if rand < 0.5;
	claimArea($row+1, $col, $alleg) if rand < 0.5;
	claimArea($row, $col-1, $alleg) if rand < 0.5;
	claimArea($row, $col+1, $alleg) if rand < 0.5;
}

#sub spread-by-allegiance( $col, $row, $oldAlleg, $newAlleg ) {
#	my $hex = sprintf( "%02d%02d", $col, $row );
#	return if %visited{ $hex };
#	%visited{ $hex } = 1;
#
#	my $uwp = $sector.get-uwp($hex);
#	return if $uwp && $uwp.get-allegiance ne $oldAlleg;
#	$uwp.set-allegiance( $newAlleg ) if $uwp;
#
#	spread-by-allegiance( $col-1, $row, $oldAlleg, $newAlleg ) if $col > 1;
#	spread-by-allegiance( $col, $row-1, $oldAlleg, $newAlleg ) if $row > 1;
#	spread-by-allegiance( $col+1, $row, $oldAlleg, $newAlleg ) if $col < 32;
#	spread-by-allegiance( $col, $row+1, $oldAlleg, $newAlleg ) if $row < 40;
#}
