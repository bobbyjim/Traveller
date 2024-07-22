

class UwpUtil is export
{
	submethod badFlux { 
		-abs((^6).pick - (^6).pick);
	}

	submethod hex2rowcol( $hex ) {
		my $row1 = $hex.substr(0,2).Int;
		my $col1 = $hex.substr(2,2).Int;

		return ($row1, $col1);
	}

	submethod distance(@hex1, @hex2) {
		my ($col1, $row1) = @hex1;
		my ($col2, $row2) = @hex2;
		
		my $a1 = ($row1 + ($col1/2).Int);
		my $a2 = ($row2 + ($col2/2).Int);
   
		my $d1 = abs( $a1 - $a2 );
		my $d2 = abs( $col1 - $col2 );
		my $d3 = abs( ($a1 - $col1) - ( $a2 - $col2 ) );
        
		return sort($d1, $d2, $d3)[2];
	}
}
