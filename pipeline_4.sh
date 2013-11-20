#!/bin/bash
cd $PBS_O_WORKDIR
SCRIPTS_DIR=`pwd`
PHYFILE=$1
MODEL=$2
BASE_PHYFILE=`basename $PHYFILE .phy`
module load stajichlab
module load RAxML/7.3.2
raxmlHPC-PTHREADS-SSE3 -T 12 -N 100 -f a -s $PHYFILE -n ${BASE_PHYFILE} -m PROTGAMMA$MODEL -x 121 -p 1 

mv RAxML_bipartitions.${BASE_PHYFILE} RAxML_bipartitions.${BASE_PHYFILE}.tre
perl SCRIPTS_DIR/renametree.pl RAxML_bipartitions.${BASE_PHYFILE}.tre SCRIPTS_DIR/lookup_CHSnames_new.dat > RAxML_bipartitions.${BASE_PHYFILE}.rename.tre