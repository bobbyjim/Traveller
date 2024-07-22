#
# Extracts ALL data from the FULL USP.
# ASSUMES FOUR LINES ONLY.
#
my ($uspline, $batt1, $batt2, $notes)  = "plankwell.txt".IO.lines;
my $bear = $batt1;
my $batt = $batt2;

#####################################################################
#
# First make sure we got the battery lines right.
#
#####################################################################
if ($batt2 ~~ /bear/) {
	$bear = $batt2;
	$batt = $batt1;
}

#
#  Now split them into characters.
#
my @bear = $bear.split('');
my @batt = $batt.split('');

my %ship;

#####################################################################
#
# Next extract out the Crew and TL.
#
#####################################################################
%ship{ 'TL' } = 0;
if $batt1 ~~ /TL\s*\=\s*(\d+)/ {
	%ship{ 'TL' } = $0.Int;
}

%ship{ 'Crew' } = 0;
if $batt2 ~~ /Crew\s*\=\s*(\d+\,?\d+)/ {
	%ship{ 'Crew' } = $0.Str;
}

#####################################################################
#
# Now extract the notes and variables.
#
#####################################################################
my %var = ();
my @notes = $notes.split( /\.\s*/ );
for @notes -> $note {
	if $note ~~ /^\s*(\w)\s*\=\s*(\d+)/ { 
		# Y = 100
		%var{ $0.Str } = $1.Int;
		#say "Variable $note";
	}
	elsif $note ~~ /^\s*(\w+)\s*\=\s*(\w+)\s*/ {
		# Cargo = 500
		%ship{$0.Str} = $1.Str;
		#say "Note $note";
	}
	elsif $note ~~ /^\s*(\d+)\s*(.*)\s*/ {
		# Carried craft assume
		%ship{ $1.Str } = $0.Int;
		#say "Carried craft $note";
	}
}

#####################################################################
#
# Parse out the first line.
#
#####################################################################
my ($mission, $ops, $def, $off, $ftr);
my $usp;
if $uspline ~~ /^(\S+)\s+(\S+)\s+MCr\s*(\S+)\s+(\S+)\s*ton/ { 
	%ship{'Name'} = $0.Str;
	$usp = $1.Str;
	($mission, $ops, $def, $off, $ftr)  = $1.Str.split('-');
	%ship{'Mission'} = $mission;
	%ship{'Fighter Squadrons'} = $ftr;
	%ship{'MCr'}  = $2.Str;
	%ship{'Tons'} = $3.Str;
}

#
#  Figure out the character position of the USP.
#
my $usp-pos  = $uspline.index( $usp );
my $sand-pos = $usp-pos + 12;
my $repu-pos = $usp-pos + 16;
my $las-pos  = $usp-pos + 18;
my $eng-pos  = $usp-pos + 19;
my $pa-pos   = $usp-pos + 20;
my $me-pos   = $usp-pos + 21;
my $mi-pos   = $usp-pos + 22;

#####################################################################
#
# Grep out the battery factors, bearing, and total batteries.
#
#####################################################################
my ($j0, $siz, $cfg, $j, $m, $p, $compCode, $crewCode)             = $ops.split('');
my ($j1, $armor, $sand, $mesonScreen, $nukeDamper, $globe, $repu)  = $def.split('');
my ($j2, $laser, $energy, $pa, $meson, $missile)                   = $off.split(''); 

%ship{ 'Siz' } = $siz;
%ship{ 'Cfg' } = $cfg;
%ship{ 'Jump' } = $j;
%ship{ 'Manu' } = $m;
%ship{ 'Power' } = $p;
%ship{ 'ComputerModel' } = $compCode;
%ship{ 'CrewCode' } = $crewCode;

%ship<defenses><Armor> = $armor;
%ship<defenses><Sandcaster> = $sand;
%ship<defenses><MesonScreen> = $mesonScreen;
%ship<defenses><NuclearDamper> = $nukeDamper;
%ship<defenses><Globe> = $globe;
%ship<defenses><Repulsor> = $repu;

process( 'defenses', 'Sandcaster', $sand-pos );
process( 'defenses', 'Repulsor',   $repu-pos );

%ship<offenses><Laser> = $laser;
%ship<offenses><Energy> = $energy;
%ship<offenses><PA> = $pa;
%ship<offenses><Meson> = $meson;
%ship<offenses><Missile> = $missile;

process( 'offenses', 'Laser',   $las-pos );
process( 'offenses', 'Energy',  $eng-pos );
process( 'offenses', 'PA',      $pa-pos );
process( 'offenses', 'Meson',   $me-pos );
process( 'offenses', 'Missile', $mi-pos );

say %ship;

sub process( $category, $type, $position )
{
	my $bearing   = @bear[ $position ];
	my $bearingType = $type ~ ' bearing';
	
	my $batteries = @batt[ $position ];
	my $batteryType = $type ~ ' batteries';

	%ship{$category}{$bearingType} = $bearing;
	%ship{$category}{$batteryType} = $batteries;
}
