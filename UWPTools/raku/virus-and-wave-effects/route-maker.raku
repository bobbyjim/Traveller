

sub MAIN( $color, *@route )
{
	die "usage: draw-route color hex..." if $color ~~ /^\d+$/;

	my $prevHex = @route.shift;
	for @route -> $hex {
		say "   <Route Color=\"$color\" Start=\"$prevHex\" End=\"$hex\" />";
		$prevHex = $hex;
	}
}

