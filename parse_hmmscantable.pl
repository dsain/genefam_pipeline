#!/usr/bin/perl -w
use strict;
use warnings;
use Bio::SeqIO;
use Bio::DB::Fasta;

# CHS Div I looks like Chitin_synth_1, Chitin_synth_1N
# 
# CHS Div II-four looks like Chitin_synth_2, Cyt-b5
#
# CHS Div II looks like Chitin_synth_2, Cyt-b5, DEK_C, Myosin_head
#
# CHS Div III looks like Chitin_synth_2

my $file = shift || die "provide a file name";
my $db = shift || die "need to provide a database file";

my $dbh = Bio::DB::Fasta->new($db);
my %genes; # data structure to store the info
open(my $fh => $file) || die "Can't open $file $!\n";
while(<$fh>) {
 next if /^\#/;
 chomp; # drop the newline at the end of the line, not really important
 my ($domain,$acc,$genename,undef,$evalue) = split(/\s+/,$_);
 $genes{$genename}->{$domain} = $evalue;
}
my %genes_by_division;
# unroll the hash
foreach my $genename ( sort keys %genes ) {
    # each of these are the names of genes
    print "$genename:\n";
    my $domains = $genes{$genename};
    my $DIV = 'I';
    foreach my $domain ( sort keys %$domains ) {
	print join("\t", '',$domain, $domains->{$domain}), "\n";
    }

    if( exists $domains->{"Chitin_synth_1"} ) { #check the Chitin_synth 1
	if (exists $domains->{"Chitin_synth_1N"} ) {
	    $DIV = 'I';
	} elsif(exists $domains->{"Chitin_synth_2"} ) {
	    $DIV = 'III'; # this might need to change? 
	} else {
	    $DIV = 'Unknown';
	}
    } elsif (exists $domains->{"Chitin_synth_2"} ) { # Or Check Chitin_synth_2
	#check the 2nd domain
	if( exists $domains->{"Cyt-b5"} ) {
	    if( exists $domains->{"DEK_C"} 
		|| exists $domains->{'Myosin_head'} ) {
		$DIV = 'II-five-seven'; 
	    } else {		# doesn't have DEK_C
		$DIV = 'II-four';
	    }
	} else {		# Doesn't have Cyt-b5
	    $DIV = 'III';
	}
    } # end of the domain logic

    print "This is a Division $DIV gene\n";
    print "\n";
    push @{$genes_by_division{$DIV}}, $genename;
}
my $prefix = $file;
$prefix =~ s/\.tab//;
foreach my $division ( keys %genes_by_division ) {
    my $outfile = Bio::SeqIO->new(-file => ">$prefix-$division.fa",
				  -format => 'fasta');
    for my $gene ( @{$genes_by_division{$division}} ) {
	if( my $seq = $dbh->get_Seq_by_acc($gene) ) {
	    $outfile->write_seq($seq);
	} else {
	    warn("Trying to get sequence $gene from the dbfile $db, but it isn't there!");
	}
    }
}
