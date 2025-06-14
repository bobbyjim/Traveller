#######################################################################
#
#     grep --> search for keywords in the TML archives
#
#     This is the NEW 2022 version of the grep script, which parses
#     the .dump files created by dump-TML.pl.
#
#     It is much faster than the old grep.pl script, which parsed
#     the original TML files.
#
########################################################################
use strict;
use lib '.';
$| = 1; # always flush

my @keywords = @ARGV or die "SYNOPSIS: $0 [-print | -count | -index] keywords... (use_underscores_for_phrases)\n";
my $print = 0;
my $mode  = "line";

if ($keywords[0] eq '-print')
{
   $print = 1;
   shift @keywords;
   $mode = "full";
}
elsif ($keywords[0] eq '-count' )
{
   $print = -1;
   shift @keywords;
   $mode = "quiet";
}
elsif ($keywords[0] eq '-index') # by index
{
   $print = 1;
   shift @keywords;
   $mode = "index";
}

my $now = scalar localtime;

print<<SPLASHDOWN unless $mode eq 'quiet';
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::'########:'##::::'##:'##:::::::::::::::::::::::'######:::'########::'########:'########::::::::::::
::::::::::... ##..:: ###::'###: ##::::::::::::::::::::::'##... ##:: ##.... ##: ##.....:: ##.... ##:::::::::::
::::::::::::: ##:::: ####'####: ##:::::::::::::::::::::: ##:::..::: ##:::: ##: ##::::::: ##:::: ##:::::::::::
::::::::::::: ##:::: ## ### ##: ##::::::::::'#######:::: ##::'####: ########:: ######::: ########::::::::::::
::::::::::::: ##:::: ##. #: ##: ##::::::::::........:::: ##::: ##:: ##.. ##::: ##...:::: ##.....:::::::::::::
::::::::::::: ##:::: ##:.:: ##: ##:::::::::::::::::::::: ##::: ##:: ##::. ##:: ##::::::: ##::::::::::::::::::
::::::::::::: ##:::: ##:::: ##: ########::::::::::::::::. ######::: ##:::. ##: ########: ##::::::::::::::::::
:::::::::::::..:::::..:::::..::........::::::::::::::::::......::::..:::::..::........::..:::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
$now

Mode:        [$mode]
Query Terms: [@keywords]
Please stand by...

SPLASHDOWN

#
# Gently process each key
#
foreach (@keywords)
{
   s/_/ /g;  # underscores to spaces.
}

my @found = ();
my @records = ();

my $now = time;

foreach my $file (sort <REFORMAT/XBOAT*.dump>,
                  sort <REFORMAT/TML_1994*.dump>,
                  sort <REFORMAT/TML_1995*.dump>,
                  sort <REFORMAT/TML_1996*.dump>,
                  sort <REFORMAT/TML_1997*.dump>,
                  sort <REFORMAT/TML_1998*.dump>,
                  sort <REFORMAT/TML_1999*.dump>)
{
   parseFile( $file );
   foreach my $rec (@records)
   {
      my $good = 1;
      if ($mode eq 'index')
      {
         foreach my $key (@keywords)
         {
            $good = 0 unless $rec->{ 'index' } eq $key;
         }
      }
      else
      {
         foreach my $key (@keywords)
         {
            $good = 0 unless $rec->{ 'body' } =~ /$key/i
                          || $rec->{ 'subj' } =~ /$key/i;
         }
      }
      next unless $good;
      my $shortened_file_name = $1 if $file =~ m|REFORMAT/(.*)\.dump|;
      $rec->{ 'file' } = $shortened_file_name; # overwrite it
      push @found, $rec;
   }
   #print STDERR "found ", scalar @found, " references in $file\n";
}

foreach my $rec (sort byDate @found)
{
   printf "%16s  %-40s  %s-%s-%s  %s  %s\n",
      $rec->{ 'file' },
      $rec->{ 'from' },
      $rec->{ 'year' },
      $rec->{ 'mo'   },
      $rec->{ 'day'  },
      $rec->{ 'index' },
      $rec->{ 'subj' } unless $print;

   if ($print == 1)
   {
      print '-' x 80, "\n";
      print "Source:  ", $rec->{ 'file' }, "\n";
      print "Date:    ", $rec->{ 'date' }, "\n";
      print "From:    ", $rec->{ 'from' }, "\n";
      print "Subject: ", $rec->{ 'subj' }, "\n";
      print "Topic:   ", $rec->{ 'topic'}, "\n" if $rec->{ 'topic'} ne $rec->{ 'subj' };
      print "Index:   ", $rec->{ 'index' }, "\n";
      print "ID:      ", $rec->{ 'id'   }, "\n";
      print "\n\n", $rec->{ 'body' }, "\n";
   }
}

print '-' x 80, "\n" if $print == 1;
printf "%6d entries with: @keywords\n", scalar @found;

print "Time: ", time - $now, " sec\n";
#
#  find the earlier of two entries
#
sub byDate
{
   return $a->{ 'ts-index' } cmp $b->{ 'ts-index' };
}

#$slinger->showLexicon();

sub parseFile
{
   my $file = shift;
   @records = ();
   $/ = undef;
   open my $mime, '<', "$file";
   my $data = <$mime>;
   close $mime;
   $/ = "\n";
   my $ref = eval $data;  # this is FAST
   @records = @$ref;
}
=pod
Source:  TML1994/V32#05A.TXT
Date:    
From:    WILDSTAR@MOENG2.MORGAN.EDU@INET#
Subject: [none]
Index:   ah803
ID:            
=cut


=pod
            'archive_number' => $archive_number || $index++,
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
            'year'           => $yr,
            'ztext'          => $text,
=cut
