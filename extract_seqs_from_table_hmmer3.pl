#!/usr/bin/perl -w
use strict;
use Bio::DB::Fasta;
use Bio::SeqIO;
use Getopt::Long;
my $cutoff = 1e-100;
my $db;

GetOptions(
	   'c|cutoff:s' => \$cutoff,
	   'db:s'       => \$db,	   
	   );
	

# make a while loop
my %unique;
while (<>) {
next if /^\#/;
chomp;	
  my ($sequence,$undef1,$tlen,$query,$undef2,$qlen,$evalue,$score,$bias,$no,$of,$cEvalue, $iEvalue, $score1, $bias1,$query_start,$query_end, $from, $to, $target_start, $target_end, $undef3, $undef4) = split(/\s+/,$_);
 next unless $evalue <= $cutoff;
 $unique{$sequence}++;
}

if( $db ) {
 my $dbh = Bio::DB::Fasta->new($db,-glob => '*.{fa,fas,fasta,pep,peps,aa,nt,seq}');
 my $out = Bio::SeqIO->new(-format => 'fasta');
 for my $t ( keys %unique) {
   $out->write_seq($dbh->get_Seq_by_acc($t));
 }
} else {
 for my $t ( keys %unique) {
  print $t, "\n";
 }
}

 

