use Config::TOML;
use GTX;
use UwpUtil;

class Travellermap-Config is export {

    has $!sectorName;
	has $!abbreviation;

    has Int $!sector-x;
	has Int $!sector-y;
	has Int $!virus-inflection-row;

	has Str $!order;

	has Bool $!do-wave   = False;
	has Bool $!do-virus  = False;
	has Bool $!do-garden = False;
	has Bool $!do-vargr  = False;

	has %!wave-preserve-area;
	has $!virus-preserve-allegiances	= '';
	has $!virus-kill-hexes				= '';
	has $!virus-preserve-hexes			= '';

    method get-exit-year { 
		my $exit-year = "unknown";
   		$exit-year = (1199 + 41.47 * (2 + $!sector-y)).Int.Str;
		return $exit-year;
	}

	method includes-virus  { return $!do-virus  }
	method includes-wave   { return $!do-wave   }
	method includes-garden { return $!do-garden }
	method includes-vargr  { return $!do-vargr  }

	method get-order-by-row-in-sector( Int $rowNum ) {
		my @order;
		if $rowNum < $!virus-inflection-row {
			# wave first
			@order.push( 'wave' )   if $!do-wave;
			@order.push( 'virus' )  if $!do-virus;
			@order.push( 'garden' ) if $!do-garden;
			@order.push( 'vargr'  ) if $!do-vargr;
		} else {
			# virus first
			@order.push( 'virus' )  if $!do-virus;
			@order.push( 'wave' )   if $!do-wave;
			@order.push( 'garden' ) if $!do-garden;
			@order.push( 'vargr'  ) if $!do-vargr;
		}
		return @order;
	}

	method calc-virus-inflection-row {
		$!virus-inflection-row = 0; # = no
		$!virus-inflection-row = 100 if $!sector-y < -3; # = always
		$!virus-inflection-row = 16 + ($!sector-x.abs / 3).Int if $!sector-y == -3; # Where Wave meets Virus
	}

    method sanity( $sourcefile, %cfg ) {
		die "\n\n  Error: cannot find default<order> in $sourcefile.\n\n" unless %cfg.EXISTS-KEY('default') && %cfg<default>.EXISTS-KEY('order');
		die "\n\n  Error: cannot find <location><x> or <location><y> in $sourcefile.\n\n"
			unless %cfg.EXISTS-KEY('location') && %cfg<location>.EXISTS-KEY('x') && %cfg<location>.EXISTS-KEY('y');
	}

	method parse( $sourcefile ) {	

		my $tomlfile = $sourcefile ~ '.toml';
		my $gtxfile  = $sourcefile ~ '.gtx';
		my %hash;

		my @chunks = $sourcefile.IO.basename.split('-');
		$!sectorName = @chunks[0];
		$!abbreviation = $!sectorName.substr(0,4);

		if $gtxfile.IO.e 
		{
			my $text = $gtxfile.IO.slurp;
			%hash = from-gtx( $text );
			&.sanity($gtxfile, %hash);
			say "\tGTX file         \t ", $gtxfile;	
		} 
		elsif $tomlfile.IO.e 
		{
			my $file = $tomlfile;
			%hash = from-toml( :$file );
			&.sanity($tomlfile, %hash);
			$gtxfile.IO.spurt: to-gtx(%hash); # convert
			say "\tTOML file        \t ", $tomlfile;	
			say "\tBuilt GTX file   \t ", $gtxfile;	
		} 
		else 
		{
			die "ERROR: config file not found for $gtxfile or $tomlfile";
		}

		$!sector-y = %hash<location><y>.Int;
		$!sector-x = %hash<location><x>.Int;
		&.calc-virus-inflection-row;

		$!order 	= %hash<default><order>;
		$!do-wave   = True if $!order ~~ /wave/;
		$!do-virus  = True if $!order ~~ /virus/;
		$!do-garden = True if $!order ~~ /garden/;
		$!do-vargr  = True if $!order ~~ /vargr/;

		%!wave-preserve-area = ();
		if %hash.EXISTS-KEY('cow') {
			%!wave-preserve-area<radius> = %hash<cow><radius>;
			%!wave-preserve-area<center> = %hash<cow><center>.split( ',' );
		}

		$!virus-preserve-allegiances	= '';
		$!virus-preserve-hexes			= '';
		$!virus-kill-hexes				= '';
		
		if %hash.EXISTS-KEY('virus') {
			$!virus-preserve-allegiances = %hash<virus><preserve-by-allegiances> 
				if %hash<virus>.EXISTS-KEY('preserve-by-allegiances');

			$!virus-kill-hexes = %hash<virus><kill-hexes> 
				if %hash<virus>.EXISTS-KEY('kill-hexes');

			$!virus-preserve-hexes = %hash<virus><preserve-by-hex> 
				if %hash<virus>.EXISTS-KEY('preserve-by-hex');
		}

		return $!order.split( ' ' );
	}

	method summary {
		my @out;
		push @out, "\tCOW location     \t " ~ %!wave-preserve-area<center> if %!wave-preserve-area;
		push @out, "\tVirus preserves  \t " ~ $!virus-preserve-allegiances if $!virus-preserve-allegiances;	
		push @out, "\tV preserve hexes \t " ~ $!virus-preserve-hexes       if $!virus-preserve-hexes;
		push @out, "\tV kill hexes     \t " ~ $!virus-kill-hexes           if $!virus-kill-hexes;	
		my $extras = @out.join("\n                ");

		my $waveExitYear = &.get-exit-year;

		my $out = qq:to/SECTORSUMMARY/;
	
        The "fast-forward" script ran this data up to years 1508 and 1900:
          Default order:   $!order
          Inflection Row:  $!virus-inflection-row
          Wave Exit Year:  $waveExitYear
          $extras
   <Sector Abbreviation=\"{$!abbreviation}\" Selected=\"true\" Milieu=\"M1900\">
      <Y>{$!sector-y}</Y>
      <X>{$!sector-x}</X>
      <Name>{$!sectorName}</Name>
      <DataFile Author=\"Robert Eaglestone\" Type=\"TabDelimited\">{$!sectorName}.tab</DataFile>
      <MetadataFile>{$!sectorName}.xml</MetadataFile>
   </Sector>

SECTORSUMMARY

		return $out;
	}

	method in-cow($hex) {
		return unless %!wave-preserve-area<center>;

		my @hex = Util.hex2rowcol( $hex );
    	my $dist = Util.distance( %!wave-preserve-area<center>, @hex );
		return $dist <= %!wave-preserve-area<radius>;		
	}

	method do-virus($hex, $allegiance) {		
		my $do-virus = True;
		if $!virus-kill-hexes {
			$do-virus = False;
			$do-virus = True if $!virus-kill-hexes ~~ /$hex/ || $!virus-preserve-allegiances !~~ /$allegiance/;
		}		
		$do-virus = False if $!virus-preserve-hexes ~~ /$hex/;
		return $do-virus;
	}
}
