use UwpUtil;

class UWP is export {

    has Str $!sector;
	has Str $!SS;
    has Str $!hex;
	has Str $!name;

	has Int $!HZ is default(0);

	has Str $!cached-uwp;

	has Str $!starport;
	has Int $!siz;
	has Int $!atm;
	has Int $!hyd;
	has Int $!pop;
	has Int $!gov;
	has Int $!law;
	has Int $!tl;
	has Int $!initial-tl-roll;
	has Int $!tl-reduction is default(0);

    has Str $!specialRemarks;

	has Str  $!NIL;
	has Str  $!calculatedNIL;

	has Str $!scout-base;
	has Str $!navy-base;
	has Str $!zone;
	has Int $!pop-mult;
	has Int $!belts;
	has Int $!ggs;
	has Str $!allegiance;

	has Str $!stars;
	has Int $!ix;
	
	has Int $!resources;
	has Int $!base-resources;
	has Int $!labor;
	has Int $!infrastructure;
	has Int $!efficiency;

	has Str $!cx;

	has Str $!nobility;
	has Int $!otherWorlds;
	has Int $!RU;

	my @d2h =  0...9, 'A'...'H', 'J'...'N', 'P'...'Z';
	my %h2d = @d2h Z=> (0..33); # ((0..9),('A'..'H'),('J'..'N'),('P'..'Z')).flat Z=> (0..33);
	
    method get-siz { $!siz }
	method get-atm { $!atm }
	method get-hyd { $!hyd }
	
	method minflux {
		my $f1 = (^6).pick - (^6).pick;
		$f1 = -1 if $f1 < 0;
		$f1 = 1  if $f1 > 0;
		return $f1;
	}

	method distance-to( $hex ) {
		return UwpUtil.distance(
			UwpUtil.hex2rowcol( $!hex ),
			UwpUtil.hex2rowcol( $hex )
		)
	}

	method roll-starport {
		my $roll = (^6).pick + (^6).pick + 2;
		$!starport = 'A' if 2 <= $roll <= 4;
		$!starport = 'B' if 5 <= $roll <= 6;
		$!starport = 'C' if 7 <= $roll <= 8;
		$!starport = 'D' if 9 == $roll;
		$!starport = 'E' if 10 <= $roll <= 11;
		$!starport = 'X' if 12 == $roll;
		$!starport = 'D' unless $!starport; # why not
	}
	
	method init-remarks {
		$!cached-uwp = '';
	}

    method get-planetary-remarks {
		my @r;
		my $str = &.study-uwp;

		push @r, 'As' if $str ~~ /^.000/;
		push @r, 'De' if $str ~~ /^..<[2..9]>0/;
		push @r, 'Fl' if $str ~~ /^..<[ABC]><[1..9A]>/;
		push @r, 'Ga' if &.is-garden-world;
		push @r, 'He' if $str ~~ /^.<[3..9ABC]><[2479ABC]><[012]>/;
		push @r, 'Ic' if $str ~~ /^..<[01]><[1..9A]>/;
		push @r, 'Oc' if $str ~~ /^.<[A..F]><[3..9DEF]>A/;
		push @r, 'Va' if $!atm == 0;
		push @r, 'Wa' if $str ~~ /^.<[3..9]><[3..9DEF]>A/;

		return @r;
	}

	method get-population-remarks {
		my @r;
		my $str = &.study-uwp;

        push @r, 'Cy' if $str ~~ /^....<[5..9A]>6<[0123]>/; # COLONY ADDED HERE.
		push @r, 'Di' if $!pop == 0 && $!tl > 0;
		push @r, 'Ba' if $!pop == 0 && $!tl == 0;
		push @r, 'Lo' if 0 < $!pop <= 3;
		push @r, 'Ni' if 4 <= $!pop <= 6;
		push @r, 'Ph' if $!pop == 8;
		push @r, 'Hi' if $!pop >= 9;

		return @r;
	}

