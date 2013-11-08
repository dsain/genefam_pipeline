#!/bin/bash
cd ~/project/cell_wall/beta-glucan/1-3bg/synth/fks1
for file in *.fas
do
 filebase=`basename $file .fas`
 echo "Processing file: $file"
 /usr/local/bin/t_coffee $file
 /usr/local/bin/bp_sreformat.pl -if clustalw -of fasta -i $filebase.aln -o $filebase.fasaln
 hmmbuild -F $filebase.hmm $filebase.fasaln
 hmmcalibrate $filebase.hmm

  hmmsearch -E 1e-3 $filebase.hmm /home/dsain/project/cell_wall/db/repdb_cw > $filebase"_vs_repdb_cw.hmmsearch"

  /usr/local/bin/bp_hmmer_to_table.pl $filebase"_vs_repdb_cw.hmmsearch" > $filebase"_vs_repdb_cw.hmmsearch.tab"
  # extract the full sequences back out
  perl $HOME/projects/stajichlab/labcode/cell_wall/scripts/extract_seqs_from_table.pl -db /home/dsain/project/cell_wall/db/repdb_cw -c 1e-50 $filebase"_vs_repdb_cw.hmmsearch.tab" > $filebase"_vs_repdb_cw.hmmsearch.fas"

# end running perl script
 hmmalign -q --outformat=clustal $filebase.hmm $filebase"_vs_repdb_cw.hmmsearch.fas" > $filebase"_vs_repdb_cw.hmmalign"
 /usr/local/bin/bp_sreformat.pl -if clustalw -of phylip -i $filebase"_vs_repdb_cw.hmmalign" -o $filebase"_vs_repdb_cw.phy" --special="idlength=20"
 /srv/projects/stajichlab/bin/raxmlHPC-PTHREADS -T 8 -N 100 -f a -s $filebase"_vs_repdb_cw.phy" -n $filebase"_vs_repdb_cw" -m PROTMIXWAG -x 121
 /usr/local/bin/bp_tree2pag.pl -if newick -of newick -i RAxML_bipartitions.$filebase"_vs_repdb_cw" -o RAxML_bipartitions.$filebase"_vs_repdb_cw.tre"
done