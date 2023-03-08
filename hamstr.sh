#!/bin/bash
for i in $(cat OGs.list)
do
perl hamstr.pl -sequence_file=./data/${i}.cds.fa -est -taxon=TAXON -hmmset=seed_hmmer3 -refspec=mba -representative -cpu=8 -eval_blast=1e-20 -eval_hmmer=1e-20 -central -concat -cleartmp
done;