	method get-economic-remarks {
		my @r;
		my $str = &.study-uwp;

		if 4 <= $!atm <= 9 && 4 <= $!hyd <= 8 {
			push @r, 'Pa' if $!pop == 4 || $!pop == 8;
			push @r, 'Ag' if 5 <= $!pop <= 7;
		}

		push @r, 'Na' if $str ~~ /^..<[0123]><[0123]><[6789A..F]>/;
		push @r, 'Px' if $str ~~ /^..<[23AB]><[1..5]><[3456]>.<[6789]>/;
		push @r, 'Pi' if $str ~~ /^..<[012479]>.<[78]>/;
		push @r, 'In' if $str ~~ /^..<[012479ABC]>.<[9A..F]>/;
		push @r, 'Po' if $str ~~ /^..<[2345]><[0123]>/;

		if $!atm == 6 || $!atm == 8 {
			push @r, 'Pr' if $!pop == 5 || $!pop == 9;
			push @r, 'Ri' if 6 <= $!pop <= 8;
		}

		return @r;
	}

	method get-climate-remarks( Int $hz ) {
		my @r;
		my $str = &.study-uwp;

		push @r, 'Fr' if $hz > 1 && $str ~~ /^.<[2..9]>.<[1..9A]>/;
		push @r, 'Ho' if $hz < 0;
		push @r, 'Co' if $hz == 1;
		push @r, 'Tr' if $hz < 0 && $str ~~ /^.<[6789]><[4..9]><[3..7]>/;
		push @r, 'Tu' if $hz > 0 && $str ~~ /^.<[6789]><[4..9]><[3..7]>/;

		return @r;
	}

    method show-bases {
		my $bases = '';
		return ($!navy-base  ?? $!navy-base  !! '')
		     ~ ($!scout-base ?? $!scout-base !! ' ');
	}

	method show-PBG {
		return $!pop-mult ~ $!belts ~ $!ggs;
	}

    method get-name { $!name }
    method get-hex { $!hex }
	method get-col { ($!hex / 100).Int } # e.g. 1910 is col 19
	method get-row { ($!hex % 100).Int } # e.g. 1910 is row 10
    method get-tl { $!tl }
	method get-pm { $!pop-mult }
	method get-zone { $!zone }
	method get-allegiance { $!allegiance || '' }
	method allegiance-is( $a ) { $a eq $!allegiance };

    method is-strong-world {
		#
		#  Strong Worlds require importance and Jump Capability.
		#
		#  Call it Ix 4+.  Let's test that theory.  Can you have
		#  an Importance 4 world without jump capability?
		#
		#  Say you have Starport C, TL 9, Ag Ri ... nope it's 
		#  vanishingly difficult.  So Ix 4+ is a pretty good
		#  yardstick.
		#
		return $!ix >= 4;
	}

    method is-garden-world {
		return True if 
			(6 <= $!siz <= 8) &&
			($!atm == 5 || $!atm == 6 || $!atm == 8) &&
			(5 <= $!hyd <= 7);
	}

	method is-terran-prime-world {
		# i.e. not terrible
		return True if
			(6 <= $!siz <= 9) &&
			(4 <= $!atm <= 9) &&
			(3 <= $!hyd <= 9);
	}

	method has-intrinsic-value {
		#
		#  If any of these are true, then assume this system has raw material value.
		#
		#	* is it a high-population asteroid belt?
		#	* is it Industrial?
		#	* is it Rich?
		#	* is it Agricultural?
		#
		return True if $!siz == 0 && $!pop >= 9;    # high pop Asteroid Belt.

		my @remarks = &.get-economic-remarks.flat;

		return True if @remarks.grep('In');
		return True if @remarks.grep('Ri');
		return True if @remarks.grep('Ag');

		return False;
	}

    method is-dieback(-->Bool) {
		if ($!pop == 0)
		{
			$!calculatedNIL = '';
			$!pop-mult = 0;
			$!gov      = 0;
			$!law      = 0;
			if $!starport ~~ /<[ABC]>/ {
				$!starport = ('D','E','X')[(^3).pick];
				#
				#  Let's kill the bases and set the zone to "Ruin"
				#
				$!navy-base = 'T' if $!navy-base || $!scout-base; # ruins
				$!scout-base = '';
			}
			if $!starport ~~ /<[F]>/ {
				$!starport = ('G','H','Y')[(^3).pick];
			}
			return True;
		}
		return False;
	}

	method kill-bases {
		$!navy-base = '';
		$!scout-base = '';
	}

	method add-naval-base-if-there-isnt-one {
		#
		#  This one is tricky. Since we're setting a naval base, we also have to set the starport,
		#  and that can affect the TL.
		#
		$!starport = 'B' unless $!starport le 'B';
		$!navy-base = 'N';
		&.calc-tl(0);
	}

