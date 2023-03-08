#!/bin/bash
for i in $(cat OGs.list)
do
awk '{print ">" $0}' ${i} > ${i}.fa
sed -i 's/|1|/&\n/' ${i}.fa
sed -i "s/|1|//g" ${i}.fa
done;