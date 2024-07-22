
my $siz = (^6).pick + (^6).pick + 2;
$siz = (^6).pick + 9 if $siz == 10;

my $atm = (^6).pick - (^6).pick + $siz;
$atm = 0  if $siz == 0 || $atm < 0;
$atm = 15 if $atm > 15;

my $hyd = (^6).pick - (^6).pick + $atm;
$hyd -= 4 if $atm < 2 || $atm > 9;
$hyd = 0 if $siz < 2 || $hyd < 0;
$hyd = 10 if $hyd > 10;

say $siz.base(16) ~ $atm.base(16) ~ $hyd.base(16);