	method add-scout-base-if-there-isnt-one {
		#
		#  This one is tricky. Since we're setting a scout base, we also have to set the starport,
		#  and that can affect the TL.
		#
		$!starport = 'D' unless $!starport le 'D';
		$!scout-base = 'S';
		&.calc-tl(0);
	}

    method set-allegiance( $alleg ) {
		$!allegiance = $alleg;
	}

#
#   Here's the keys I'm expecting in this hash:
#
#   Sector	
#   SS	
#   Hex	
#   Name	
# 	UWP	
#	Bases	
#	Remarks	
#	Zone	
#	PBG	
#	Allegiance	
#	Stars	
#	{Ix}	
#	(Ex)	
#	[Cx]	
#	Nobility	
#	W	
#	RU
#
    method build( %uwpLine ) {
		$!sector 		= %uwpLine{'Sector'};
		$!SS     		= %uwpLine{'SS'};
		$!hex			= %uwpLine{'Hex'};
		$!name			= %uwpLine{'Name'};

		&.parse( %uwpLine{'UWP'} );
		&.parseBases( %uwpLine{'Bases'} );
		&.parseNIL( %uwpLine{'Remarks'});
		&.parseSpecialRemarks( %uwpLine{'Remarks'});
		$!zone			= %uwpLine{'Zone'};
		&.parsePBG( %uwpLine{'PBG'});
		$!allegiance	= %uwpLine{'Allegiance'};
		$!stars			= %uwpLine{'Stars'};
		&.parseIx( %uwpLine{'{Ix}'});
	    &.parseEx( %uwpLine{'(Ex)'}, $!tl, $!belts, $!ggs ); 
	    &.parseCx( %uwpLine{'[Cx]'} );
	    $!nobility		= %uwpLine{'Nobility'};
	    $!otherWorlds	= %uwpLine{'W'}.Int;   
	    $!RU			= %uwpLine{'RU'}.Int;

		&.calc-NIL; # before we do things to the data!
	}

    method parseIx( $ix ) {
		my $tmp = $ix;
		$tmp ~~ s:g/<[{}\s]>//;
		$!ix = $tmp.Int;
	}

	method parseEx( $ex, $tl, $belts, $ggs ) {
		#
		#  NNNsN, where s is sign + or -
		#		
		my $sign;
		my $temp-ex = $ex;
		$temp-ex ~~ s:g/<[()\s]>//;
		my @temp-ex = $temp-ex.split('');

		if @temp-ex {
			$!resources 	 = %h2d{ @temp-ex[1] };
			$!labor     	 = %h2d{ @temp-ex[2] };
			$!infrastructure = %h2d{ @temp-ex[3] };
			$!efficiency     = @temp-ex[5].Int;
			$!efficiency = -$!efficiency if @temp-ex[4] eq '-';
			$!base-resources = $!resources;              # if tl < 8
			$!base-resources = $!resources - $belts - $ggs if $!tl >= 8;
			$!base-resources = 2 if $!base-resources < 2;  # Sanity check.  2 is the lowest roll on 2D
		} else {
			$!base-resources = (^6).pick + (^6).pick + 2;
			&.calc-resources;
			&.calc-labor;
			&.calc-infrastructure;
			&.calc-efficiency;
		}
	}

	method parseCx( $cx ) {
		$!cx = $cx;
		$!cx ~~ s:g/\W//;
	}

