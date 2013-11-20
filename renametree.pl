#!/usr/bin/perl -w
use strict;
use Bio::TreeIO;
use Getopt::Long;
# this takes the name of the file from the user and modifies the systamtic names of the proteins to include the easily identifiable names

my $tree_format = 'newick';

GetOptions(
	   'f|format:s' => \$tree_format,
	   );
# give 2 names,
# 1 is the treefile
# 2 is the table of old to new names
my ($treefile,$replacementnames) = @ARGV;
warn " the filename we will process is $treefile with $replacementnames file\n";
# Remove the newline from the filename
#chomp $filename;

open(my $fh => $replacementnames) || die $!;
my %lookup;
while(<$fh>) {
    my ($old,$new) = split;
    $lookup{$old} = $new;
}

my $treeIO = Bio::TreeIO->new(-format => $tree_format,
			      -file   => $treefile);
my $out    = Bio::TreeIO->new(-format => $tree_format);
while(my $tree = $treeIO->next_tree) {
    
    for my $node ( $tree->get_nodes ) {
	if( ! $node->is_Leaf ) {
	    next;
	}
	my $name = $node->id();
	my $newname = $lookup{$name};
	if( defined $newname ) {
	    print STDERR "the node name is $name new name is $newname\n";
	    $node->id($newname); # set the node's name to the new name
	    warn "updated name is ", $node->id, "\n";
	} else {
	    # warn("can't find name $name in the table\n");
	}
    }
    $out->write_tree($tree);
}

