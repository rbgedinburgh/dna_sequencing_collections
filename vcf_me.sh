#!/bin/bash

# Calling SNPs from bam files output from Paleomix with the strict fasta reference from living material samples
# Adapted from Nicholls et al. 2015 https://github.com/ckidner/Targeted_enrichment/blob/master/bam_me.sh
# Needs a list of input bam files and the fasta reference (strict consensus) used to assemble the bams.
# Assumes that bam file names contains the accession followed by_consensus.bam
# Assumes that each fasta reference file name contains the accession followed by *consensus.fasta
# Submitted to a server using Slurm - change accordingly
# Flavia Fonseca Pezzini Feb 2023

#SBATCH --job-name="vcfs"
#SBATCH --export=ALL
#SBATCH --mail-user=my@remail
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output ./slurm-%x-%A_%a.out #%A job ID, %a array index %x gives job name
#SBATCH --partition=long
#SBATCH --cpus-per-task=16 #number of threads, not cores
#SBATCH --mem=2G
#SBATCH --array=0-20

acc=$(sed -n "$SLURM_ARRAY_TASK_ID"p /path/to/list/of/accession/names)

echo "Hello world"

echo "Working on $acc"

index=${acc}*consensus.bam
pileup=${acc}.pileup
vcf=${acc}_consensus.vcf
indexvcf=${acc}_consensus.vcf.gz

samtools index $index 2>>$acc.mapping.out
bcftools mpileup -E -f $acc*consensus.fasta  $index > $pileup 2>>$acc.mapping.out
bcftools call -c $pileup > $vcf 2>>$acc.mapping.out
bgzip -c $vcf > $indexvcf
tabix -p vcf $indexvcf

rm ${acc}.pileup

exit 0
