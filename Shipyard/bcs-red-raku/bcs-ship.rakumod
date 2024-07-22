

class BCS-Ship is export {
	has Str $!code;
	has Str $!classname;
	has Int $!jump;
	has Int $!maneuver;
	has Int $!TL;
	
	has Int $!primary-attack-factor;
	has Str $!primary-attack-type;
	has Int $!secondary-attack-factor;
	has Int $!support-attack-factor;
	has Int $!marines-attack-factor;
	has Int $!siege-attack-factor; # also doubles as ortillery
	has Str $!siege-attack-type;

	has Int $!primary-defense-factor;
	has Str $!primary-defense-type;
	has Int $!secondary-defense-factor;
	has Int $!support-defense-factor;
	has Int $!marines-defense-factor;
	has Int $!siege-defense-factor; # also doubles as ortillery
	has Str $!siege-defense-type;

	method build( $line ) {
		my ($primary-attack, $primary-defense);
		my ($siege-attack, $siege-defense);

		($!code, $!classname, $!jump, $!maneuver, $!TL,
		$primary-attack,
	    $!secondary-attack-factor,
	    $!support-attack-factor,
	    $!marines-attack-factor,
	    $siege-attack,
	    $primary-defense,
	    $!secondary-defense-factor,
	    $!support-defense-factor,
	    $!marines-defense-factor,
	    $siege-defense) = $line.words;

		($!primary-attack-factor, $!primary-attack-type) = $primary-attack.split('');
		($!siege-attack-factor, $!siege-attack-type) = $siege-attack.split('');
		
	}
}