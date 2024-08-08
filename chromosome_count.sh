#!/bin/bash
chromlist=($(cat chromosomes.txt))
for chrom in ${chromlist[@]}; do
    count=$(bcftools view -r $chrom filename.vcf.gz | grep -v -c '^#')
    echo "$chrom:$count"
done