	method parse( $uwp ) {
		my ($garbage, $starport, $siz, $atm, $hyd, $pop, $gov, $law, $dash, $tl) = $uwp.split('');

		if ($starport ne '?') {
			$!starport = $starport;
			$!siz = %h2d{ $siz };
			$!atm = %h2d{ $atm };
			$!hyd = %h2d{ $hyd };
			$!pop = %h2d{ $pop }; 
			$!gov = %h2d{ $gov };
			$!law = %h2d{ $law };
			$!tl  = %h2d{ $tl };
		} else {
			&.roll-starport;
			&.roll-sah;
			&.reroll-pop;	
			&.reroll-gov-and-law;
			&.kill-bases;
			$!zone = '';
			&.roll-belt-and-gg;
			$!initial-tl-roll = (^6).pick + 1;
			&.calc-tl(0);
			$!base-resources = (^6).pick + 1 + (^6).pick + 1;
			&.calc-extensions-and-RU;
		}

		# determine initial TL roll
		$!initial-tl-roll = $!tl;

		if ($!pop > 0)
        {
		   $!initial-tl-roll -= 6 if $!starport eq 'A';
		   $!initial-tl-roll -= 4 if $!starport eq 'B';
		   $!initial-tl-roll -= 2 if $!starport eq 'C';
		   $!initial-tl-roll -= 1 if $!starport eq 'F';
		   $!initial-tl-roll += 4 if $!starport eq 'X';

	   	   $!initial-tl-roll -= 2 if $!siz <= 1;
		   $!initial-tl-roll -= 1 if 2 <= $!siz <= 4;

	   	   $!initial-tl-roll -= 1 if $!atm <= 3;
		   $!initial-tl-roll -= 2 if $!atm >= 10;

	   	   $!initial-tl-roll -= 1 if $!hyd == 9;
		   $!initial-tl-roll -= 2 if $!hyd == 10;

	   	   $!initial-tl-roll -= 1 if $!pop < 6;
		   $!initial-tl-roll -= 2 if $!pop == 9;
		   $!initial-tl-roll -= 4 if $!pop >= 10;

	   	   $!initial-tl-roll -= 1 if $!gov == 0 || $!gov == 5;
		   $!initial-tl-roll -= 2 if $!gov == 13;
		}
	}

	method parseBases( $bases ) {
		&.kill-bases;

		$!scout-base = 'S' if $bases ~~ /S/;
		$!scout-base = 'W' if $bases ~~ /W/;
		$!navy-base  = 'N' if $bases ~~ /N/;
		$!navy-base  = 'D' if $bases ~~ /D/;
	}

	method parsePBG( $pbg ) {
		$!pop-mult = ($pbg/100).Int;
		$!belts    = (($pbg % 100)/10).Int;
		$!ggs      = $pbg % 10;
	}

    method parseNIL( $remarks ) {
		# we're looking for something like "(Shriekers)"
		$!NIL = $1 if $remarks ~~ /\(.*?\)/;
		# that's it, we're done.
	}
	
	method parseSpecialRemarks( $remarks ) {

		# Kill These: 
		#
		# As De Fl Ga He Ic Oc Va Wa 
		# Di Ba Lo Ni Ph Hi
		# Pa Ag Na Px Pi In Po Pr Ri
		# Cy Mr Cp Cs Cx O:xxxx
		#

		$!specialRemarks = $remarks ~ ' ';
		$!specialRemarks ~~ s:g/(As|De|Fl|Ga|He|Ic|Oc|Va|Wa|Di|Ba|Lo|Ni|Ph|Ni|Ph|Hi|Pa|Ag|Na|Px|Pi|Pz|Da|Fo|In|Po|Pr|Ri|Cy|Mr|Cp|Cs|Cx|O\:\d\d\d\d) //;
		$!specialRemarks ~~ s/^\s+//;
		$!specialRemarks ~~ s/\s+$//;
	}

    #
	#  Calculate based on the data. 
	#
	#  Commented out for now.
	#
    method calc-NIL {
		#my $str = &.study-uwp;

		$!calculatedNIL = "";

		#$!calculatedNIL = "(XN)"   if $str ~~ /^..0<[2..9DEF]>.0..\-0$/;			# extinct
		#$!calculatedNIL = "(EXN)"  if $str ~~ /^..<[ABC]>.0..\-0$/;    			# extinct
		#$!calculatedNIL = "(CXN)"  if $str ~~ /^..0<[2..9DEF]>.0..\-<[^0]>$/;		# extinct
		#$!calculatedNIL = "(CEXN)" if $str ~~ /^..<[ABC]>.0..\-<[^0]>$/;    		# extinct

		#$!calculatedNIL = "(ENIL)" if $str ~~ /^..<[ABC]>.<[789A..F]>/;
		#$!calculatedNIL = "(NIL)"  if $str ~~ /^..<[2..9DEF]>.<[789A..F]>/;
	}

