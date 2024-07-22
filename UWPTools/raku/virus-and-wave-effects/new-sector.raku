

sub MAIN( $sectorName, $x, $y, *@order ) {

	my $src = "travellermap";
	my $loc;
	my $filename = $sectorName ~ '.tab';
	my $order  = @order.join( ' ' );

    if "/Users/rje/git/travellermap/res/t5ss/data/$filename".IO.e {
		$src = "/Users/rje/git/travellermap/res/t5ss/data/$filename";
		$loc = "t5ss";
	} elsif "/Users/rje/git/travellermap/res/Sectors/M1105/$filename".IO.e {
		$src = "/Users/rje/git/travellermap/res/Sectors/M1105/$filename";
		$loc = "M1105";
	}

	say "file source: $src";

	my $gtx = qq:to/END/;
location \{
	y   $y 
	x   $x
\}

default \{
	order 	$order
\}

source \{
	path  $src 
\}
END

	my $gtxfile = 'config/' ~ $sectorName ~ '-to-1900.gtx';
	if $gtxfile.IO.e {
		die "$gtxfile already exists";
	}
	$gtxfile.IO.spurt: $gtx;
	say "$gtxfile created";

	my $abbreviation = $sectorName.substr(0,4);

	my $metadata = qq:to/ENDMETA/;
<?xml version="1.0"?>
<Sector Abbreviation="{$abbreviation}" Tabs="Unreviewed">
  <Y>{$y}</Y>
  <X>{$x}</X>
  <Name>{$sectorName}</Name>
  <Credits>
    <![CDATA[

             The "fast-forward" script ran this data up to years 1508 and 1900.

    ]]>
  </Credits>
  
  <Subsectors>
    <Subsector Index="A">?</Subsector>
    <Subsector Index="B">?</Subsector>
    <Subsector Index="C">?</Subsector>
    <Subsector Index="D">?</Subsector>
    <Subsector Index="E">?</Subsector>
    <Subsector Index="F">?</Subsector>
    <Subsector Index="G">?</Subsector>
    <Subsector Index="H">?</Subsector>
    <Subsector Index="I">?</Subsector>
    <Subsector Index="J">?</Subsector>
    <Subsector Index="K">?</Subsector>
    <Subsector Index="L">?</Subsector>
    <Subsector Index="M">?</Subsector>
    <Subsector Index="N">?</Subsector>
    <Subsector Index="O">?</Subsector>
    <Subsector Index="P">?</Subsector>
  </Subsectors>

  <Allegiances>
  </Allegiances>

  <Routes>
  </Routes>

  <Borders>
  </Borders>

</Sector>
ENDMETA

	my $metafile = 'output/' ~ $sectorName ~ '.xml';
	unless $metafile.IO.e {
		$metafile.IO.spurt: $metadata;
		say "$metafile created";
	}
}