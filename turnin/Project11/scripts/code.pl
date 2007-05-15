#! /arch/unix/bin/perl
# This program requires the CPAN XML::Simple 
# module to process the XML files
require XML::Simple;

# Determines if a filename has been given
if (@ARGV != 1){
    die "Usage: project2.pl <filename>\n\n";
}

# Implicitly acts on $_ to remove the newline character
$INPUTFILE = shift;

# Create a new instance of XML::Simple 
# By default, XML::Simple uses the 'name' attribute to build the array
# This causes issues in the overall organization of the array, 
# making it harder to parse.
# KeyAttr => {} removes this, and a few other, default attributes 
# and forces XML::Simple to build the array in a more useful manner
my $xs = XML::Simple->new(KeyAttr => {});

# Create a Perl array (represented as a hash) of the contents 
# of the file given by the user
my $ref = $xs->XMLin($INPUTFILE);

# Force the hash to be treated as the array it really is
foreach my $aircraft (@{$ref->{aircraft}}){

    # Set up some named references to the hashed values in 
    # the array (produces cleaner code)
    $image = $aircraft->{image};
    $nation = $aircraft->{nation};

    # For the Axis nations, read the contents of the nation 
    # attribute and change it appropriately
    if(($nation eq "Japan") or ($nation eq "Germany") or ($nation eq "Soviet Union") or ($nation eq "Italy")) {
        $aircraft->{nation} = "axis";
    }
    
    # For the Allied nations, read the contents of the nation
    # attribute and change it appropriately
    elsif(($nation eq "US AF") or ($nation eq "UK") or ($nation eq "US Navy")){
        $aircraft->{nation} = "allies";
    }
    
    # Check to see if the image attribute is defined, 
    # and if not, add it with the "question.jpg" value
    if(!(defined($image))) {$aircraft->{image} = "question.jpg"};
}

# Create a new temporary file to store the XML output
open($TEMPFILE, "> newindex.xml") or
    die "Failed to open temporary file '$TEMPFILE' for output: $!\n\n";

# Generate XML from the Perl array, and write it to the temp file
# The RootName => 'deck' option ensures that no extra anonymous 
# XML tags ar added on output and the root level
my $xml = $xs->XMLout($ref, OutputFile => $TEMPFILE, RootName => 'deck');

# Close the temporary file once writing is complete
close($TEMPFILE) or
    die "Failed to close temporary file 'newindex.xml': $!\n\n";

# Delete the original input file given by the user
unlink($INPUTFILE) or
    die "Failed to delete original file '$INPUTFILE': $!\n\n";

# Rename the temporary file to the original file name, thus replacing it
rename("newindex.xml", $INPUTFILE) or
    die "Failed to rename temporary file 'newindex.xml' to '$INPUTFILE': $!\n\n";
