mkdir hamstr_run
sh hamstr.sh
mkdir hamstr_out
cat hamstr_run/*out > ./hamstr_out/all.hamstr.out
cd hamstr_out
sh read_file_by_line_and_sort_by_OGsID.sh
sh tab2fasta.sh
cd ..
mkdir OGs_cds OGs_pep cds_aln cds_trim pep_aln pep_trim trim_info
mv *fa ./OGs_cds/
for i in $(cat OGs.list); do python rename_fasta_seqID.py ./OGs_cds/${i}.fa > ./OGs_cds/${i}.rename.fa; done
sed -i "s/-/N/g" ./OGs_cds/*rename.fa
for i in $(cat OGs.list); do perl cds2prot.pl OGs_cds/${i}.rename.fa > OGs_pep/${i}.fa; done
for i in $(cat OGs.list); do mafft --auto --thread 16 OGs_pep/${i}.fa > pep_aln/${i}.aln; done
for i in $(cat OGs.list); do pal2nal.pl ./pep_aln/${i}.aln ./OGs_cds/${i}.rename.fa -output fasta > ./cds_aln/${i}.aln; done 
for i in $(cat OGs.list); do trimal -in ./pep_aln/${i}.aln -out ./pep_trim/${i}.trim03.phy -gt 0.3 -colnumbering > ./trim_info/${i}.trim.info03; done
for i in $(cat OGs.list); do ./trim4nal ./trim_info/${i}.trim.info03 ./cds_aln/${i}.aln > cds_trim/${i}.trim03.phy; done
