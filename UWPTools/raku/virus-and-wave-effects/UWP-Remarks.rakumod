

class UWP-Remarks is export {

    has Str @!specialRemarks;
	has Bool $!hasNIL;
	has Str  $!NIL;

    method get-planetary-remarks( $siz, $atm, $hyd, $pop, $gov, $law, $tl ) {
		my @r;

		push @r, 'As' if $siz == $atm == $hyd == 0;
		push @r, 'De' if $hyd == 0 		  	&& 2 <= $hyd <= 9;
		push @r, 'Fl' if 10 <= $atm <= 12 	&& 1 <= $hyd <= 10; 
		push @r, 'Ga' if 6 <= $siz <= 8   	&& 5 <= $atm <= 8 					&& 5 <= $hyd <= 7;
		push @r, 'He' if 3 <= $siz <= 12	&& (2,4,7,9,10,11,12).grep($atm)	&& 0 <= $hyd <= 2;
		push @r, 'Ic' if $uwp ~~ /^..<[01]><[1..9A]>/;
		push @r, 'Oc' if $uwp ~~ /^.<[A..F]><[3..9DEF]>A/;
		push @r, 'Va' if $uwp ~~ /^.<[^0]>0/;
		push @r, 'Wa' if $uwp ~~ /^.<[3..9]><[3..9DEF]>A/;

		return @r.join(' ');
	}

	method get-population-remarks( $uwp ) {
		my @r;

        push @r, 'Cy' if $uwp ~~ /^....<[5..9A]>6<[0123]>/; # COLONY ADDED HERE.
		push @r, 'Di' if $uwp ~~ /^....000\-<[^0]>/;
		push @r, 'Ba' if $uwp ~~ /^....000\-0/;
		push @r, 'Lo' if $uwp ~~ /^....<[123]>/;
		push @r, 'Ni' if $uwp ~~ /^....<[456]>/;
		push @r, 'Ph' if $uwp ~~ /^....8/;
		push @r, 'Hi' if $uwp ~~ /^....<[9A..F]>/;

		return @r.join(' ');
	}

	method get-economic-remarks( $uwp ) {
		my @r;

		push @r, 'Pa' if $uwp ~~ /^..<[4..9]><[4..8]><[48]>/;
		push @r, 'Ag' if $uwp ~~ /^..<[4..9]><[4..8]><[567]>/;
		push @r, 'Na' if $uwp ~~ /^..<[0123]><[0123]><[6789A..F]>/;
		push @r, 'Px' if $uwp ~~ /^..<[23AB]><[1..5]><[3456]>.<[6789]>/;
		push @r, 'Pi' if $uwp ~~ /^..<[012479]>.<[78]>/;
		push @r, 'In' if $uwp ~~ /^..<[012479ABC]>.<[9A..F]>/;
		push @r, 'Po' if $uwp ~~ /^..<[2345]><[0123]>/;
		push @r, 'Pr' if $uwp ~~ /^..<[68]>.<[59]>/;
		push @r, 'Ri' if $uwp ~~ /^..<[68]>.<[678]>/;

		return @r.join(' ');
	}

	method get-climate-remarks( $uwp, Int $hz ) {
		my @r;

		push @r, 'Fr' if $hz > 1 && $uwp ~~ /^.<[2..9]>.<[1..9A]>/;
		push @r, 'Ho' if $hz < 0;
		push @r, 'Co' if $hz == 1;
		push @r, 'Tr' if $hz < 0 && $uwp ~~ /^.<[6789]><[4..9]><[3..7]>/;
		push @r, 'Tu' if $hz > 0 && $uwp ~~ /^.<[6789]><[4..9]><[3..7]>/;

		return @r.join(' ');
	}

    #
	#  If we don't already know, then respond based on the data. 
	#
    method determine-NIL( $uwp ) {
		return "(XN)"   if $uwp ~~ /^..0<[2..9DEF]>.0..\-0$/;
		return "(EXN)"  if $uwp ~~ /^..<[ABC]>.0..\-0$/;    
		return "(CXN)"  if $uwp ~~ /^..0<[2..9DEF]>.0..\-<[^0]>$/;
		return "(CEXN)" if $uwp ~~ /^..<[ABC]>.0..\-<[^0]>$/;    

        return "" 		if $uwp ~~ /^....<[0..6]>/; # pop < 7

		return "(ENIL)" if $uwp ~~ /^..<[ABC]>/;
		return "(NIL)"  if $uwp ~~ /^..<[2..9DEF]>/;

		return ""; # finally
	}

    method set-NIL( Bool $b ) {
		$!hasNIL = $b;
	}
}