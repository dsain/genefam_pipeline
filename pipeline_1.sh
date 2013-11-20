HMM=$1 #chs.hmm
FASTA=$2 #fundb.fa

SCRIPTS_DIR=`pwd`

BASE_HMM=`basename $HMM .hmm`
BASE_FASTA=`basename $FASTA .fa`


#if [ ! -e ${BASE_HMM}_vs_${BASE_FASTA}.HMMSEARCH  ] && [ -s  ${BASE_HMM}_vs_${BASE_FASTA}.HMMSEARCH  ]  ; then
#echo "hmmsearch --domtblout ${BASE_HMM}_vs_${BASE_FASTA}.HMMSEARCH.tab -E 1 $HMM $FASTA > ${BASE_HMM}_vs_${BASE_FASTA}.HMMSEARCH

#"
hmmsearch --domtblout ${BASE_HMM}_vs_${BASE_FASTA}.HMMSEARCH.tab -E 1 $HMM $FASTA > ${BASE_HMM}_vs_${BASE_FASTA}.HMMSEARCH
#fi

#if [ ! -e ${BASE_HMM}_vs_${BASE_FASTA}.hits.fa ] ; then
#echo "perl $SCRIPTS_DIR/extract_seqs_from_table_hmmer3.pl -db $FASTA -c 0.01 ${BASE_HMM}_vs_${BASE_FASTA}.HMMSEARCH.tab  > ${BASE_HMM}_vs_${BASE_FASTA}.hits.fa

#" 
perl $SCRIPTS_DIR/extract_seqs_from_table_hmmer3.pl -db $FASTA -c 0.01 ${BASE_HMM}_vs_${BASE_FASTA}.HMMSEARCH.tab  > ${BASE_HMM}_vs_${BASE_FASTA}.hits.fa 
#fi

#if [ ! -e ${BASE_HMM}_vs_${BASE_FASTA}.hits.hmmscan ] ; then 
#echo "hmmscan -E 1e-3 --tblout ${BASE_HMM}_vs_${BASE_FASTA}_hmmscan.tab ~/bigdata-shared/db/Pfam-24/Pfam-A.hmm ${BASE_HMM}_vs_${BASE_FASTA}.hits.fa > ${BASE_HMM}_vs_${BASE_FASTA}.hits.hmmscan

#"
hmmscan -E 1e-3 --tblout ${BASE_HMM}_vs_${BASE_FASTA}_hmmscan.tab ~/bigdata-shared/db/Pfam-24/Pfam-A.hmm ${BASE_HMM}_vs_${BASE_FASTA}.hits.fa > ${BASE_HMM}_vs_${BASE_FASTA}.hmmscan.fa
#fi

#if [ ! -e $BASE_HMM.divisions ] ; then 
#echo "perl parse_hmmscantable.pl ${BASE_HMM}_vs_${BASE_FASTA}_hmmscan.tab $FASTA > $BASE_HMM.divisions

#"
perl parse_hmmscantable.pl ${BASE_HMM}_vs_${BASE_FASTA}_hmmscan.tab $FASTA > $BASE_HMM.divisions
#fi

echo "!!!!!! manually filter ${BASE_HMM}_vs_${BASE_FASTA}.hits.fa using  ${BASE_HMM}.division now and save the file as ${BASE_HMM}_vs_${BASE_FASTA}.pruned.hits.fa  !!!!! 

Once finished execute pipeline_2.sh like this:

./pipeline_2.sh $HMM $FASTA ${BASE_HMM}_vs_${BASE_FASTA}.pruned.hits.fa 
"

