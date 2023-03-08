#!/bin/bash
for i in $(cat OGs.list)
do 
mafft --auto --thread 16 OGs_pep/${i}.fa > pep_aln/${i}.aln 
done£»