#!/bin/bash

PRUNED=$1

SCRIPTS_DIR=`pwd`

BASE_PRUNED=`basename $PRUNED .fa`

## run muscle ###
echo "muscle -in $PRUNED -out ${BASE_PRUNED}.aln 

"
muscle -in $PRUNED -out ${BASE_PRUNED}.aln 
## finished muscle

module load stajichlab
module load FastTree
echo "FastTreeMP ${BASE_PRUNED}.aln > ${BASE_PRUNED}.tre

" 
FastTreeMP ${BASE_PRUNED}.aln > ${BASE_PRUNED}.tre 

echo "perl $SCRIPTS_DIR/renametree.pl ${BASE_PRUNED}.tre lookup_CHSnames_new.dat > ${BASE_PRUNED}.rename.tre

"
perl $SCRIPTS_DIR/renametree.pl ${BASE_PRUNED}.tre $SCRIPTS_DIR/lookup_CHSnames_new.dat > ${BASE_PRUNED}.rename.tre

echo "!!!!After examining the tree run pipeline_3.sh like this:

./pipeline_3.sh 'Name of the gene' ${BASE_PRUNED}.aln
"