	method calc-tl( $tldm ) {
		return if $!pop == 0;

		$!tl = $!initial-tl-roll + $tldm;
		$!tl += 6 if $!starport eq 'A';
		$!tl += 4 if $!starport eq 'B';
		$!tl += 2 if $!starport eq 'C';
		$!tl += 1 if $!starport eq 'F';
		$!tl -= 4 if $!starport eq 'X';

		$!tl += 2 if $!siz <= 1;
		$!tl += 1 if 2 <= $!siz <= 4;
		$!tl += 1 if $!atm <= 3;
		$!tl += 2 if $!atm >= 10;
		$!tl += 1 if $!hyd == 9;
		$!tl += 2 if $!hyd == 10;
		$!tl += 1 if $!pop < 6;
		$!tl += 2 if $!pop == 9;
		$!tl += 4 if $!pop >= 10;
		$!tl += 1 if $!gov == 0 || $!gov == 5;
		$!tl += 2 if $!gov == 13;

		$!tl = 0 if $!tl < 0;
	}

    method calc-resources {
		$!resources = $!base-resources if $!tl < 8;
		$!resources = $!base-resources + $!belts + $!ggs if $!tl >= 8;
	}

    method calc-importance {
		$!ix = 0;

		$!ix = 1 if $!starport ~~ /<[AB]>/;
		++$!ix   if $!tl >= 10;
		++$!ix   if $!tl >= 16;  # bump for TLG+
		--$!ix   if $!starport ~~ /<[DEX]>/;
		--$!ix   if $!tl <= 8;
		--$!ix   if $!pop <= 6;

		my $str = &.get-population-remarks
		        ~ &.get-economic-remarks;

		++$!ix   if $str ~~ /Ag/;
		++$!ix   if $str ~~ /Hi/;
		++$!ix   if $str ~~ /In/;
		++$!ix   if $str ~~ /Ri/;

		my $bases = &.show-bases;
		++$!ix    if $bases ~~ /(NS|W|CK|D)/;
	}

	method calc-labor {
		$!labor = $!pop - 1;
		$!labor = 0 if $!pop == 0;
	}

    method calc-infrastructure {
		$!infrastructure = $!ix;                          # pop 123
		$!infrastructure += ((^6).pick+1) if $!pop >= 4;  # pop 456 = +1D
		$!infrastructure += ((^6).pick+1) if $!pop >= 7;  # pop 7+  = +2D total
		$!infrastructure = 0 if $!pop == 0;
		$!infrastructure = 0 if $!infrastructure < 0;
	}

	method calc-efficiency {
		$!efficiency = (^6).pick - (^6).pick;
		$!efficiency = 1 if $!efficiency == 0;	           # convenience
	}

	method calc-extensions-and-RU {
		&.calc-importance;
		&.calc-resources;
		&.calc-labor;
		&.calc-infrastructure;
		&.calc-efficiency;
		&.calc-RU;
		&.calc-cx;
	}

	method calc-RU {
		$!RU  = $!resources;			# R
		$!RU *= $!labor || 1;			# L
		$!RU *= $!infrastructure || 1;	# I 
		$!RU *= $!efficiency;			# E
	}

	method calc-cx {

		$!cx = "0000" if $!pop == 0;
		return if $!pop == 0;

		my $heterogeneity = $!pop + (^6).pick - (^6).pick;
		my $acceptance    = $!pop + $!ix;
		my $strangeness   = (^6).pick - (^6).pick + 5;
		my $symbols		  = (^6).pick - (^6).pick + $!tl;

		$heterogeneity = 1 if $heterogeneity < 1;
		$acceptance    = 1 if $acceptance < 1;
		$strangeness   = 1 if $strangeness < 1;
		$symbols  	   = 1 if $symbols < 1;

		$!cx =  @d2h[ $heterogeneity ].Str;
		$!cx ~= @d2h[ $acceptance ].Str;
		$!cx ~= @d2h[ $strangeness ].Str;
		$!cx ~= @d2h[ $symbols ].Str;
	}
	
	method show-nobility( $remarks ) {

#		&.study-uwp;
#		my @remarks = &.get-planetary-remarks.flat,
#				     &.get-population-remarks.flat,
#				     &.get-economic-remarks.flat,
#				     &.get-climate-remarks($!HZ).flat,
# 				     $!specialRemarks;
#
#		my $remarks = @remarks.join( ' ' );

		my @nobility = ('B');
		@nobility.push('c') if $remarks ~~ /Pa|Pr/;
		@nobility.push('C') if $remarks ~~ /Ag|Ri/;
		@nobility.push('D') if $remarks ~~ /Pi/;
		@nobility.push('e') if $remarks ~~ /Ph/;
		@nobility.push('E') if $remarks ~~ /In|Hi/;
		@nobility.push('f') if $!ix >= 4 && $remarks !~~ /Cp|Cs|Cx/;
		@nobility.push('F') if $remarks ~~ /Cp|Cs/;

		$!nobility = @nobility.join('');
		return $!nobility;
	}

