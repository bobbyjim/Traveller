use v6;

my @range = effect('00', 'CR',    0.25, -3, 1),
            effect('02', 'FR',    0.33, -2, 1),
			effect('05', 'SR',    0.5,  -1, 1),
			effect('07', 'AR',    1.0,   0, 1),
			effect('09', 'LR',    2.0,   1, 1),
			effect('12', 'DS',    3.0,   2, 1)
			;

my @stage = effect('Exp', 'Experimental', 2.0,  -3, 0.25),
            effect('Pro', 'Prototype',    1.5,  -2, 0.33),
			effect('Ear', 'Early',        1.25, -1, 0.5),
			effect('Std', '',             1.0,   0, 1),
			effect('Imp', 'Improved',     0.9,   1, 2),
			effect('Mod', 'Modified',     0.85,  2, 3),
			effect('Adv', 'Advanced',     0.8,   3, 4),
			effect('Ult', 'Ultimate',     0.75,  4, 5);

my @bulk = effect( 'VL', 'Vlight',  0.5,  0, 0.25),
           effect( 'L ', 'Light ',  0.67, 0, 0.5),
		   effect( '  ', '      ',  1.0,  0, 1.0),
		   effect( 'H ', 'Heavy ',  1.5,  0, 1.5),
		   effect( 'VH', 'VHeavy',  2.0,  0, 2.0);

my @base = { 'tons' => 4000, 'hits' => 10, 'code' => 'A' },
		   { 'tons' => 5000, 'hits' => 11, 'code' => 'B' },
		   { 'tons' => 6000, 'hits' => 12, 'code' => 'C' },
		   { 'tons' => 7000, 'hits' => 13, 'code' => 'D' },
		   { 'tons' => 8000, 'hits' => 14, 'code' => 'E' },
		   { 'tons' => 9000, 'hits' => 15, 'code' => 'F' },
		   { 'tons' => 10000, 'hits' => 16, 'code' => 'G' },
		   { 'tons' => 11000, 'hits' => 17, 'code' => 'H' },
		   { 'tons' => 12000, 'hits' => 18, 'code' => 'J' },
		   { 'tons' => 13000, 'hits' => 19, 'code' => 'K' },
		   { 'tons' => 14000, 'hits' => 20, 'code' => 'L' },
		   { 'tons' => 15000, 'hits' => 21, 'code' => 'M' },
		   { 'tons' => 16000, 'hits' => 22, 'code' => 'N' },
		   { 'tons' => 17000, 'hits' => 23, 'code' => 'P' },
		   { 'tons' => 18000, 'hits' => 24, 'code' => 'Q' },
		   { 'tons' => 19000, 'hits' => 25, 'code' => 'R' },
		   { 'tons' => 20000, 'hits' => 26, 'code' => 'S' },
		   { 'tons' => 21000, 'hits' => 27, 'code' => 'T' },
		   { 'tons' => 22000, 'hits' => 28, 'code' => 'U' },
		   { 'tons' => 23000, 'hits' => 29, 'code' => 'V' },
		   { 'tons' => 24000, 'hits' => 30, 'code' => 'W' },
		   { 'tons' => 25000, 'hits' => 31, 'code' => 'X' },
		   { 'tons' => 26000, 'hits' => 32, 'code' => 'Y' },
		   { 'tons' => 27000, 'hits' => 33, 'code' => 'Z' },
		   ;

my $tl = @*ARGS[0];
my %db;

for @base -> $spine {
	#note "$spine";
	my $tons = $spine<tons>;
	my $hits = $spine<hits>;
	my $code = $spine<code>;

	for @range -> $range {
		for @stage -> $stage {
			for @bulk -> $bulk {
				my $obj = describe( $code, $tons, $hits, $tl, $range, $stage, $bulk );
				#say "key = $obj<bcskey>";
				%db{ $obj<bcskey> } = $obj
				    if $obj<tl>   >= 7      # too low tech
					#&& $obj<hits> > 9       # too weak
					#&& $obj<tlDelta> >= -3  # too low TL mod
					#&& $obj<tlDelta> <= 6   # too high TL mod
					&& $obj<tons> >= 1000   # min tonnage
					;
			}
		}
	}
}

my @s = %db.keys.sort;
my $prevTonnage = 0;
my $prevHits    = 0;
for @s -> $key {
	my $indicator = ' ';
	if $prevTonnage >  %db{$key}<tons>
	&& $prevHits    <= %db{$key}<hits> {
		print "***";
	}

	print "\n", %db{$key}<label>, ' ';

	$prevTonnage = %db{$key}<tons>;
	$prevHits    = %db{$key}<hits>;
}

sub effect($v, $label, $siz, $tl, $hits)
{
	return {
		'code'  => $v,
		'label' => $label,
		'siz'   => $siz,
		'tl'    => $tl,
		'hits'  => $hits
	};
}

sub describe( $code, $tons, $hits, $tl, $range, $stage, $bulk ) 
{
	my $v = $tons * $range<siz>  * $stage<siz>  * $bulk<siz>;
	my $t = $tl   + $range<tl>   + $stage<tl>   + $bulk<tl>;
	my $h = ($hits * $range<hits> * $stage<hits> * $bulk<hits>).ceiling;

#    say "V: $v, T: $t, H: $h";

	my $tlDelta = $range<tl> + $stage<tl> + $bulk<tl>;
	
	# stage bulk range type
	my $label = $code ~ '  '
	  		~ $range<label> 	~ '  '
	  		~ $bulk<code>  		~ '  ' 
            ~ $stage<code> 	~ '  ' 
	  		~ "TL-$t" 			~ '  '
	  		~ sprintf("%5d t", $v) ~ '  '
	  		~ "$h h"
	  		;

	return {
		'label' => $label,
		'code' => $code,
		'tl' => $t,
		'tlDelta' => $tlDelta,
		'range' => $range,
		'tons' => $v,
		'hits' => $h,
		'bcskey' => sprintf("%2d-%s-%03d-$code-$v", $t, $range, $h),
	};
}
