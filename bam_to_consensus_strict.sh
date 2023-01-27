#!/bin/bash

# Calling strict consensus from bam files output from Paleomix bam pipeline
# Following https://github.com/ckidner/Basic_Hyb_Seq_Assembly/blob/master/bam_to_fasta_strict.sh
# Needs a list of input bam files and the fasta reference (baits) used to assemble the bams.
# Submitted to a server using Slurm - change accordingly
# Flavia Fonseca Pezzini Feb 2023

#SBATCH --job-name="vcfs_R"
#SBATCH --export=ALL
#SBATCH --mail-user=my@email
#SBATCH --mail-type=END,FAIL
#SBATCH --output ./slurm-%x-%A_%a.out #%A job ID, %a array index %x gives job name
#SBATCH --partition=long
#SBATCH --cpus-per-task=16 #number of threads, not cores
#SBATCH --mem=2G
#SBATCH --array=0-10

acc=$(sed -n "$SLURM_ARRAY_TASK_ID"p /path/to/list/of/bam/files)

echo "Hello world"

echo "Working on $acc"

index=${acc}.bam
vcf=${acc}_strict.vcf
consensus=${acc}_consensus.fasta

samtools index $index 2>>$acc.mapping.out

bcftools mpileup -B -Ou -f /path/to/fasta/reference/used/to/build/bams.fasta $index | bcftools call -c -Ou | bcftools filter -i 'QUAL>160 && DP>10' -Ou | bcftools view -o $vcf

# -B disable re-calculation of P values to reduce false SNPs
# -Ou output as uncompressed for piping
# -m allow multiallelic caller
# -v output variant sites only
# -i include only those which match the filter (here for homozygous alternate)
# -c use original calling method

perl vcfutils_fasta.pl vcf2fq $vcf > $consensus



exit 0
