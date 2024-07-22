use UwpUtil;
use UWP;

class Sector is export {

	has %!uwps-by-hex;
	has $!header;
	has @!header;
	has Str $!sectorName;

    method set-name( Str $name ) {
		$!sectorName = $name;
	}

    method readFile( Str $source ) {
		die "ERROR: sector $source not found" unless $source.IO.e;

		my @lines;
		($!header, @lines) = $source.IO.lines;
		@!header = $!header.split(/\t/);

		for @lines -> $line {

			#  Build a hash from this UWP line and the Header line.
			my @field = $line.split(/\t/);
			my %fieldHash = @!header Z=> @field; # Zip into a hash!

			#  Build a UWP from the hash.
    		my $uwp = UWP.new;
    		$uwp.build( %fieldHash );

			%!uwps-by-hex{ $uwp.get-hex } = $uwp;
		}
	} 

	method summary {
		my @out;
		push @out, "\tUWP count:       \t " ~ %!uwps-by-hex.elems;
		return @out.join( "\n" );
	}

	method get-header { $!header }

	method significant-worlds {
		my %sw;
		for %!uwps-by-hex.values -> $uwp {
			%sw{$uwp.get-hex} = True if $uwp.has-intrinsic-value;
		}
		return %sw;
	}

	method dump {
		say @!header.join( "\t" );
		for %!uwps-by-hex.keys.sort -> $hex {
			say %!uwps-by-hex{ $hex }.show-line;
		}
	}

	method get-uwp( $hex ) { %!uwps-by-hex{ $hex } }
	method get-hex-list    { %!uwps-by-hex.keys.sort }

	method is-wilds( $hex ) { 
		return False unless %!uwps-by-hex.EXISTS-KEY( $hex );
		my UWP $uwp = &.get-uwp( $hex );
		return $uwp.allegiance-is( 'Wild' );
	}

	method has-system( $hex ) {
		return %!uwps-by-hex.EXISTS-KEY( $hex );
	}

	method set-allegiance( $hex, $alleg ) {
		return unless %!uwps-by-hex.EXISTS-KEY( $hex );
		my UWP $uwp = &.get-uwp( $hex );
		$uwp.set-allegiance( $alleg );
	}

	method find-strong-worlds {
		my @strongWorlds = ();
		for %!uwps-by-hex.values -> $uwp {
			@strongWorlds.push($uwp) if $uwp.is-strong-world;
		}
		return @strongWorlds;
	}
	
	method calculate-sector-ru {
		my $ru;
		for %!uwps-by-hex.values -> $uwp {
			my $uwp-ru = $uwp.calc-RU;
			$ru += $uwp-ru;
		}
		return $ru;
	}

	method calculate-sector-ru-by-polity( $allegiance ) {
		my $ru;
		for %!uwps-by-hex.values -> $uwp {
			if ($uwp.allegiance-is( $allegiance ))
			{
				my $uwp-ru = $uwp.calc-RU;
				$ru += $uwp-ru;
				print "RoR: ", $uwp.get-name, " ", $uwp-ru, "\n";
			}
		}
		return $ru;
	}
}