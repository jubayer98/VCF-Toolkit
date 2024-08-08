### Working with VCF Files using BCFTools

This documentation outlines steps to manage VCF files, including compressing, indexing, querying chromosomes, counting variants, and comparing multiple VCF files using BCFTools. The provided instructions are formatted for use on an HPC (High-Performance Computing) environment.

#### 1. Creating and Activating a Conda Environment
First, create and activate a Conda environment for installing and running BCFTools.

```bash
# Create a Conda environment
conda create --name myenv

# Activate the Conda environment
conda activate myenv

# Install BCFTools
conda install -c bioconda bcftools
```

#### 2. Compressing and Indexing VCF Files
To efficiently manage large VCF files, compress and index them using bgzip and tabix.

```bash
# Compress the .vcf file using bgzip
bgzip filename.vcf

# Create a tabix index file for the bgzip-compressed VCF
tabix -p vcf filename.vcf.gz

# Create an index for the VCF file
bcftools index filename.vcf.gz
```

#### 3. Querying Chromosomes from VCF Files
Retrieve and save the list of unique chromosomes present in the VCF file.

```bash
# Query all chromosomes list
bcftools query -f '%CHROM\n' filename.vcf.gz

# Count the total number of unique chromosomes
bcftools query -f '%CHROM\n' filename.vcf.gz | uniq | wc -l

# Save the list of unique chromosomes in a text file
bcftools query -f '%CHROM\n' filename.vcf.gz | uniq > chromosomes.txt

# Display the contents of the text file
cat chromosomes.txt
```

#### 4. Counting Variants per Chromosome
Create a shell script to count all variants/mutations per chromosome and save it as `chromosome_count.sh`.

```bash
# Create a .sh file
touch chromosome_count.sh

# Edit the .sh file using nano
nano chromosome_count.sh

# Add the following content to the file
#!/bin/bash
chromlist=($(cat chromosomes.txt))
for chrom in ${chromlist[@]}; do
    count=$(bcftools view -r $chrom filename.vcf.gz | grep -v -c '^#')
    echo "$chrom:$count"
done
```

#### 5. Finding Common Variants Among Multiple VCF Files
Use BCFTools to find common variants among multiple VCF files.

```bash
# Find common variants among three VCF files
bcftools isec -n=3 filename1.snps.vcf.gz filename2.snps.vcf.gz filename3.snps.vcf.gz | wc -l
```

#### 6. Filtering Variants with a "PASS" Status
Retain only the variants that have a filter status of "PASS".

```bash
# Filter variants with "PASS" status
bcftools view -f PASS input.vcf > output.vcf
```

#### 7. Comparing Records Across VCF Files
Compare all records (variants) in the input VCF files for intersection.

```bash
# Compare records for intersection
bcftools isec -n=2 -c all -o normal_tumor_common.vcf normal_sample.vcf.gz tumor_sample.vcf.gz
```

#### 8. Merging VCF Files
Merge multiple VCF files into one.

```bash
# Merge VCF files
bcftools merge --merge all normal_sample.vcf.gz tumor_sample.vcf.gz -O v > normal_tumor_merge.vcf
```

#### 9. Finding Unique Variants Between VCF Files
Compare VCF files and find the unique variants between them.

```bash
# Find unique variants between two VCF files
bcftools isec -C normal_sample.vcf.gz tumor_sample.vcf.gz > normal_tumor_unique.vcf
```

This guide should help you manage VCF files effectively using BCFTools in an HPC environment. For more advanced usage and options, refer to the [BCFTools documentation](http://samtools.github.io/bcftools/bcftools.html).
