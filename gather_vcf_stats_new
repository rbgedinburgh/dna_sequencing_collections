#! /bin/bash -x
# to gather a table of stats on vcf files
# assumes list of samples as sample.vcf.gz in a text file Samples
# assumes format of vcf files is sample.vcf.gz
# run as ./gather_vcf_stats.sh living_vcf_file
# adapted from Catherine Kidner's https://github.com/ckidner/Basic_Hyb_Seq_Assembly/blob/master/gather_vcf_stats.sh

# Flavia Fonseca Pezzini Feb 2023

livvcf=$1

while read f ; do bcftools stats -c all $livvcf "$f"  > comp_"$f"_stats ; done < Samples

while read f ; do grep "number of SNPs:" comp_"$f"_stats | cut -d":" -f2 >> col_SNPs ; done < Samples
while read f ; do grep "number of indels:" comp_"$f"_stats | cut -d":" -f2 >> col_INDELs ; done < Samples
while read f ; do grep "number of multiallelic sites:" comp_"$f"_stats | cut -d":" -f2 >> col_MULTIALLELs ; done < Samples
while read f ; do grep "^SiS" comp_"$f"_stats  >> col_SiSs ; done < Samples
while read f ; do grep "^TSTV" comp_"$f"_stats >> col_TSTVs ; done < Samples
while read f ; do grep "A>C" comp_"$f"_stats | cut -f4 >> col_ACs ; done < Samples
while read f ; do grep "A>G" comp_"$f"_stats | cut -f4 >> col_AGs ; done < Samples
while read f ; do grep "A>T" comp_"$f"_stats | cut -f4 >> col_ATs ; done < Samples
while read f ; do grep "C>A" comp_"$f"_stats | cut -f4 >> col_CAs ; done < Samples
while read f ; do grep "C>G" comp_"$f"_stats | cut -f4 >> col_CGs ; done < Samples
while read f ; do grep -w "C>T" comp_"$f"_stats | cut -f4 >> col_CTs ; done < Samples
while read f ; do grep "G>A" comp_"$f"_stats | cut -f4 >> col_GAs ; done < Samples
while read f ; do grep "G>C" comp_"$f"_stats | cut -f4 >> col_GCs ; done < Samples
while read f ; do grep "G>T" comp_"$f"_stats | cut -f4 >> col_GTs ; done < Samples
while read f ; do grep "T>A" comp_"$f"_stats | cut -f4 >> col_TAs ; done < Samples
while read f ; do grep "T>C" comp_"$f"_stats | cut -f4 >> col_TCs ; done < Samples
while read f ; do grep "T>G" comp_"$f"_stats | cut -f4 >> col_TGs ; done < Samples

while read f ; do echo "$f"'	Self' >> tmp; echo "$f"'	Ref' >> tmp ; echo "$f"'	Both' >> tmp ; done < Samples

#echo "Sample	Type	AC	AG	AT	CA	CG	CT	GA	GC	GT		INDELS		MULTIALLELS		SNPs	singleton stats	SiS-ID	allele_count	Number of snps	number of transitions	number of transversions	number of indels	repeatr consistent	repeont inconsitent	not applicatble	TA	TC	TG		id	ts	tv	ts/tv	ts 1st allele	tv 1st allele	ts/tv 1st allele" > row1
#paste tmp col_* > tmp2
#cat row1 tmp2 > vcf_stats_liv_herb_$liv_vcf.txt

paste tmp col_* > vcf_stats_"$livvcf".txt
rm col_*
rm tmp


exit 0

# each grep gives 3 lines.  First is in the query only, second in ref only, third in both
