use v6;

my %identifiers = 
	'Battle'  => [4, 5, 8, 8, 0, 200000, 120],
	'Cruiser' => [4, 6, 6, 6, 4, 50000,  25],
	'Escort'  => [4, 7, 3, 3, 0, 4000,   2],
;

my %oMods = 
	'none'   => [0,0, 0,  0, 0, 0, 0, 0, 1.0, 1.0],
	'Beam'   => [0,0, 1, -2, 1, 1, 0,-2, 1.0, 1.0],
	'Raider' => [0,0, 1, -1,-1,-1,-1,-1, 0.6, 0.6],
;

my %dMods = 
	'none'   => [0,0, 1.0, 0, 0, 0, 0, 0, 1.0,  1.0],
	'Vheavy' => [-1,0,2.0, 0, 1, 1, 0, 0, 2.5,  3.0],
	'Long'   => [1,0, 1.0, 0, 0, 0, 0, 0, 1.0,  1.0],
	'Fleet'  => [0,0, 1.0, 0, 0, 1, 0, 0, 1.25, 1.5],
;

makeShip('Tigress',   17, 'Battle Beam Vheavy');
makeShip('Lightning', 12, 'Cruiser Raider Long');
makeShip('Sloan',      0, 'Escort none Fleet');

sub makeShip($name, $pri, $characteristics)
{
	my ($ident, $oMod, $dMod) = $characteristics.split(' ');
	my ($j,  $m,  $off, $def, $troops, $vol, $ru) = %identifiers{ $ident };
	my ($j1, $m1, $o1, $o2, $o3, $o4, $o5, $o6, $ov, $or) = %oMods{ $oMod };
	my ($j2, $m2, $d1, $d2, $d3, $d4, $d5, $d6, $dv, $dr) = %dMods{ $dMod };

    $j += $j1 + $j2;
	$m += $m1 + $m2;
	$o1 += $pri;
	$o3 += $off;
	$o4 += $off;
	$o5 += $troops;
	$d2 += $def;
	$d3 += $def;
	$d5 += $troops;
	$vol *= $ov * $dv;
	$ru  *= $or * $dr;

	$o2 = 0 if $o2 < 0;
	$o6 = 0 if $o6 < 0;

	say "$j$m $o1-$o2$o3$o4$o5$o6-$d1$d2$d3$d4$d5$d6 $vol tons, $ru RU";
}