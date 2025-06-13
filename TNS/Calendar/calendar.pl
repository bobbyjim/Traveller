

opendir( DIR, "." );
my @files = grep( /\.ATT$/, readdir DIR );
closedir DIR;

my @output;
my @fields;
my @colors =
(
   "ff8888",
   "88ff88",
   "cccccc"
);

my %trans =
(
   '\+'  => ' ',
   '%21' => '!',
   '%22' => '@',
   '%23' => '#',
   '%24' => '$',
   '%25' => '%',
   '%5E' => '^',
   '%26' => '&',
   '%28' => '*',
   '%29' => '(',
   '%30' => ')',
   '%3D' => '=',
   '%5C' => '\\',
   '%7C' => '|',
   '%5D' => ']',
   '%5B' => '[',
   '%7B' => '{',
   '%7D' => '}',
   '%27' => '\'',
   '%22' => '\"',
   '%3B' => ';',
   '%3A' => ':',
   '%3C' => '<',
   '%3E' => '>',
   '%40' => '@',
   '%2F' => '/',
   '%2C' => ',',
   '%2B' => '+',
);

my $count = 0;
open( OUT, ">atc.log" );
foreach (@files)
{
   $count++;
   
      my $color = $colors[0];
      
   push( @colors, shift @colors ) if $count % 5 == 0;
       


   open( IN, $_ );
   my $in  = <IN>;
   
   print OUT "File $_:\n";
   
   foreach ( keys %trans )
   {
     $in =~ s/$_/$trans{$_}/g;
   }
   
   #
   #  Insert newlines if need be
   #
   $in =~ s/([^\n]{80})\s/$1<br>\n/g;
   
   my @dat = split( '&', $in );
   close IN;
   
   @fields = ();

   push( @output, "<tr>\n" );   
   foreach (@dat)
   {
      my ( $key, $id ) = split( '=', $_ );
      
      if ($id =~ /\w+\@\w+\.\w+/i)
      {
         my $user = $id;
         $user =~ s/\@.*$//;
         $id = "<a href=mailto:$id>$user</a>";
      }
      
      if ($key =~ /WebPage/ && $id =~ /\./)
      {
         $id = "http://$id" unless $id =~ /http/;
         $id = "<a href=$id>link</a>";
      }

      push( @output, "   <td bgcolor=$color>$id </td>\n" );
      push( @fields, "   <td bgcolor=8888FF>$key</td>\n" );
      
      print OUT sprintf( "   %-10s $id\n", $key );
   }
   push( @output, "</tr>\n" );
}
close OUT;

open( OUT, ">atc.html" );
print OUT <<EOForm;
<html>

<head>
   <title>Imperial Calendar</title>
</head>

<body background=starburstEmbossed.gif>
<center>

<font face=courier size=+2><b>Imperial Calendar</b></font>

<table>
<tr>@fields</tr>
@output
</table>

</center>
</body>
</html>
EOForm

close OUT;