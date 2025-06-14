###############################################################################
#
#     The idea is to save the TML data into Perl data structures via
#     Data::Dumper.
#
###############################################################################
use lib '.';
use TMLSlinger3;
use Data::Dumper;
use strict;

$Data::Dumper::Indent = 1;
$Data::Dumper::Terse  = 1;

my $slinger = new TMLSlinger;
my @records = ();

foreach my $file (<XBOAT*/XBT*.TXT>, <TML*/*.TXT>)
{
   print STDERR "Reading $file\n";
   push @records, @{$slinger->parseFile( $file )};   
}

print STDERR "Writing ", scalar @records, " entries.\n";

foreach my $list ('TML', 'XBOAT')
{
   foreach my $year (1988..1999)
   {
      my $recordref  = findRecords( $list, $year );
      my $count      = @$recordref;
      next if $count == 0;

       ######################################################
       #
       #  By max file size.
       #
       ######################################################
       my $MAX_FILE_SIZE = 1_000_000; 
       my $index = 0;
       my $fileNum = 0;
       while ($recordref->[$index]) {
          my @slice = ();
          my $size = 0;
          while ($size < $MAX_FILE_SIZE ) {
             my $nextrec = $recordref->[$index];
             last if !defined $nextrec;
             push @slice, $nextrec;
             $size += length($nextrec->{ 'body' }) + 500; # 500 is a rough estimate for the header size
             ++$index;
          }
   
          my $entries = scalar @slice;
          last if $entries == 0;
   
          my $digestFile = sprintf "REFORMAT/${list}_${year}_%03d_%04d.dump", $fileNum, $entries;
          print STDERR "Writing $digestFile ($entries entries)\n";
          open my $out, '>', $digestFile;
          print $out Dumper \@slice;
          close $out;
          ++$fileNum;
       }

       ######################################################
       #
       #  By max number of entries.
       #
       ######################################################
      # 5000 entries max per file really slows down the searching.
      # 2200 entries is better (and <1000 is slightly better than that).
      # 660 entries tops out at 2.8mb.
   #    my $MAX_ENTRIES = 1000;

   #    my $total_files = int($count / $MAX_ENTRIES);
   #    for my $file_number (0..$total_files)
   #    {
   #       my @slice =  @$recordref;
   #       @slice = @$recordref[ $file_number * $MAX_ENTRIES .. $file_number * $MAX_ENTRIES + $MAX_ENTRIES - 1 ] if $total_files > 0;
   #       @slice = @$recordref[ $file_number * $MAX_ENTRIES .. $count ] if $file_number == $total_files;
   #       my $entries = scalar @slice;

   #       my $digestFile = sprintf "REFORMAT/${list}_${year}_%03d_%04d.dump", $file_number, $entries;
   #       print STDERR "Writing $digestFile ($entries entries)\n";
   #       open my $out, '>', $digestFile;
   #       print $out Dumper \@slice;
   #       close $out;
   #    }

   }
}

=pod
sub writeRecords
{
   my $recordList = shift;
   my @out = ();
   foreach my $rec (sort byDate @$recordList)
   {
      my $pon = '';
      foreach my $key (sort keys %$rec)
      {
         next if $key eq 'body';
         $pon .= "$key => \'" . $rec->{ $key } . "\', ";
      }
      $pon = "{ $pon }\n";
      
      push @out, $pon;
      push @out, $rec->{ 'body' };
      push @out, "------------------------------- end of post --------------------------------";
   }

   return join "\n", @out;
}
=cut

sub findRecords
{
   my $list = shift;
   my $year = shift;
   my @out  = ();

   foreach my $rec (@records)
   {
      push @out, $rec if
         $rec->{ 'file' } =~ /$list/
         && $rec->{ 'year' } eq $year;
   }
   return \@out;
}

#
#  find the earlier of two entries
#
sub byDate
{
   return $a->{ 'ts-index' } cmp $b->{ 'ts-index' };
}
