package TMLSlinger;
use strict;

sub new { bless {}, shift }

my %mo =
(
    jan => '01', feb => '02', mar => '03', apr => '04',
    may => '05', jun => '06', jul => '07', aug => '08',
    sep => '09', oct => '10', nov => '11', dec => '12',
);

# ----------------------------------------------------------------
#  Read a TML file into an array of records
# ----------------------------------------------------------------
my $index = 'aa001';

my %lex = ();  # we're going to do a little analysis

sub parseFile
{
   my $self = shift;
   my $file = shift;

   $/ = undef;
   open my $in, '<', $file;
   my $data = <$in>;
   close $in;
   $/ = "\n";

   my ($type, $basename) = split '/', $file;

   $data =~ s/\r\n/\n/g; # to unix, PLEASE

   my $recordrefs = [];
   $recordrefs = splitXboat( \$data )   if $type =~ /XBOAT/;
   $recordrefs = splitTML1987( \$data ) if $type =~ /TML1987/;
   $recordrefs = splitTML1987( \$data ) if $type =~ /TML1988/;
   $recordrefs = splitTML1987( \$data ) if $type =~ /TML1989/;
   $recordrefs = splitTML1987( \$data ) if $type =~ /TML1990/;
   $recordrefs = splitTML1991( \$data)  if $type =~ /TML1991/;
   $recordrefs = splitTML1991( \$data)  if $type =~ /TML1992/;
   $recordrefs = splitTML1991( \$data)  if $type =~ /TML1993/;
   $recordrefs = splitTML1991( \$data)  if $type =~ /TML1994/;
   $recordrefs = splitTML1991( \$data)  if $type =~ /TML1995/;
   $recordrefs = splitTML1991( \$data)  if $type =~ /TML1996/;
   $recordrefs = splitTML1991( \$data)  if $type =~ /TML1997/;
   $recordrefs = splitTML1991( \$data)  if $type =~ /TML1998/;
   $recordrefs = splitTML1991( \$data)  if $type =~ /TML1999/;

   my ($prettyFile) = $file;
       $prettyFile  = $basename if $type =~ /XBOAT/;
       $prettyFile =~ s/\.txt//i;

   my @outrefs = ();
   foreach my $rec (@$recordrefs)
   {
      next unless $rec =~ /\w/;
      next if $rec =~ /End of XBOAT/i; 

      $rec =~ s/^\n// while $rec =~ /^\n/; # eat initial newlines
      my ($hdr, $content) = split /\n\n/, $rec, 2;
      
      next if $hdr =~ /BUN# =AMN= =DATE====== =FROM==========  =SUBJECT.BODY==========================/;

      # process header
      my ($subject) = $hdr =~ /Subject: \s*(.*)/;
      my ($date)    = $hdr =~ /Date: \s*(.*)/;
      my ($from)    = $hdr =~ /From: \s*(.*)/;
      my ($amn)     = $hdr =~ /Archive-Message-Number: (\d+)/;
      my ($mid)     = $hdr =~ /Message-ID: (.*)/;

      $mid = $amn unless $mid;

      next unless $from || $subject || $date; # PROVE that this is a real post!!
      next if $from eq 'traveller-request@engrg.uwo.ca (TML Admin)';

      next if $subject eq 'TML -- Lost Message';
      next if $subject eq 'Undeliverable Message';
      $subject = '[none]' unless $subject;

      next if $subject =~ /TML Bundle #\d+: Table of Contents/;

      my ($topic) = $subject;
          $topic =~ s/Re://g;

      $date =~ s/-/ /g;  # no dashes
      my ($day, $mo, $yr);
      if ($date =~ /\d+ [a-z]+ \d+/i) # day mon yr
      {
         ($day, $mo, $yr) = $date =~ /(\d+) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (1?9?\d\d)/i;
      }
      else
      {
         ($mo, $day, $yr) = $date =~ /(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (\d+) (1?9?\d\d)/i;
      }
      $yr += 1900 if $yr < 1900;
      my $month = $mo{ lc $mo };
      $day = sprintf "%02d", $day;

      #$from =~ s/<.*>// unless $from =~ /\"/; # address, unless there's a quote in the from line!
      $from =~ s/\(?".*?"\)?//;  # dump the quoted adages
      $from = $1 if $from =~ /\((.*)\)/;
      if ($from =~ /!/) # this is from bitnet addresses.  throw out the preamble.
      {
         my @from = split '!', $from; 
         $from = '...!' . pop @from; # last element is significant
      }
      $from =~ s/^\s*//;
      $from =~ s/[<>]//g;
      $from =~ s/^(.{40}).*$/$1/; # truncate to 40c

      # ...you know, we could probably pre-grep for keywords...

      # let's shorten some very common strings.
      $content =~ s/shadow\@krypton.rain.com/shadow@/g;
      $content =~ s/leonard\@qiclab.scn.rain.com/leonard@/g;
      $content =~ s/----*/----/g;
      $content =~ s/-.=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=.-/-+=-=-=+-/g;

      # Abbreviating words in the content really doesn't
      # significantly decrease the file size.

      # We could add detected keywords.

      push @outrefs,
      {
#            'archive_number' => $archive_number,
            'date'           => $date,
            'year'           => $yr,
            'day'            => $day,
            'mo'             => $mo,
            'month'          => $month,
            'ts'             => $yr . $mo . $day,
            'ts-index'       => "$yr-$month-$day.$index",
            'index'          => $index,
            'id'             => $mid,
            'file'           => $file,
            'from'           => $from,
            'subj'           => $subject,
            'topic'          => $topic,
            'body'           => $content,
      };

      ++$index;

      foreach (split /\s+/, $content) # words baby
      {
         $lex{ $_ }++;
      }
   }

   return \@outrefs;
}

sub showLexicon
{
   printf "%16s     %6s     %7s\n", 
         "WORD",
         "COUNT",
         "KB";

   my $totalkb = 0;

   foreach (sort byWordCost keys %lex) # most common first
   {
      last if $lex{$_} < 100;  # we're done here.

      my $kbytes = int($lex{$_} * (length($_)-2) / 1024);
      next if $kbytes < 100;   # not significant.

      printf "%16s     %6d     %7d K\n", 
         $_,
         $lex{$_},
         $kbytes;

      $totalkb += $kbytes;
   }

   print "Total kb: $totalkb K\n";
}

sub byWordCost
{
   my $c1 = $lex{$a} * (length($a)-2);
   my $c2 = $lex{$b} * (length($b)-2);
   return $c2 <=> $c1;
}

sub splitXboat
{
   my $tref = shift;
   my $text = $$tref;
   my ($header, $records) = split '----------------------------------------------------------------------', $text, 2;
   my @records = split '\n------------------------------\n', $records;
#   printf "%3d records found\n", scalar @records;

   return \@records;
}

sub splitTML1987
{
   my $tref = shift;
   my $text = $$tref;
   my @records = split /-------- TML Message #\d+ --------/, $text;
#   printf "%3d records found\n", scalar @records;

   return \@records;

}

sub splitTML1991
{
   my $tref = shift;
   my $text = $$tref;              

   if ($text =~ /HTML/) # this is for half of the 1999 posts.
   {
      # Rip them down. 
      # -- Saruman
      $text =~ s/<HTML>//g;
      $text =~ s/<.?FONT  SIZE=3 PTSIZE=10>//g;
      $text =~ s/<.?B>//g;
      $text =~ s/<BR>//g;
   }

   my @batches = split /\n----------------------------------------------------------------------\n/, $text;
   #print "BATCHES: ", scalar @batches, "\n";

   my @records = ();
   foreach my $batch (@batches)
   {
       push @records, split '\n------------------------------\n', $batch;
   }

#   foreach (@records)
#   {
#      print $_, "\n", '*' x 80, "\n";
#   }

   return \@records;
}

=pod

sub parseFile
{
   my $self = shift;
   my $file = shift;

   $/ = undef;
   open IN, $file;
   my $data = <IN>;
   close IN;
   $/ = "\n";

   if ( $data =~ /^<html>/i )
   {
      #print "File: $file  Skipping HTML.\n";
      next;
   }

#   $data = "\n$data"; # kludge

   $data =~ s/
//g; # no dos

   my $junk;
   my @raw_records;
   my $format = 'unknown format';

   if ( $data =~ /XTML nightly|XBOAT Digest/ ) 
   {
      $format = "XBOAT";
      my ($digest, $content) = split /----------------------------------------------------------------------\n/, $data, 2; # digest contents
      ($digest, $content) = split(/- - -\n/, $data, 2) if /- - - -/; # or, digest contents

      @raw_records = split /\n------------------------------\n\n/, $content;
      #@raw_records = split /\n------------------------------\n\n/, $data;
   }
   elsif ( $data =~ /Xboat-digest/ )
   {
      $format = "XBOAT 1996a";
      @raw_records = split /\n------------------------------\n\n/, $data;
   }
   elsif ( $data =~ /-------- TML Message .\d+ --------/ ) # *really* old
   {
      $format = "1987-90";
      @raw_records = split /-------- TML Message .\d+ --------/, $data;
   }
   elsif ( $data =~ /TML [Bb]undles come from the archives/ ) # pretty old
   {
      @raw_records = split /\n------------------------------\n\n/, $data;
      $format = "1991-92,93-94";
   }
   elsif ( $data =~ /Western Ontario. All opinions and materials below/ )
   {
      @raw_records = split /\n------------------------------\n\n/, $data;
      $format = "1992-93,94";
   }
   elsif ( $data =~ /Traveller Mailing List --- NOT!/ )
   {
      #print "'TML -- NOT!' detected.  Skipping (for now).\n";
      next;
   }
   elsif ( $data =~ /^\s+TRAVELLER [Dd]igest \d+/ ) 
   {
      @raw_records = split /\n------------------------------\n\n/, $data;
      $format = "1994A-95";
   }
   elsif ( $data =~ /\nTraveller-digest   / ) # 1999
   {
      @raw_records = split /\n------------------------------\n\n/, $data;
      $format = "1999";
   }
   elsif ( $data =~ /Traveller-digest .*<BR>/ ) # 2000+
   {
      $data =~ s/=20/ /g;
      $data =~ s/<br>/\n/gi;   # <br> => \n
      $data =~ s/<.*?>//g;     # bye-bye, HTML...
      @raw_records = split /\n------------------------------\n\n/, $data;
      $format = "2000s HTML";
   }
   elsif ( $data =~ /Traveller-digest   / ) # 1996
   {
      @raw_records = split /\n------------------------------\n\n/, $data;
      $format = "1996,99";
   }
   elsif ( $data =~ /\s*TRAVELLER.Digest.\d+/i ) # mid to late 90s
   {
      @raw_records = split /\n------------------------------\n\n/, $data;
      $format = "1995-99";
   }
   elsif ( $data =~ /\n\s+TRAVELLER Digest/ )
   {
      @raw_records = split /\n------------------------------\n\n/, $data;
      $format = "1995";
   }
#   else
#   {
#      open OUT, ">>unknown_format.txt";
#      print OUT $file, ' ', -s $filem, "\n";
#      close OUT;
#      print "\n";
#      return [];
#   }

   my @records;
   {
      foreach my $rec (@raw_records)
      {
         my $text = $rec;

         next if $text =~ /TML Bundles come from the archives of the Traveller Mailing List/;

         my $subj = $1 if $rec =~ /Subject:\s(.*)\s*[\r\n]/;
         my $date = $1 if $rec =~ /Date:\s(.*)\s*[\r\n]/;
         my $from = $1 if $rec =~ /From:\s(.*)\s*[\r\n]/;

         my $archive_number = $index;
            $archive_number = $1 if $rec =~ /Archive-Message-Number:\s(\d+)/;
            $archive_number = $1 if $rec =~ /Message-ID: <(.*)>/;
 

         foreach ( $subj, $date, $from, $archive_number )
         {
            chomp;
            s/
//g;
            s/\n//g;
         }

#         print "- [$rec] no archive number.  Skipping.\n" unless $archive_number;
         next unless $archive_number;
         next unless $date;
         next if $from =~ /rwm@tansoft.com/; # ??
         
         #my $thread = $subj;
         #$thread =~ s/^Re\s*: //i;
         #$thread =~ s/\s/_/g;
         #$thread =~ s/\W//g;   # experimental
         #$thread = "_$thread"; # kludge
         
         #############################################
         #
         #  Parse the name and email address 
         #
         #############################################
         my $id        = '';
         my $name      = '';
         my $lastname  = '';
         
         $from =~ s/"//g;

         $from = 'Leonard Erickson <leonard@bucket>' if $from =~ /Leonard Erickson\.\.\./;
     
         # Archive-Message-Number: 2332Date: Mon, 6 May 91 19:59:42 -0400From: tnc!m0068@uunet.UU.NETSubject: Scott Kellogg Designs Part 3.2 of 8
         ($date, $name, $subject) = ($1,$2,$3) if $from =~ /Date: (.*)From: (.*)Subject: (.*)/;

         $id       = $1 if $from =~ m/(\S+\@\S+)\s*/;
         $id       = $1 if $from =~ m/<(.+)>/;
         $id       = $1 if $from =~ m/^(\w+)$/; # just a bare userid, no name or anything

         $name     = $1 if $from =~ m/(.*)\s</;
         $name     = $1 if $from =~ m/\((.*)\)/;
         $name     = $1 if $from =~ m/([\w\s,]+)/;

         # From: "Robert S. Dean" <rsdean@crdec8.apgea.army.mil>
         ($name, $id) = ($1,$2) if $from =~ /From: (.*?) <(.*?\@.*?)>/;

         $lastname = $1 if $name =~ /(\w+)$/;
         $lastname = $1 if $name =~ /^(\w+),/;

         # name sanity
         my @nameWords = split /\s/, $name;
         $name = '' if scalar @nameWords > 4;
         $name =~ s/\.*\s*$//;

         $id = $name unless $id;
#         print "\n* [$from] [$name] [$archive_number] email address not parsed\n" unless $id;
#         printf("- [name: %-18s, lastname: %-10s, id: $id]\n", $name, $lastname) if $id;

         next unless $id;
         next if $id =~ /^owner-traveller-digest\@/;

         #############################################
         #
         #  Parse the date
         #
         #############################################
         my ($day, $mo, $yr) = ($date =~ /(\d\d?) (\w\w\w) (\d{2,4})/ );
         $mo = $mo{$mo};
         $day = "0$day" if length $day == 1;
         $yr = "19$yr" if $yr < 100 && $yr > 79;
         $yr = "20$yr" if $yr < 100 && $yr < 80;

         $day = '00' unless $day;
         $mo  = '00' unless $mo;
         $yr  = '00' unless $yr;

         #############################################
         #
         #  Build the data record
         #
         #############################################
         $text =~ s/\n\s*\n/\n/g;
         #$text =~ s/Subject: .*?\n//;
         #$text =~ s/Date: .*?\n//;
         #$text =~ s/From: .*?\n//;
         #$text =~ s/Archive-Message-Number:.*?\n//;
         $text =~ s|- -{40,}|- - - -|g;
         # $text =~ s|\*{40,}|- - - -|g;
         # $text =~ s|_{40,}|- - - -|g;

         #print " - [$archive_number]\n";
         push @records,
         {
            'archive_number' => $archive_number,
            'date'           => $date,
            'day'            => $day,
            'file'           => $file,
            'from'           => $from,
            'id'             => $id,
            'lastname'       => $lastname,
            'month'          => $mo,
            'name'           => $name,
            'subj'           => $subj,
            'thread'         => $thread,
            'ts'             => $yr . $mo . $day,
            'ts-index'       => "$yr-$mo-$day.$index",
            'year'           => $yr,
            'ztext'          => $text,
         };

         #############################################
         #
         #  Aaaand increment our unique index
         #
         #############################################
         $index++;

      }
   }

   #print "$file: [$format] ", scalar @records, " records\n";
   return \@records;
}


sub getSubids
{
   my $self = shift;
   my $id = shift;
   my $id1  = $1 if $id =~ /^(.)/;
   my $id2  = $1 if $id =~ /^(..)/;
   return ($id1, $id2);
}

# ------ return a list of nonempty values found for a field ------
sub getFieldValues
{
   my $self      = shift;
   my $records   = shift;
   my $fieldname = shift;

   my %out;
   foreach my $record (@$records)
   {
      $out{ $record->{$fieldname} }++
         if $record->{$fieldname};
   }
   my @out = sort keys %out;
   return \@out;
}


# ---------- filter out records based on field regexes -----------
#
# SYNOPSIS:
#
#   keep( $records, { 'field1' => 'foo', 'field2' => 'bar' } );
#
# ...keeps all records for which field1 =~ /foo/ and field2 =~ /bar/.
#
# ----------------------------------------------------------------
sub keep
{
   my $self    = shift;
   my $records = shift;
   my $filter  = shift;

   my @out;
   RECORD: foreach my $record (@$records)
   {
      foreach my $field ( keys %$filter )
      {
         my $regex = $filter->{ $field };
         next RECORD unless $record->{ $field } =~ m/$regex/;
      }
      push @out, $record;
   }
   print "Record count: ", scalar @out, "\n";
   return \@out;
}

# ----------- delete elements from records -------------
sub prune
{
   my $self    = shift;
   my $records = shift;
   my @fieldsToPrune = @_;

   foreach my $record ( @$records )
   {
      my %recs = %$record;
      delete @recs{@fieldsToPrune};
      $record = \%recs;
   }
   return $records;
}

# ------------ apply a regex to a particular field ---------------
sub modify
{
   my $self    = shift;
   my $records = shift;
   my $regex   = shift;

   foreach $_ ( @$records )
   {
      eval $regex;
      next;
   }
   return $records;
}

# ----------------------------------------------------------------
#
# Group the provided arrayref into a hashref of arrayrefs,
# keyed off of the passed in field names.
#
# For example, groupByFields( $aref, 'foo' )
# sorts the records in $aref into a hashref based on values
# of field 'foo'.
#
# The return value is a hashref indexed by the field name.
# This permits multiple sorts.  For example,
# groupByFields( $aref, 'foo', 'bar' )
# creates two sort hashrefs, one based on values in field 'foo'
# and one based on values in field 'bar'.
#
# ----------------------------------------------------------------
sub groupByFields
{
   my $self = shift;
   my $records = shift;
   my @fields  = @_;

   #print "fields: @fields\n";

   my %groups = ();
   foreach my $record (@$records)
   {
      foreach my $field (@fields)
      {
         my $value = $record->{ $field };
         my $aref  = $groups{$field}->{$value} || [];
         push @$aref, $record;
         $groups{$field}->{$value} = $aref;
      }
   }
   return \%groups;
}

# ----------------------------------------------------------------
#
# Group the given array reference of records based on a complex
# key built from more than one field name.
#
# This method outputs a hashref whose keys are the values of
# the given fieldnames; each value in the hashref is an array
# of records with those given values for the indicated fields.
#
# $hashref->{ key composed of values from the indicated fields }
#    = [ records whose values match those in this key ]
#
# ----------------------------------------------------------------
sub groupByKey
{
   my $self = shift;
   my $records = shift;
   my @fields  = @_;

   return $self->_groupBySingleKey( $records, $fields[0] ) if @fields == 1;

   my %groups = ();
   RECORD: foreach my $record (@$records)
   {
      my @key;
      foreach my $field (@fields)
      {
         push @key, $record->{ $field };
      }
      my $key = join '-', @key;

      my $aref = $groups{$key} || [];
      push @$aref, $record;
      $groups{$key} = $aref;
   }
   return \%groups;
}

# ----------------------------------------------------------------
#
# Given an arrayref of records and a fieldname, build a hashref
# keyed on values of the given fieldname.  Values are arrayrefs
# of records which have that value for that key.
#
# ----------------------------------------------------------------
sub _groupBySingleKey
{
   my $self    = shift;
   my $records = shift;
   my $field   = shift;

   my %groups = ();
   foreach my $record (@$records)
   {
      my $value = $record->{ $field };
      my $aref  = $groups{$value} || [];
      push @$aref, $record;
      $groups{$value} = $aref;
   }
   return \%groups;
}
=cut

1;

