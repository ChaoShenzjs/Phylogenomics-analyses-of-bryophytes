#!/bin/bash
for i in $(cat OGs.list)
do
iqtree -s ./cds_trim/${i}.trim03.phy -alrt 1000 -bb 1000 -nt AUTO
done;