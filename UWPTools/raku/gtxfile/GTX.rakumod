=begin pod

=head1 GTX 

C<GTX> is a simplistic config file format. It supports a hash of strings and hashes.

=head1 Synopsis

	use GTX;
	my $gtx = from-gtx($myGtxText);

=end pod

unit module GTX;

grammar GTXGrammar {
    rule  TOP     { <context>+ }
    rule  context { <key> '{' <pair>+ '}' }
    rule  pair    { <key> <value> }
    token key     { \w+ }
    token value   { <-[\n]>+ }
}

class GTXActions {
	method TOP     ($/)	{ make $<context>>>.made	          }
	method context ($/)	{ make $<key>.made => $<pair>>>.made  }
	method pair    ($/)	{ make $<key>.made => $<value>.made   }
	method key	   ($/) { make $/ }
	method value   ($/) { make $/ }
}

class X::GTX::Invalid is Exception {
    has $.source;
    method message { "Error: Invalid GTX string ($.source.chars() characters)." }
}

###########################################################
#
#  Deserialize
#
###########################################################
sub from-gtx($text) is export {
	my $o = GTXGrammar.parse($text, actions => GTXActions.new);
	unless $o {
		X::GTX::Invalid.new(source => $text).throw;
	}
	return $o.made;
}
