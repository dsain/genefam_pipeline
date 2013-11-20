#!/bin/bash

GENE=$1
ALNFILE=$2

SCRIPTS_DIR=`pwd`
BASE_ALNFILE=`basename $ALNFILE .aln`

bp_sreformat.pl -if fasta -of phylip -i $ALNFILE -o ${BASE_ALNFILE}.phy --special=flat

mkdir ModelSelection_$GENE
cp ${BASE_ALNFILE}.phy SCRIPTS_DIR/ModelSelection_$GENE
cd ModelSelection_$GENE
nohup ProteinModelSelection.pl ${BASE_ALNFILE}.phy >& modelselection_$GENE.out &
echo "!!!!look for the modelname in modelselection_$GENE.out and run

qsub -q highmem -l nodes=1:ppn=12 pipeline_4.sh ${BASE_ALNFILE}.phy 'modelname'"

