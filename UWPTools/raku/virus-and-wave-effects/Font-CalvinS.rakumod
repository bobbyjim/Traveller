

my @font-calvin-s-upper = (
	 "╔═╗,╔╗ ,╔═╗,╔╦╗,╔═╗,╔═╗,╔═╗,╦ ╦,╦, ╦,╦╔═,╦  ,╔╦╗,╔╗╔,╔═╗,╔═╗,╔═╗ ,╦═╗,╔═╗,╔╦╗,╦ ╦,╦  ╦,╦ ╦,═╗ ╦,╦ ╦,╔═╗".split(','),
	 "╠═╣,╠╩╗,║  , ║║,║╣ ,╠╣ ,║ ╦,╠═╣,║, ║,╠╩╗,║  ,║║║,║║║,║ ║,╠═╝,║═╬╗,╠╦╝,╚═╗, ║ ,║ ║,╚╗╔╝,║║║,╔╩╦╝,╚╦╝,╔═╝".split(','),
	 "╩ ╩,╚═╝,╚═╝,═╩╝,╚═╝,╚  ,╚═╝,╩ ╩,╩,╚╝,╩ ╩,╩═╝,╩ ╩,╝╚╝,╚═╝,╩  ,╚═╝╚,╩╚═,╚═╝, ╩ ,╚═╝, ╚╝ ,╚╩╝,╩ ╚═, ╩ ,╚═╝".split(',')
);

my @font-calvin-s-lower = (
	"┌─┐,┌┐ ,┌─┐,┌┬┐,┌─┐,┌─┐,┌─┐,┬ ┬,┬, ┬,┬┌─,┬  ,┌┬┐,┌┐┌,┌─┐,┌─┐,┌─┐ ,┬─┐,┌─┐,┌┬┐,┬ ┬,┬  ┬,┬ ┬,─┐ ┬,┬ ┬,┌─┐".split(','),
	"├─┤,├┴┐,│  , ││,├┤ ,├┤ ,│ ┬,├─┤,│, │,├┴┐,│  ,│││,│││,│ │,├─┘,│─┼┐,├┬┘,└─┐, │ ,│ │,└┐┌┘,│││,┌┴┬┘,└┬┘,┌─┘".split(','),
	"┴ ┴,└─┘,└─┘,─┴┘,└─┘,└  ,└─┘,┴ ┴,┴,└┘,┴ ┴,┴─┘,┴ ┴,┘└┘,└─┘,┴  ,└─┘└,┴└─,└─┘, ┴ ,└─┘, └┘ ,└┴┘,┴ └─, ┴ ,└─┘".split(',')
);
my @calvin;

for @font-calvin-s-upper -> @a {
	my %foo = qw/A B C D E F G H I J K L M N O P Q R S T U V W X Y Z/ Z=> @a;
	push @calvin, %foo;
}

for @font-calvin-s-lower -> @a {
	my %foo = qw/a b c d e f g h i j k l m n o p q r s t u v w x y z/ Z=> @a;
	push @calvin, %foo;
}

say @calvin;

my $test = 'Thermidor';

my @out1;
my @out2;
my @out3;

for $test.split('', :skip-empty) -> $letter {
	@out1.push(@calvin[0]{$letter});
	@out2.push(@calvin[1]{$letter});
	@out3.push(@calvin[2]{$letter});
}

print "\n";
say @out1;
say @out2;
say @out3;

