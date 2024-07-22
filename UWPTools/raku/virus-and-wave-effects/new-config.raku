

sub MAIN($sector, $y, $x) {

	my $text = qq:to/END/;


default-order = [ "virus", "wave" ]

[location]
y = $y
x = $x

END

	my $filename = "config/$sector" ~ '-to-1900.toml';

    die "\nError: $sector config already exists!\n" if $filename.IO.e;

	$filename.IO.spurt: $text;
}
