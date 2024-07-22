use lib '.';
use UWP;
use UwpUtil;
use Travellermap-Config;
use Sector;

BEGIN {
say q:to/BANNER/;

*****************************************************************************
╔═╗┌─┐┌─┐┌┬┐  ╔═╗┌─┐┬─┐┬ ┬┌─┐┬─┐┌┬┐
╠╣ ├─┤└─┐ │   ╠╣ │ │├┬┘│││├─┤├┬┘ ││
╚  ┴ ┴└─┘ ┴   ╚  └─┘┴└─└┴┘┴ ┴┴└──┴┘

BANNER
}

END {
say q:to/DONE/;

╔╦╗┌─┐┌┐┌┌─┐
 ║║│ ││││├┤ 
═╩╝└─┘┘└┘└─┘
*****************************************************************************

DONE
}

#
#  NOTES ON WAVE AND VIRUS CROSSING
#
#  The Wave meets Virus in the Vargr Extents along a rough circle,
#  centered on 
#

my Sector $sector = Sector.new;

sub MAIN( $sectorName ) {

    my $source = "../../../travellermap/res/t5ss/data/$sectorName.tab";
	$sector.set-name( $sectorName );
	$sector.readFile( $source );
	say $sector.summary;

	my $file   			= "config/$sectorName" ~ '-to-1900';
	my $config 			= Travellermap-Config.new;
	my @order  			= $config.parse( $file );
	print $config.summary;

	my $header			= $sector.get-header;
	my $milieu1201		= $header ~ "\n";
	my $milieuPostwave	= $header ~ "\n";
	my $milieu1508		= $header ~ "\n";
	my $milieu1900		= $header ~ "\n";
	my $allThree		= "Year\t" ~ $header ~ "\n";
	my $beginningYear	= 1105;

	for $sector.get-hex-list -> $hex {
		my UWP $uwp = $sector.get-uwp( $hex );
		my $valuable = $uwp.has-intrinsic-value;

        $allThree   ~= "$beginningYear\t" ~ $uwp.show-line ~ "\n";

		#
		#  Given the current row, return the proper order of operations.
		#
		@order = $config.get-order-by-row-in-sector( $uwp.get-row );

		for @order -> $command {
			if $command eq 'wave' {
				do-wave( $config, $uwp );
				$milieuPostwave ~= $uwp.show-line ~ "\n";
				$allThree   ~= $config.get-exit-year ~ "\t" ~ $uwp.show-line ~ "\n";

				# 1508
				$uwp.wave4-do-one-recovery-epoch(-1);
				$milieu1508 ~= $uwp.show-line ~ "\n";
				$allThree   ~= "1508\t" ~ $uwp.show-line ~ "\n";
			}
			elsif $command eq 'virus' {			
				do-virus( $config, $uwp );	
				$milieu1201 ~= $uwp.show-line ~ "\n";
				$allThree   ~= "1201\t" ~ $uwp.show-line ~ "\n";
			}
			elsif $command eq 'garden' {
				$uwp.do-garden-world;
			}
			elsif $command eq 'vargr' {
				$uwp.do-vargr-world;
			}
		}
		
		# 1900
		$uwp.wave4-do-one-recovery-epoch(0);
		$uwp.do-significant-world if $valuable;
		$milieu1900 ~= $uwp.show-line ~ "\n";
		$allThree   ~= "1900\t" ~ $uwp.show-line ~ "\n";
		$allThree   ~= "\n";
	}

    my $exit-year = $config.get-exit-year;

	"output/$sectorName.1201.tab".IO.spurt: $milieu1201; 			
	"output/$sectorName.$exit-year.tab".IO.spurt: $milieuPostwave; 	
	"output/$sectorName.1508.tab".IO.spurt: $milieu1508;
	"output/$sectorName.1900.tab".IO.spurt: $milieu1900;	
	"output/$sectorName.all.txt".IO.spurt:  $allThree;

	m: say "\tRun Time         \t ", (((now - INIT now)*10).Int / 10), ' seconds';
}

sub do-virus( $config, $uwp ) {
	if $config.do-virus($uwp.get-hex, $uwp.get-allegiance) {
		$uwp.do-virus-except-recovery;
		$uwp.virus9-recovery;
	}
}

sub do-wave( $config, $uwp ) {
	if ! $config.in-cow( $uwp.get-hex ) { 
		$uwp.do-wave-except-recovery;
		$uwp.set-allegiance( 'Wild' );
	}
}
