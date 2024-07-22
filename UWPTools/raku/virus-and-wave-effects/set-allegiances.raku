use lib '.';
use UWP;

sub MAIN( $sector, $allegiance, *@hexes ) {

	#say "Sector:       \t $sector";
	#say "Allegiance:   \t $allegiance";
    #say "Hexes:        \t ", @hexes;

    my $sourceFile = "output/$sector.tab";
	die "$sourceFile not found." unless $sourceFile.IO.e;

	my ($header, @lines) =$sourceFile.IO.lines;
	my @header = $header.split(/\t/);

    say $header;
	for @lines -> $line {
		next if $line ~~ /\?\?\?\?\?\?\?\-\?/;

		#  Build a hash from this UWP line and the Header line.
		my @field = $line.split(/\t/);
		my %fieldHash = @header Z=> @field; # Zip into a hash!

		#  Build a UWP from the hash.
    	my $uwp = UWP.new;
    	$uwp.build( %fieldHash );

		#  Wipe the allegiance if it's the one we're setting.
		$uwp.set-allegiance('Wild') if $uwp.get-allegiance() eq $allegiance;

		#  Set it if it's one of our hexes.
		$uwp.set-allegiance($allegiance) if so @hexes.grep($uwp.get-hex);

		say $uwp.show-line;
	}

}