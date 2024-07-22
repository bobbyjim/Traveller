# UWP Tools
Perl and Raku modules and scripts for UWP manipulation

# Raku
This is the newer, fresher material, using Raku classes to try to manage the data better.

# Raku Scripts

## fast-forward.raku
This is the mother script that takes a 1105 sector and generates a 1201, post-wave, 1508, and 1900 version of the sector. It requires the sector to have a named configuration file that specifies what operations are applied to it, and what sort of exceptional circumstances might also apply.

## hotzones.raku
This script takes a sector and sets a fabricated allegiance code to a random walk of systems.

## redzone-wilds.raku
This script takes a sector and sets a 'WiFo' allegiance code to a rough circle of systems.

## reprocess.raku
Re-calculates the TL, remarks, extensions, and RU of the lines of a sector.  Useful when you're manually editing a sector.

## set-allegiances.raku
Applies an allegiance code to a set of hexes in a sector.

## survivor-state-gen.raku
Generates a pocket empire based on a strong world in a sector.

# Raku Modules

## UWP.rakumod
This is the module that does all of the heavy lifting.  It encapsulates most of the operations you can do on a UWP line.
It's a BIG class with a lot of interesting methods.

## Util.rakumod
A very small utility module that has one major method: the distance method. 

## Sector.rakumod
A new and growing utility that encapsulates operations performed on entire sectors.



# Perl
This is a collection of various UWP modules and scripts, including a CGI script that was used for worldbuilding calculations.

There is a set of modules for generating an entire solar system using T5 Book 3 rules.

There are utilities here as well.