    method adjust-pop( Int $amount ) {
		$!pop += $amount;
		$!pop = 0 if $!pop < 0;
		$!pop = 15 if $!pop > 15;
	}

	method adjust-pm( Int $amount ) {
		return if $!pop == 0;

		$!pop-mult += $amount;
		if ($!pop-mult <= 0) {
			$!pop-mult += 9;
			&.adjust-pop(-1);
			&.is-dieback();
		} elsif ($!pop-mult > 9) {
			$!pop-mult -= 9;
			&.adjust-pop(1);
		}
	}

	method adjust-tl( Int $amount ) {
		return if $!pop == 0;

		$!tl += $amount;
		$!tl = 0 if $!tl < 0;
	}

    method halve-pm {
		return if $!pop == 0;

		$!pop-mult = $!pop-mult div 2;
		if ($!pop-mult == 0) 
		{
			$!pop-mult = 5;
			$!pop--;
			&.is-dieback;
		}
	}

    method reduce-starport-by-one {
		&.destroy-starport if $!starport eq 'E';
		$!starport = 'E' if $!starport eq 'D';
		$!starport = 'D' if $!starport eq 'C';
		$!starport = 'C' if $!starport eq 'B';
		$!starport = 'B' if $!starport eq 'A';
	}

	method destroy-starport {
		$!starport = 'X';
		$!scout-base = '';
		$!navy-base = '';
	}

    method randomize-transient-population {
		return if $!pop == 0;
        $!pop = (^3).pick + 1;
		$!pop-mult = (^9).pick + 1;
	}

	method randomize-low-population {
		loop {
			$!pop = (^6).pick + (^6).pick;
			last if 0 < $!pop < 7;
		}
		$!pop-mult = (^9).pick + 1;
	}

	method roll-sah {
		$!siz = (^6).pick + (^6).pick;
		$!siz = (^6).pick + 9 if $!siz == 10;

		$!atm = $!siz + (^6).pick - (^6).pick;
		$!atm = 0 if $!atm < 0 || $!siz == 0;
		$!atm = 15 if $!atm > 15;

		$!hyd = $!atm + (^6).pick - (^6).pick;
		$!hyd -= 4 if $!atm < 2 || $!atm > 9;
		$!hyd = 0 if $!hyd < 0 || $!siz < 2;
		$!hyd = 10 if $!hyd > 10;
	}

	method roll-belt-and-gg {
		$!belts = (^6).pick - 3;
		$!belts = 0 if $!belts < 0;

		$!ggs = (((^6).pick + (^6).pick)/2 - 1).Int;
		$!ggs = 0 if $!ggs < 0;
	}

	method reroll-pop {
		$!pop = (^6).pick + (^6).pick;
		$!pop-mult = 0;
		$!pop-mult = (^9).pick + 1 if $!pop > 0;
	}

    method reroll-gov {
		$!gov = 0 if $!pop == 0;
		return if $!pop == 0;
 	    $!gov = $!pop - 7 + (^6).pick + 1 + (^6).pick + 1;
		$!gov = 7 if $!gov == 6;	# we're not going to allow a Colony Gov.
		$!gov = 0 if $!gov < 0;
	}

	method reroll-law( $dm ) {
		$!law = 0 if $!pop == 0;
		return if $!pop == 0;
		$!law = $!gov - 7 + (^6).pick + 1 + (^6).pick + 1 + $dm;
		$!law = 0 if $!law < 0;
	}

	method reroll-gov-and-law {
		&.reroll-gov;
		&.reroll-law(0);
		$!cached-uwp = '';
	}

    #
	#  Try to cache the call to show-uwp for trade remark use.
	#
    method study-uwp {
		$!cached-uwp = &.show-uwp unless $!cached-uwp;
		return $!cached-uwp;
	}
	
 	method show-uwp {
		my @out;
		@out.push( $!starport, 
				@d2h[ $!siz ],
				@d2h[ $!atm ],
		        @d2h[ $!hyd ],
		        @d2h[ $!pop ],
		        @d2h[ $!gov ],
		        @d2h[ $!law ],
		        '-',
	 	        @d2h[ $!tl ] );
		return @out.join('');
	}

