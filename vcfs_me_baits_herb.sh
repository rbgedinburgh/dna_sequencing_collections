#!/bin/bash

#SBATCH --job-name="vcfs"
#SBATCH --export=ALL
#SBATCH --mail-user=fpezzini@rbge.org.uk
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output ./slurm-%x-%A_%a.out #%A job ID, %a array index %x gives job name
#SBATCH --partition=long
#SBATCH --cpus-per-task=16 #number of threads, not cores
#SBATCH --mem=2G


acc=$2

ref=$1

echo "Hello world"

echo "Working on $acc"

index=${acc}_consensus.bam
pileup=${acc}.pileup
vcf=${acc}_consensus.vcf
indexvcf=${acc}_consensus.vcf.gz

samtools index $index 2>>$acc.mapping.out
bcftools mpileup -E -f $ref  $index > $pileup 2>>$acc.mapping.out
bcftools call -c $pileup > $vcf 2>>$acc.mapping.out
bgzip -c $vcf > $indexvcf
tabix -p vcf $indexvcf

rm ${acc}.pileup

exit 0
