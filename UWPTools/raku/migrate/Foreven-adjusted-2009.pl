
print "Sector\tSS\tHex\tName\tUWP\tBases\tRemarks\tZone\tPBG\tAllegiance\tStars\t{Ix}\t(Ex)\t[Cx]\tNobility\tW\tRU\n";

foreach my $line (<DATA>) {
	next unless $line =~ /^(.{16})(\d\d\d\d) (.......-.) (.)   ...............(.) (...) (..) (.+)\s*$/;

	my %hash = (
		'Sector'     => 'Fore',
		'SS'	     => &calcSubsectorLetter($2),
		'Name'       => &generateSurveyNumber($3),
		'Hex'        => $2,
		'UWP'        => $3,
		'Bases'      => $4,
		'Remarks'    => '',
		'Zone'       => $5,
		'PBG'        => $6,
		'Allegiance' => $7,
		'Stars'      => $8,
		'W'          => &calcTotalWorlds($6)
	);

	$hash{ 'Stars' } =~ s/\t//g; # just in case

	print join("\t", 
		$hash{ 'Sector' },
		$hash{ 'SS' },
		$hash{ 'Hex' },
		$hash{ 'Name' },
		$hash{ 'UWP' },
		$hash{ 'Bases' },
		$hash{ 'Remarks' },
		$hash{ 'Zone' },
		$hash{ 'PBG' },
		$hash{ 'Alleiance' },
		$hash{ 'Stars' },
		$hash{ '{Ix}' },
		$hash{ '(Ex)' },
		$hash{ '[Cx]' },
		$hash{ 'Nobility' },
		$hash{ 'W' },
		$hash{ 'RU' }
	);
	print "\n";
}

sub calcSubsectorLetter
{
	my $hex = shift;
	my @ss = 'A'..'P'; # 0..15
	my ($col, $row) = $hex =~ /(..)(..)/;
	$col = int(($col-1)/8);
	$row = int(($row-1)/10);
	return $ss[ int($col) + 4 * int($row) ];
}

sub generateSurveyNumber
{
	my $uwp = shift;
	my @uwp = split '', $uwp;
	my %starportCode = (
		'A' => 0,
		'B'	=> 2,
		'C' => 4,
		'D' => 6,
		'E' => 8,
		'X' => 10
	);

	return sprintf( "%03d-%s%s%X", 
			int(rand(1000)), # 3 digit initial
			int($uwp[2]/1.5),
			$uwp[4],
			$starportCode{$uwp[0]} + int(rand(3))
	);
}

sub calcTotalWorlds
{
	my $pbg = shift;
	my ($p, $b, $g) = split '', $pbg;
	return 1 + $b + $g + int(rand(6)+1) + int(rand(6)+1);
}