    method show-uwp-Ix {
		return '{ ' ~ $!ix ~ ' }';
	}

	method show-uwp-Ex {
		&.calc-resources;
		my $out = @d2h[ $!resources      ];
		$out   ~= @d2h[ $!labor          ];
		$out   ~= @d2h[ $!infrastructure ];
		$out   ~= '-' if $!efficiency < 0;
		$out   ~= '+' if $!efficiency >= 0;
		$out   ~= @d2h[ $!efficiency.abs ];
		return "($out)";
	}

	method show-uwp-Cx {
		return "[$!cx]";
	}

    method virus0-init {
		$!zone = '';
		$!cx = "0000";
	}

    #
	#  MODIFIED:
	#
	#  The Virus process is here modified to account for native intelligent life,
	#  which by T5 is half of the population of a POP 9+ world, and most of the pop
	#  of a POP 8- world.
	#
    method virus1a-kill-inhospitable-worlds(-->Bool) {
		return unless $!atm ~~ /<[0123ABC]>/;

		# So NIL here means adapted to the exotic environment.

		$!pop = 0 		unless $!NIL;			# 100% off-worlders
		&.halve-pm      if $!NIL && $!pop >= 9;	# 50% off-worlders
		&.adjust-pm(-1) if $!NIL && $!pop <= 8; # 10% off-worlders

		return &.is-dieback;
	}

    method virus1b-cap-population {
		return if $!pop == 0;

		my $max = 10;
		$max = 8 if $!siz ~~ /<[1234]>/;
		$max = 9 if $!siz ~~ /<[567]>/;
		$max--   if $!atm ~~ /<[579]>/;
		$max-=2  if $!atm ~~ /<[4]>/;
		$max-=3  if $!atm ~~ /<[DEF]>/;
		$max--   if $!hyd ~~ /<[12A]>/;
		$max-=2  if $!hyd ~~ /<[0]>/;

		$!pop = (^10).pick if $!pop > $max;
		&.reroll-gov-and-law unless &.is-dieback;
	}

	method virus23-damage-tl {
	   return if $!pop == 0;

	   if $!tl < 9 {
	      $!tl-reduction = ((^6).pick - 2);	# 1D-3
		  $!tl-reduction = 0 if $!tl-reduction < 0;
	   } elsif $!tl < 11 {
          $!tl-reduction = ((^6).pick + 1);	# 1D
	   } elsif $!tl < 14 {
	      $!tl-reduction = ((^6).pick + 1) + ((^6).pick + 1); # 2D
	   } else {
	      $!tl-reduction = ((^6).pick + 1) + ((^6).pick + 1) + ((^6).pick + 1); # 3D
	   }
	   &.adjust-tl(-$!tl-reduction);
	   &.adjust-pm( ceiling(-$!tl-reduction/4) );
	   return $!tl;	
	}

	method virus4-low-pop {
		return if $!pop > 5 || $!pop == 0;
		&.adjust-tl(-1);
		&.halve-pm;
	}

	method virus56-starport-and-bases {
	   if ($!pop == 0)
	   {
		  &.destroy-starport;
		  return;
	   }

       my $r = (^6).pick + 1;

	   if ($r < $!tl-reduction) {
		  &.destroy-starport;
		  return;
	   }
	   
	   if $r <= $!tl-reduction {
		  &.reduce-starport-by-one;
   
          my $d10 = (^10).pick + 1;

          $!navy-base  = '' if $!navy-base eq 'D' && $d10 < 10;
		  $!navy-base  = '' if $!navy-base eq 'N' && $d10 < 9;

          $!scout-base = '' if $!scout-base eq 'W' && $d10 < 10;
		  $!scout-base = '' if $!scout-base eq 'S' && $d10 < 8;

		  return;
	   }

       #
	   # $r == $!tl-reduction.  Hit it twice and kill the bases.
       #
       &.reduce-starport-by-one;
       &.reduce-starport-by-one;
	   $!scout-base = '';
	   $!navy-base  = '';
	}

	method virus78-balkanized-ted {
		return if $!pop == 0;

		my $balkanization-number = $!siz + $!pop - $!tl;
		my $roll = (^6).pick + 1 + (^6).pick + 1;
		if $roll <= $balkanization-number {
			$!zone = 'B'; # balkanized
		}

		if ($!pop >= 5) && ((^10).pick + 1) < $!tl-reduction {
		   $!gov = 6; # TED
		   &.reroll-law(4);
		} else {
		   &.reroll-gov-and-law;
		}
	}

