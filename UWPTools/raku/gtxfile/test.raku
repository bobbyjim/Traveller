
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

sub from-gtx($text) is export {
	my $o = GTXGrammar.parse($text, actions => GTXActions.new);
	unless $o {
		X::GTX::Invalid.new(source => $text).throw;
	}
	return $o.made;
}

# my $test1 =q:to/END1/;
# location { 	
# 	X 	-1 	
# 	Y	-1 
# }
# farbler {
#     a   b
#     c   0101 0102 0103 0104
# }
# END1
# 
# my $test2 =q:to/END2/;
# virus {
# 	preserveAllegiances		ImDd Rr Wild HuNa VaNr
# 	killHexes				1910 1911 1910 0101 0109
# }
# END2
# 
# my $match = GTXGrammar.parse( $test1, actions => GTXActions.new );
# 
# my %h = $match.made;
# say %h;