__DATA__
EZJAVRCHA       0103 C5829BA-A     Hi               614 Zh G3 V
Fadishivr       0104 A000465-C Z   As Ni            233 Zh A3 II
Tlensheplie     0202 B376669-A     Ag Ni            925 Zh M4 V   M9 D   M5 VI
Frinzhqlekl     0203 A851868-A     Po               201 Zh K8 V
Odlaj           0302 C251662-9     Ni Po            202 Zh F9 V
Iatsvlabl       0304 B435424-C     Ni               204 Zh K3 V
Anzplefral      0305 B654335-B     Lo Ni            705 Zh G3 V   M1 D 
Tefechij        0306 A321868-C Z   Na Po            314 Zh M2 II
Brajshtaz       0308 X525000-0     Ba Lo Ni       R 005 Zh K0 V   M4 V 
Chanzqlibr      0309 A465301-D Z   Lo Ni            200 Zh G4 III
Tledlziad       0401 B313454-E Z   Ic Ni            704 Zh M3 V
Stietlid        0402 A676402-C     Lo Ni            803 Zh A7 V
SHIVVA          0403 A456AA8-E Z   Hi Cp            324 Zh G2 V
Diachiniem      0404 A450546-E Z   De Ni Po         204 Zh F8 V
Zhodrkradl      0408 A477521-A Z   Ag Ni            104 Zh K1 V   M3 V 
Niaql           0502 B2427AB-B Z   Po               400 Zh G0 V 
Izdeprjdia      0503 B5A3421-B     Fl Ni            104 Zh M5 V   M8 D
Ezh Zafr        0504 B997541-B Z   Ag Ni            704 Zh G4 III
Ishitlidl       0505 E000778-8     As Na            724 Zh K5 V
Planchiefl      0507 D78A27A-6     Lo Ni Wa         402 Zh K6 V
PADREBR         0508 B5139CB-D Z   Hi Ic Na         805 Zh M5 V   M7 D 
Antneflkra      0604 C578636-7 Z   Ag Ni            703 Zh G9 V   M8 D
Dliablsa        0607 X458000-0     Ba Lo Ni       R 015 Zh G3 III M3 V
Dliatsia        0610 C533754-7     Na Po            704 Zh F9 V   M4 D
Pa Flavr        0708 B7745AA-A Z   Ag Ni            200 Zh G1 V
Ezh Etsia       0801 C537652-8 Z   Ni               803 Zh G4 V
Seqi            0807 A75A766-E     Wa               201 Zh G2 V
Sutiano         0810 C779876-8                    A 912 Zh F9 V
Ojovshala       0902 B572367-9     Lo Ni            324 Zh G2 V
Friazhdial      0908 B724522-A     Ni               924 Zh G1 V
Jdatshiedl      0909 C1407AD-8     De Po            013 Zh F1 V
SHTIEM          0910 B68799C-D Z   Hi               204 Zh G5 V
Viplshanch      1007 C3116AB-A Z   Ic Na Ni         203 Zh K2 V
Ezh Bova        1102 B230567-D Z   De Ni Po         103 Zh G9 V
Vrarnjiavl      1103 B000414-C Z   As Ni            202 Zh M3 V   M6 D 
Yejaple         1109 C465764-6     Lo Ni            712 Zh F5 V   M2 D  
Rabrplibli      1205 C0006AD-A     As Na Ni         323 Zh F6 V   M5 D
Jiatsar         1209 C5838AE-7                    A 710 Zh F3 V
Apltla          1303 C887778-7     Ag Ri            202 Zh F9 V
Fliaza          1304 C250231-6 Z   De Lo Ni Po      813 Zh G5 V
Shiplielot      1307 B666446-B Z   Lo Ni            804 Zh G2 V
Flieflienz      1403 B511122-C     Ic Lo Ni         310 Zh M1 V   M6 D
LIEBER          1404 A6939A6-D Z   Hi In            113 Zh G3 V   M9 D
Inzens          1405 B325678-C Z   Ni               303 Zh G9 V
Stablolins      1410 C564589-7     Ag Ni            402 Zh G4 V
Prozashiz       1501 E95A788-5     Wa               305 Zh G5 V
Shetsodrev      1504 E43456A-7     Ni               310 Zh G0 V 
Lianzhjinj      1507 C9B2269-A     Fl Lo Ni         214 Zh K4 IV  M6 V
Chiazeaz        1602 C270331-6     De Lo Ni         300 Zh K4 V
Ezh Ieets       1701 A320220-C     De Lo Ni Po      302 Zh G3 V   M1 D 
Jdieshaqra      1703 A211368-E     Ic Lo Ni         304 Zh K8 V
Frapi           1704 X541000-0                    R 005 Zh M1 V   M5 D
Blibrafli       1804 B695668-6     Ag Ni            603 Zh K6 V
Tladree         1806 A642369-9     Lo Ni Po         101 Zh G3 V
Ibiedl          1807 A411576-E     Ic Ni            815 Zh M3 V
Tseplezvie      1808 A533664-A     Na Ni Po         803 Zh F1 V
Qrikliev        1901 X638000-0     Ba Lo Ni       R 000 Zh F9 V
Entians         1905 B684778-8 Z   Ag Ri            623 Zh G4 V
Eqrebr          2002 B246362-C     Lo Ni            105 Zh M8 II  M3 V
Ezh Kadep       2003 C76678C-5     Ag Ri            105 Zh G3 V
Ratanshont      2005 X530000-0     Ba De Lo Ni Po R 004 Zh M3 V   M4 D
Oplzenzh        2102 B100679-B Z   Na Ni Va         604 Zh F7 V   M9 D  M3 D
Ziatip          2103 C320726-9     De Na Po         402 Zh G8 IV
Pepraet         2202 A3017BF-C Z   Ic Na Va       A 400 Zh M7 V   M5 D  
Caglop          2209 D592654-3     Ni               400 Na G2 V
Praienz         2304 B310330-D Z   Lo Ni            403 Zh M6 V
Zhdejtlia       2306 X100000-0     Ba Lo Ni Va    R 004 Zh M1 V   M9 D
Dybun           2309 X567000-0     Ba Lo Ni       R 004 Na F6 V
Sayploc         2310 E237262-7     Lo Ni            305 Na G1 V
STABLSTIAIQL    2501 C100A8A-C     Hi In Na         304 Zh K4 V
Aba             2502 E623646-7     Na Ni Po       A 923 Zh M6 V   M8 D  M6 D
Zhebronzebl     2505 A246442-A     Ni               604 Zh G1 V   M0 D 
KLOIABR         2602 C87A967-A Z   Hi In Wa         920 Zh K8 V   M8 D  M9 D
Bivreble        2603 C887588-5     Ag Ni            700 Zh M4 V
Azesiatl        2607 C223333-B Z   Lo Ni Po         615 Zh M9 V   M2 D 
Stiviaz         2608 X776000-0     Ba Lo Ni       R 002 Zh K9 V
Idlzhatl        2610 X757000-0     Ba Lo Ni       R 004 Zh G0 V
Inshzdans       2710 B100445-E X   Ni Va            214 Zh M7 V
Siablibriats    2805 C8B669A-9     Fl Ni            802 Zh M7 V
Prafniedr       2807 B200100-9     Lo Ni            134 Zh M4 V   M4 D
Siapriao        2808 E778452-8     Ni               500 Zh M9 V
Pliakrdla       2905 A9C6474-D X   Fl Ni            913 Zh G9 V
Yim             2907 E547423-5     Ni               805 Zh M2 V   K5 D  M6 D
Zdiiel          2910 E672310-6     Lo Ni            814 Zh G4 V
Nel Stiad       3003 B4657X9-9     Ag Ri          R 623 Dr M3 V   K2 D
Brimatij        3006 DAB5552-8     Fl Ni            725 Zh M9 V   M3 D 
Tiens Parde     3107 B664651-6     Ag Ni Ri         602 Zh G3 III M3 V 
Nianshse        3108 C648358-6 Z   Lo Ni            312 Zh M5 V   M7 D 
Zde'dier        3201 C200534-7     Ni               202 Zh G3 V
Iasha           3204 C431411-B Z   Ni Po            414 Zh M2 V   M9 D 
Jdiaiekl        3205 C333654-8     Na Ni Po         513 Zh M6 V   M3 D 
Bri'zdapienz    3206 C300743-8     Na Va            614 Zh F0 V   M8 D 
Zdata           0112 B652579-A     Ni Po            801 Zh G9 V   M8 D
Zabl            0113 B53667B-8     Ni               202 Zh F5 V
Azhdots         0116 AAB8656-B     Fl Ni            822 Zh K3 V
Azh             0211 C459759-9                      401 Zh G5 V
Ientsyopr       0212 XAC5000-0     Ba Fl Lo Ni    R 004 Zh A3 II
Dled            0213 X404000-0     Ba Ic Lo Ni Va R 004 Zh K6 V
Vratsie         0214 B6A2566-9     Fl Ni            704 Zh K1 V
Ponchviaq       0218 D566600-7     Ag Ni            103 Zh G0 V
PIEPLOV         0312 A000973-E Z   As Hi In Na Cp   125 Zh F5 V   M8 D 
Brieria         0411 B9A5899-B                      105 Zh K3 V   M5 D
Epriatlech      0412 C666663-7 Z   Ag Ni Ri         705 Zh G4 V
Piesh           0418 B352688-A Z   Po               623 Zh G5 V
Dumosif         0513 B5628X8-8     Ri             R 312 Dr F8 V
Aflebshaql      0516 A886758-A Z   Ag Ri            302 Zh G9 V   M4 D
Dliadizh        0517 C765454-7 Z   Ni               304 Zh G9 V   M8 D
Maple           0520 D9C8115-7     Fl Lo Ni         402 Na K2 IV
Bianz           0612 B666653-A     Ag Ni Ri         401 Zh G3 V 
Drensblebl      0712 B7A28BB-B Z   Fl               503 Zh K4 V
Plibradr        0716 E549456-9     Ni             A 613 Zh G4 V
Iantzpliq       0717 D6868AA-5                      724 Zh G1 V
Chake           0720-E612377-6     Ic Lo Ni       A 301 Na K2 V
Afriedevr       0814 X796000-0     Ba Lo Ni       R 013 Zh F1 V
Brietlmofl      0815 E472102-6     Lo Ni            214 Zh G3 V
Eriedlier       0818 B447687-B     Ag Ni            114 Zh G2 V 
Wutubole        0819 C7A1252-A     Fl Lo Ni         223 Na F7 V
Cogswell        0820 D878565-7     Ag Ni            200 Na G4 V
Stradl          0911 X8B1000-0     Ba Fl Lo Ni    R 010 Zh K6 V 
Ora'shtivl      0914 C661646-7     Ri Ni          A 503 Zh G9 V
Chabriaezh      0915 B895630-A     Ag Ni            921 Zh F8 V   M4 D
Roia            0919 C573873-7                      401 Na F9 V
Il Ser          1012 B537458-7 Z   Ni               111 Zh M2 III
Shrdrplibrie    1016 B402487-C     Ic Ni Va         101 Zh K4 IV  M6 V
Rafra           1111 E330885-6     De Na Po         524 Zh F6 V   M5 D
Ebriapl         1112 C000854-A     As Na            922 Zh F9 V
Azhshinti       1115 A777784-A     Ag               504 Zh F0 V
Zdovesil        1212 A65588A-9 Z   Cp               103 Zh M9 V   M1 D
Vla Mev         1214 C557134-8     Lo Ni            213 Zh F2 V
Dla'zevl        1216 E360787-4     De Ri            920 Zh M1 V
Belt Maginum    1218 B000888-B     As               423 Na F5 V
Oriaj A'        1312 A474332-B Y   Lo Ni            213 Zh G9 V
Dashiietl       1314 A210525-E Z   Ni               811 Zh K2 V
Iazbreliep      1316 C535769-6     Po               803 Zh F5 V   M8 D
Clamp           1317 D553231-3     Lo Ni Po         700 Na G3 V   M1 V
Hamagast        1319 E6458BE-2                    A 701 Na G1 V
Edaj            1411 A573795-C                      224 Zh F9 V
Enjiaim         1412 B446567-C Z   Ag Ni            804 Zh F3 V
Ile Danse       1416 A56A756-B     Ri Wa            404 Na F1 V
Kormorant       1419 C6A4554-8     Fl Ni            900 Na M9 V
Jaliaia         1519 C754320-7     Lo Ni            312 Na F9 V   M4 D
Tlivsiqlal      1612 B443754-A Z   Po               202 Zh G1 V
Battle          1617 X210000-0     Ba Lo Ni       R 024 Na M5 V   M0 D
Tlebria         1618 A889614-D X   Ni               825 Zc G9 V   M8 D
Gohrost         1619 X110000-0     Ba Lo Ni         023 Na M3 V   M1 D
Yanagh          1620 C236545-7     Ni               910 Na K2 V
Retlkasrnz      1712 D8AA87A-7     Fl Wa            401 Zh M3 III
New Keento      1813 C879758-9                      200 Na M3 III
Fonda           1815 B400784-B X   Na Va Cp         214 Zc F3 V   M3 D 
Cotalu          1816 C633552-7     Ni Po            903 Na M3 V
Eronirabo       1817 B5528CD-9     Po               703 Na G1 V   M7 D 
Gatina          1915 C765876-7 A   Ag Ri            110 Na F7 V
Lalumostu       1920 C53576B-9 X                    204 Zc M5 V
Sturray         2017 C7A9215-A     Fl Lo Ni         200 Na K1 II
Tasijopze       2113 X543000-0     Ba Lo Ni Po    R 023 Na F4 V   M6 D 
Purfyr          2211 C867645-A     Ag Ni Ri         612 Na K1 V
Ranther         2214 D539598-5     Ni               803 Na F5 V 
Lajachi         2311 E222750-6     Na Po            203 Na M8 V
Robebi          2320 B9988AB-9 Z                    804 Zc F8 V   M1 V 
Ibrolelis       2412 C110667-B     Na Ni            610 Na M3 V
Cocta           2415 C5677BA-A     Ag             A 224 Na G2 V
Dedei           2420 D526332-5     Lo Ni            115 Zc M4 V
Lanei           2517 B502565-B Z   Ic Ni Va         305 Zc M2 III
Lorelei         2518 C668742-7     Ag Ri          A 304 Na F2 V   M2 D 
Rematen         2520 AAB5500-D X   Fl Ni            500 Zc G2 IV
Okopivo         2611 C340564-7     De Ni Po         904 Na M0 V
Orval           2613 E765674-5     Ag Ni Ri       A 202 Na K1 V   M3 V 
Nilestart       2614 D66475A-6 X   Ag Ri            310 Zc F7 V
Cigura          2615 E676500-4     Ag Ni            201 Zc G6 V
Blukjere        2616 B7658DG-7                    A 413 Na F2 V   M8 D 
Roopolaty       2712 C65667A-9     Ag Ni          A 323 Na F8 V
Cadabibado      2715 B855598-B     Ag Ni            404 Na F5 V   M3 D  M2 V 
Esia'dria       2811 C564789-8     Ag Ri            902 Zh G5 V
Agnasti         2812 C100433-D     Ni Va          A 100 Na K2 V
FESSOR          2814 B510999-D S   Hi In Na Cp      200 Cs M3 V   M4 D 
Ynotpu          2820 B322569-A     Ni Po            200 Zc G6 IV
Ecahesa         2920 D410555-B     Ni               425 Na M3 V
Askadero        3013 B747221-A N   Lo Ni            113 Cs K4 V 
Apinanto        3014 E431432-6     Ni Po            303 Na M6 V 
Pynchan         3015 C656795-9     Ag             A 312 Na G0 V
Parthinia       3018 C694655-C     Ag Ni            510 Na F9 V
Gwydion         3020 C442535-9     Ni Po            303 Na G5 V   M2 D 
Ugenie          3111 X597000-0     Ba Lo Ni       R 014 Na F8 V 
Lanilre         3115 C333472-8     Ni Po            114 Na A7 V
Malefolge       3116 B787699-7     Ag Ni Ri       A 612 Na G3 V
Wadanga         3119 C438131-8     Lo Ni            303 Na K0 V   M4 V 
Koskepoc        3212 B769758-A     Ri               504 Na F1 V
Saphi           3214 B470689-C     De Ni            112 Cs M2 II
Calo            3215 D56A755-9     Ri Wa            105 Na G3 V
Elindu          3217 E764300-4     Lo Ni          A 324 Na F4 V
Canwell         0129 C430698-6     De Na Ni Po      400 Mn G2 V
Ablets          0130 C694568-7     Ag Ni            814 Mn F2 V   M3 D 
Penud           0223 X300000-0     Ba Lo Ni Va    R 023 Na M4 V
Syngok          0224 E7A1305-6     Fl Lo Ni         100 Na M3 V   M6 D 
Coolie          0226 C301410-8 M   Ic Ni Va         510 Mn G2 V   M8 D 
Mospat          0227 C110446-A     Ni               504 Mn M2 II
Ceysteni        0422 X100000-0     Ba Lo Ni Va    R 004 Na K8 V  
Hallap          0424 C578322-7     Lo Ni            203 Na G4 V
Wanab           0426 C473388-8     Lo Ni            125 Mn F5 V
Meltrand        0526 B565779-8     Cp Ag Ri         103 Mn F5 V   M2 D 
Alista          0527 C57477A-6     Ag               424 Mn G1 V
Ebsa            0623 E675464-5     Ni               312 Na G9 V   M3 V 
San Soisva      0726 D37236A-7     Lo Ni            210 Na F6 V
Ghost           0730 E300310-6     Lo Ni Va         813 Mn G2 IV  
Logan           0822 B415430-9     Ic Ni            103 Na F0 V
White Hart      0825 C888732-6     Ag             A 103 Na G5 V   M3 D 
Highbury        0926 B566879-9     Ri               213 Na F7 V 
Garbo           0930 B211512-9     Ic Ni            104 Na M2 V
Anfield         1026 C8B9101-B     Fl Lo Ni         604 Na M8 V
Solochov        1124 C335797-A J                    114 Av F0 V 
Trafford        1126 C574651-6     Ag Ni          A 723 Na F6 V   M4 D 
PASTERNAK       1224 D573944-5     Hi In            203 Av G0 V   M1 D 
Bunin           1325 D202200-7     Ic Lo Ni Va      803 Av M0 V
Unaski          1329 E2007AB-8     Na Va          A 401 Av M4 V
Ninox           1330 D130897-7     De Na Po         504 Av F7 II
Telypo          1422 C65658B-5     Ag Ni          A 600 Av F7 V   M0 D 
Totashev        1423 C587544-8     Ag Ni          A 102 Av G8 V   M8 D 
Bamse           1426 B000897-B J   As Na            103 Av F2 V 
Evaberi         1427 C302868-7     Ic Na Va         204 Av M2 V 
Spokes          1428 B40086A-7     Na Va            115 Av M0 V 
TITAN           1429 A642ABA-D J   Hi In Po Cp      213 Av F7 V 
Nordstrom       1523 DADA511-8     Fl Ni Wa         400 Av M5 V
Pudimon         1528 C41076A-7     Na               413 Av G8 V
Naphopi         1622 A458744-D J   Ag               411 Av F1 V   M7 V 
HEPRING         1628 B6789AD-C J   Hi In          A 603 Av G8 V
Robalin         1630 B969898-B J   Ri               204 Av F9 V   M9 D 
Sypot           1724 C9B15AE-7     Fl Ni            805 Av M2 V 
Lubote          1725 A7B4344-C J   Fl Lo Ni         204 Av M1 V   M6 D 
Koshadi         1726 C6976BB-4     Ag Ni            212 Av G3 V
Torinsk         1728 A0007AE-D J   As Na            204 Av M8 V
Mahir           1729 B41089D-C     Na               702 Av M8 V   M4 D 
Onohemu         1822 C244345-7     Lo Ni            412 Na F3 IV
XENOUGH         1828 A560A8A-D J   De Hi Cp         213 Av G3 V
Tepenke         1926 A64887B-9 J                    501 Av G8 V 
Dibelon         1927 C778786-9     Ag               114 Av M0 V
Debagu          2021 C8B5665-5     Fl Ni            332 Na A9 IV
Notaneja        2022 C647589-6     Ag Ni            303 Na F6 V
Tubadeja        2023 C8C0522-7     De Ni            102 Na G3 V   M6 V  M4 D 
Sizapooma       2121 B530530-B Z   De Ni Po         201 Zc M1 V   M0 D 
Bava World      2123 X220000-0     Ba De Lo Ni Po R 005 Na G8 V   M1 D 
Nesturgi        2128 C699687-9     Ni               504 Av F9 V
Daba            2225 X357000-0     Ba Lo Ni       R 003 Na G4 V
Lador           2230 C683685-6     Ni Ri            201 Av F9 V   M3 D  M6 D 
Dengvin         2325 E666775-2     Ag Ri            913 Na K2 V 
Asyrog          2326 D48768A-3     Ag Ni Ri         414 Na F5 V
Manifesto       2328 C000343-B     As Lo Ni         101 Av K8 V   M2 D 
Anipaso         2422 CAD8665-8     Fl Ni            402 Cs M0 V
Podse           2423 D200269-9     Lo Ni Va         105 Cs K6 V
Kahitse         2427 C583732-8                      700 Av F0 V   M7 D 
LENIN           2428 A766A86-D J   Hi               303 Av G3 V   M3 V 
TUNMOPOSU       2429 A647975-C     Hi In            804 Av F6 V   M1 D 
Rantatte        2430 A3328B9-A     Na Po            200 Av M5 V
Hollis          2523 A370642-C A   De Ni          A 303 Cs M3 V
Ryanbiwul       2527 C778310-8 J   Lo Ni            803 Av F9 V
Ontsi           2528 C775555-9     Ag Ni            102 Av F7 V 
Gitts           2623 A202535-D     Ic Ni Va         304 Na K0 V
Boygahe         2628 E400797-6     Na Va            203 Av F5 V
Syl             2724 B510874-C     Na               914 Na G0 I   M7 V 
Taypikacho      2823 B583876-7     Ri               603 Zc F5 V   M9 V 
Genape          2822 A7A2678-C Z   Fl Ni            802 Zc M8 V
Orynphant       2829 E54369A-3     Ni Po          A 702 Av G9 V 
Attbegasu       2923 C9A3203-C     Fl Lo Ni         600 Na F3 V   M2 D 
Jadrin          2924 C140566-C     De Ni Po         204 Na K0 V   M2 V 
REIDAIN         2925 C9EA97B-D     Fl Hi Wa Cp      202 Na G5 V   M7 D 
Lenskansi       2926 B120663-D     De Na Ni Po      833 Na A0 V
Danalipa        2927 A400754-D A   Na Va          A 400 Cs M6 V
Isheydkoka      3021 B373300-D Z   Lo Ni            102 Zc G2 V
Gijisapo        3027 E150220-6     De Lo Ni Po      212 Na F1 IV
Inpota          3028 A665337-D D   Lo Ni            603 Dc K4 V   M6 V 
Sowponanho      3126 X796877-4                    R 903 Na G4 V
Tadasvena       3129 C455125-8     Lo Ni            802 Na F4 V   M4 V 
Lopiengeta      3227 D868365-4 S   Lo Ni          A 103 Cs F3 V
Alenzar         3229 C000414-9     As Ni            513 Cs G0 V
Raschev         3230 C8697C4-6                      123 Cs F9 V 
Bender          0131 E452564-8     Ni Po            404 Mn G6 V
Konnel          0135 A6A3300-C     Fl Lo Ni         523 Mn M7 V   M5 D 
Pinkel          0136 C668664-7     Ag Ni Ri         502 Mn F1 V   M3 V 
Junnice         0232 B301110-8 M   Ic Lo Ni Va      522 Mn G2 IV 
Kelly           0235 E444767-7     Ag               503 Mn M0 V
Cauchon         0236 A110466-D     Ni             A 924 Mn F3 III
Esker           0239 B99A747-9     Wa               823 Na K2 V 
Thorhault       0332 B785577-6     Ag Ni            412 Mn G3 V   M1 D 
Baldur          0335 B425555-A     Ni               715 Mn G4 V
Cale            0336 X330321-4     De Lo Ni Po    R 604 Mn M6 V 
Guam Go         0431 B651699-8     Ni Po            805 Mn G1 V   M7 D 
Spirit          0436 B739769-A                      114 Mn M2 V 
Mossip          0437 A736363-D M   Lo Ni            204 Mn G4 V
Aren-Karu       0439 B78566A-A     Ag Ni Ri         204 Na F7 V   M9 D 
Rull            0538 A00089D-A     Cp As            304 Mn K8 V
Bail            0633 C8A5101-B     Fl Lo Ni         305 Mn F9 V
Mape            0634 B554363-A M   Lo Ni            224 Mn K1 V 
Maru            0639 A73A774-A     Wa               713 Na M2 V 
Forget          0732 C457451-6     Ni               201 Mn K4 V
Foop            0734 CA89540-7 M   Ni               610 Mn G8 V
Connaught       0735 C4846AA-6     Ag Ni            102 Mn F5 V
Ripost          0837 D344863-2                      604 Mn F4 V   M6 D  
Ventnor         0839 C212379-6     Ic Lo Ni         112 Na M3 V
Ovant           0840 E577200-6     Lo Ni          A 920 Na F6 V 
Wright          0935 C470574-9     De Ni            305 Mn F8 V   M6 D
Ninang          1032 XAF3000-0     Ba Fl Lo Ni    R 003 Na M1 V   M5 D
Denanus         1039 B347557-B J   Ag Ni            714 Av F1 V   M7 D
Vanja           1139 C000577-C     As Ni          A 232 Av M4 V 
Soonrod         1140 B776513-B     Ag Ni            242 Av F9 V
Detansa         1234 X513000-0     Ba Ic Lo Ni      000 Na M3 V   M4 D
Wakato          1239 B778440-B     Ni               123 Av K6 V
Bophani         1240 C493520-7     Ni               212 Av F2 V
Elloni          1335 D548405-6     Ni               700 Av F3 V   M5 D
Goku            1432 D150441-9     De Ni Po       A 524 Av G1 V
Huaras          1534 D344556-8     Ag Ni            102 Av K2 V
Daphne          1536 B786786-B     Ag Ri            512 Av G8 V
Bebeto          1539 B786898-9     Ri               221 Av F7 V
Ringun          1631 A866796-A J   Ag Ri            701 Av F5 V   M0 D
Isobel          1632 B336423-9     Ni             A 300 Av M8 II  M3 V
Banbas          1634 C513454-8     Ic Ni            804 Av G8 IV
AVALAR          1636 A75599C-C J   Hi Cp            904 Av G9 V
MILNE           1637 A888947-C J   Hi               324 Av F6 V   M7 D   M1 V
Olga            1639 B454766-C J   Ag               914 Av G9 V
CALIENTE        1640 C6739CC-7     Hi In            404 Av F1 V
Wepwaci         1734 B79889D-B J                    704 Av F5 V
TEWUPO          1738 A748ACA-D J   Hi In Cp         215 Av F5 V
Lypkytan        1739 A8A1662-A     Fl Ni            313 Av M3 V   M3 V  
Eroda           1833 B897894-9 J                    325 Av G7 V
HINATANPYL      1834 C3009BB-9     Hi In Na Va    A 223 Av K1 V   M0 D 
Epepazap        1840 A886752-A     Ag Ri            724 Av F5 V   M1 D 
Weepo           1936 A95788C-B J                  A 425 Av G4 V
Estyske         1938 A410699-D J   Na Ni            114 Av M4 V
Tapsa-64        2040 B300113-C J   Lo Ni Va         722 Av M0 V   M0 D 
Piah            2135 C000212-A     As Lo Ni         705 Na A4 II
Opib            2136 X749000-0     Ba Lo Ni       R 005 Na F7 V
Otargh          2137 E550344-6     De Lo Ni Po      501 Na F1 V
Merghy          2231 C543685-8     Ni Po            311 Av G1 V   M7 D 
Ukardi          2236 D765211-6     Lo Ni            600 Na F3 V   M3 D 
Tindad          2237 X7B0000-0     Ba De Lo Ni    R 000 Na K6 V   M0 D 
Iptete          2334 E381776-3     Ri             A 414 Na F8 V   M2 D   M0 D 
Shortcut        2335 B360730-B     De             A 213 Na F8 V
Kulse           2431 CAC37AB-A J   Fl               603 Av M9 V   M0 D 
Ronsk           2433 C7A5430-A     Fl Ni          A 612 Na M6 III
Bestala         2436 E343666-7     Ni Po            102 Na F1 V
Dinpholasy      2532 B988676-9     Ag Ni Ri       A 105 Av F1 V
LUNE            2537 C4409A6-A     De Hi In       A 103 Na G5 V
Ronu            2632 E534440-3     Ni Po            402 Av F0 V   M5 D
Lela            2634 C310400-A     Ni               912 Na G6 V
Suspe           2731 B8C6311-C J   Fl Lo Ni         904 Av G3 V   M9 D
Capshobem       2736 D78A100-6     Lo Ni Wa         213 Na F8 V   M9 D
Nosafo          2739 E320213-6     De Lo Ni Po      300 Na G7 IV
Nanno           2740 D500456-9     Ni Va            524 Na M5 V
URNIAN          2833 B9779AC-A N   Hi In Cp         513 Cs K3 V
PYLKAH          2834 E463977-9     Hi               305 Na G4 V
Nato            2835 E795230-5     Lo Ni          A 100 Na F0 V
Okunpamsk       2836 C300201-9     Lo Ni Va         312 Na M1 V   M1 D
Ipmokyng        2838 C739878-9                      304 Na K0 V
Udika           2934 C659322-8     Lo Ni            905 Na F5 V
Ovdyo           2935 C422425-C     Ni Po            815 Cs M1 V
Kutadis         2937 E668214-2     Lo Ni          A 124 Na G1 V   M8 D
Cinboshabo      2938 C422685-B S   Na Ni Po         814 Cs M1 V
Tenynti         2940 C130151-B     De Lo Ni Po      114 Na F3 V
Vapchy          3034 B847320-7     Lo Ni            304 Na F7 V
Gotylu          3035 E688699-2     Ag Ni Ri       A 924 Na G3 V
Novoterre       3037 C765877-5 S   Ri             R 804 Cs F5 V
Benoncra        3131 B628567-9 S   Ni               203 Cs M5 V   M8 D
Lorapa          3134 C140864-6 S   De Po            604 Cs M3 V
Mainap          3135 E363400-5     Ni               813 Na F4 V
Shofrete        3232 X73A863-5     Wa             R 301 Cs G4 III
Taupi           3236 E6A4447-4     Fl Ni          A 202 Na M6 V
Ake             3238 D5356AA-8     Ni               121 Cs K6 V