	method virus9-recovery {
		return if $!pop == 0;

		#
		#  PUNT until we fully accept the consequences of TNE's 
		#  aggressive recovery rates.
		#
		&.randomize-transient-population if 1 <= $!pop <= 3;
		&.adjust-pm(1) if $!pop >= 4;

		&.calc-extensions-and-RU;
	}

    method wave0-init {
		$!zone = '';
		$!cx = "0000";
	}

	method wave1-check-ni {
		return unless 4 <= $!pop <= 6;

		my $bad-flux = (^6).pick - (^6).pick;
		$bad-flux = -$bad-flux if $bad-flux > 0;
		&.adjust-pop( $bad-flux ) if $bad-flux < 0;
	}

	method wave2-check-lo {
		return unless $!pop < 4;
		$!pop = 0;
		&.is-dieback;
	}

	method wave3-check-he {
		return unless (3 <= $!siz <= 12) 
		           && ($!atm == 2 | 4 | 7 | 9 | 10 | 11 | 12) 
				   && (1 <= $!hyd <= 10);

		my $bad-flux = (^6).pick - (^6).pick;
		&.adjust-pop( $bad-flux ) if $bad-flux < 0;
		$!pop = 0 if $!pop <= 6;
		&.is-dieback;
	}

	method wave4-do-one-recovery-epoch( $tlmod ) {
		&.adjust-pm( &.minflux() );
		&.adjust-tl( &.minflux() );
		&.reroll-gov-and-law;
		&.calc-tl( $tlmod );
		&.calc-extensions-and-RU;
	}		

	method do-virus-except-recovery {
	   &.virus0-init;
	   if ! &.virus1a-kill-inhospitable-worlds {
		   &.virus1b-cap-population;
	   }
	   &.virus23-damage-tl;
	   &.virus4-low-pop;
	   &.virus56-starport-and-bases;
	   &.virus78-balkanized-ted;

	   &.calc-extensions-and-RU;
	}

	method do-wave-except-recovery {
		&.wave0-init;
		&.wave1-check-ni;
		&.wave2-check-lo;
		&.wave3-check-he;
		
		if ! &.is-dieback {
			&.halve-pm;
			&.reroll-gov-and-law;
			&.calc-tl(-2)
		}

		&.calc-extensions-and-RU;
	}

	method do-garden-world {
		# intended as a post-wave, post-virus phenomena:
		# barren garden worlds might get a small population.
		return unless &.is-garden-world;
		return unless $!pop == 0;

		&.roll-starport;
		&.randomize-low-population;
		&.reroll-gov-and-law;
		&.calc-tl(0);
												# &.set-allegiance('GaHu');    don't bother
		&.calc-extensions-and-RU;
	}

	method do-significant-world {
		
		# for worlds that are deemed valuable enough to re-colonize

		&.roll-starport;
		&.reroll-pop;
		$!starport = 'D' if $!pop == 0 && $!starport le 'D';
		
		&.reroll-gov-and-law;
		&.calc-tl(0);
		&.calc-extensions-and-RU;
	}

	method do-vargr-world {

		# intended as a post-wave, post-virus phenomena:
		# vargr garden worlds get a population.

		&.do-significant-world;
		&.set-allegiance('NaVa');
	}

	method show-line {
		my @remarks = &.get-planetary-remarks.flat,
				     &.get-population-remarks.flat,
				     &.get-economic-remarks.flat,
				     &.get-climate-remarks($!HZ).flat,
				     $!specialRemarks;

		my $remarks = @remarks.sort.join( ' ' ) ~ ' ';
		$remarks ~= $!NIL || $!calculatedNIL;
		$remarks ~~ s/^\s+//;

		my @out;
		@out.push( $!sector, 
			$!SS, 
			$!hex, 
			$!name, 
			&.show-uwp, 
			&.show-bases, 
			$remarks,
			&.get-zone,
			&.show-PBG,
			$!allegiance,
			$!stars,
			&.show-uwp-Ix,
			&.show-uwp-Ex,
			&.show-uwp-Cx,
			&.show-nobility($remarks),
			$!otherWorlds,
			$!RU
		);
		return @out.join( "\t" );
	}
}
