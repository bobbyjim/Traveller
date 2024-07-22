

say "\n";

# say "███    ███ ██  ██████  ██████   █████  ████████ ███████ ";
# say "████  ████ ██ ██       ██   ██ ██   ██    ██    ██      ";
# say "██ ████ ██ ██ ██   ███ ██████  ███████    ██    █████   ";
# say "██  ██  ██ ██ ██    ██ ██   ██ ██   ██    ██    ██      ";
# say "██      ██ ██  ██████  ██   ██ ██   ██    ██    ███████ ";
# say "                                                        ";
# say "                                                        ";


# say "                                                                                          ";
# say ".sSSSsSS SSsSSSSS SSSSS .sSSSSs.    .sSSSSSSSs. .sSSSSs.    .sSSSSSSSSSSSSSs. .sSSSSs.    ";
# say "S SSS  SSS  SSSSS S SSS S SSSSSSSs. S SSS SSSSS S SSSSSSSs. SSSSS S SSS SSSSS S SSSSSSSs. ";
# say "S  SS   S   SSSSS S  SS S  SS SSSS' S  SS SSSS' S  SS SSSSS SSSSS S  SS SSSSS S  SS SSSS' ";
# say "S..SS       SSSSS S..SS S..SS       S..SSsSSSa. S..SSsSSSSS `:S:' S..SS `:S:' S..SS       ";
# say "S:::S       SSSSS S:::S S:::S`sSSs. S:::S SSSSS S:::S SSSSS       S:::S       S:::SSSS    ";
# say "S;;;S       SSSSS S;;;S S;;;S SSSSS S;;;S SSSSS S;;;S SSSSS       S;;;S       S;;;S       ";
# say "S%%%S       SSSSS S%%%S S%%%S SSSSS S%%%S SSSSS S%%%S SSSSS       S%%%S       S%%%S SSSSS ";
# say "SSSSS       SSSSS SSSSS SSSSSsSSSSS SSSSS SSSSS SSSSS SSSSS       SSSSS       SSSSSsSS;:' ";
# say "                                                                                          ";

# say " .S_SsS_S.    .S    sSSSSs   .S_sSSs     .S_SSSs    sdSS_SSSSSSbs    sSSs  ";
# say ".SS~S*S~SS.  .SS   d%%%%SP  .SS~YS%%b   .SS~SSSSS   YSSS~S%SSSSSP   d%%SP  ";
# say "S%S `Y' S%S  S%S  d%S'      S%S   `S%b  S%S   SSSS       S%S       d%S'    ";
# say "S%S     S%S  S%S  S%S       S%S    S%S  S%S    S%S       S%S       S%S     ";
# say "S%S     S%S  S&S  S&S       S%S    d*S  S%S SSSS%S       S&S       S&S     ";
# say "S&S     S&S  S&S  S&S       S&S   .S*S  S&S  SSS%S       S&S       S&S_Ss  ";
# say "S&S     S&S  S&S  S&S       S&S_sdSSS   S&S    S&S       S&S       S&S~SP  ";
# say "S&S     S&S  S&S  S&S sSSs  S&S~YSY%b   S&S    S&S       S&S       S&S     ";
# say "S*S     S*S  S*S  S*b `S%%  S*S   `S%b  S*S    S&S       S*S       S*b     ";
# say "S*S     S*S  S*S  S*S   S%  S*S    S%S  S*S    S*S       S*S       S*S.    ";
# say "S*S     S*S  S*S   SS_sSSS  S*S    S&S  S*S    S*S       S*S        SSSbs  ";
# say "SSS     S*S  S*S    Y~YSSY  S*S    SSS  SSS    S*S       S*S         YSSP  ";
# say "        SP   SP             SP                 SP        SP                ";
# say "        Y    Y              Y                  Y         Y                 ";
# say "                                                                           ";
# 

say "     dBBBBBBb  dBP dBBBBb dBBBBBb dBBBBBb  dBBBBBBP dBBBP ";
say "          dBP                 dBP      BB                 ";
say "   dBPdBPdBP dBP dBBBB    dBBBBK   dBP BB   dBP   dBBP    ";
say "  dBPdBPdBP dBP dB' BB   dBP  BB  dBP  BB  dBP   dBP      ";
say " dBPdBPdBP dBP dBBBBBB  dBP  dB' dBBBBBBB dBP   dBBBBP    ";
say "                                                          ";


sub MAIN( $milieu, $sector, $allegiance ) {

	say "Source Milieu:\t $milieu";
	say "Sector:       \t $sector";
	say "Allegiance:   \t $allegiance";

    my $sourceFile = "../../../travellermap/res/Sectors/$milieu/$sector.tab";

	say "$sourceFile not found." unless $sourceFile.IO.e;

	my ($header, @lines) =$sourceFile.IO.lines;
	my @header = $header.split(/\t/);

	if $allegiance eq '?' {
		my %allegianceIndex;
		for @lines -> $line {
			next if $line ~~ /\?\?\?\?\?\?\?\-\?/;

			#  Build a hash from this UWP line and the Header line.
			my @field = $line.split(/\t/);
			my %fieldHash = @header Z=> @field; # Zip into a hash!

			my $key = 'Allegiance';
			$key = 'Alleg' if %fieldHash.EXISTS-KEY('Alleg');

			%allegianceIndex{ %fieldHash{ $key } }++;
		}

		say "Allegiance codes present:";
		for %allegianceIndex.keys -> $key {
			say "   $key\t(", %allegianceIndex{$key}, ")";
		}
	}
}