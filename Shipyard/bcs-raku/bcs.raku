
my @lines = "tigress.txt".IO.lines;

my ($armor)  = @lines[2].comb(/\d+/);
my ($f1, $j2, $sand)  =  @lines[3].split(/\s+/);
my ($screen) = @lines[4].comb(/\d+/);
my ($nuke)   = @lines[5].comb(/\d+/);
my ($globe)  = @lines[6].comb(/\d+/);
my ($f2, $j4, $scrambler)  =  @lines[7].split(/\s+/);

my $defense = $armor + $sand + $screen + $nuke + $globe + $scrambler;

my ($spine) = @lines[9].comb(/d+/);

my ($f3, $j6, $lasers) = @lines[11].split(/\s+/);
my ($f4, $j8, $energy) = @lines[12].split(/\s+/);
my ($f5, $ja, $pa) = @lines[13].split(/\s+/);
my ($f6, $jc, $missiles) = @lines[15].split(/\s+/);

my ($f7, $je, $jumpDampers) = @lines[17].split(/\s+/);
my ($f8, $jg, $tractors) = @lines[18].split(/\s+/);
my ($f9, $ji, $datac) = @lines[19].split(/\s+/);
my ($fa, $jk, $inducers) = @lines[20].split(/\s+/);
my ($fb, $jm, $commc) = @lines[21].split(/\s+/);
my ($fc, $jo, $ortillery) = @lines[22].split(/\s+/);

my $attack = $spine + $lasers * $f3 
                    + $energy * $f4
					+ $pa * $f5
					+ $missiles * $f6
					+ $jumpDampers * $f7
					+ $tractors * $f8
					+ $datac * $f9
					+ $inducers * $fa
					+ $commc * $fb
					+ $ortillery * $fc
					;

say "def $defense  att $attack\n";

