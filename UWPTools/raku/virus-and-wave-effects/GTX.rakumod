=begin pod

=head1 GTX 

C<GTX> is a simplistic config file format. It supports a hash of strings and hashes.

=head1 Synopsis

	use GTX;
	my $gtx = from-gtx($myGtxText);

=end pod

unit module GTX;

grammar GTXGrammar {
    rule  TOP     { \s* <context>+ }
    rule  context { <key> '{' <pair>+ '}' }
    rule  pair    { <key> <value> }
    token key     { <[\w-]>+ }

   proto token value   {*}
         token value:sym<line>   { <-[`\n]>+ }   # not backtick nor newline
         token value:sym<list>   { \`<lv> }		 # lists start with backtick

   token lv         { <-[\n]>+ }				 # to newline
}

class GTXActions {
	method TOP     ($/)	{ make $<context>>>.made	          }
	method context ($/)	{ make $<key>.made => $<pair>>>.made.flat.hash  }
	method pair    ($/)	{ make $<key>.made => $<value>.made   }
	method key	   ($/) { make ~$/ }
    method value:sym<line> ($/)   { make ~$/ }
    method value:sym<list> ($/)   { make $<lv>.split(/\,\s*/) }		# lists are CSV to newline 
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

###########################################################
#
#  Serialize
#
###########################################################
sub to-gtx(%hash) is export {
	my $out = '';

	for %hash.keys -> $context {
		$out ~= $context;
		$out ~= ' {';
		$out ~= "\n";
		my %h2 = %hash{ $context }.hash;
		for %h2.keys -> $k {
			$out ~= '   ';
			$out ~= $k;
			$out ~= "\t";
			$out ~= %h2{$k};
			$out ~= "\n";
		}
		$out ~= '}';
		$out ~= "\n";
	}

	return $out;
}
