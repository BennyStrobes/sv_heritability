#!/bin/bash
#SBATCH -c 1                               # Request one core
#SBATCH -t 0-13:00                         # Runtime in D-HH:MM format
#SBATCH -p medium                           # Partition to run in
#SBATCH --mem=20G                         # Memory total in MiB (for all cores)

source ~/.bash_profile


common_snp_plink_dir="$1"
sv_vcf_file="$2"
merged_genotype_dir="$3"

# Convert SV vcf to plink format
# Note: I am restricting here to bi-allelic variants (MAYBE THAT IS BAD??)
sv_plink_stem=${merged_genotype_dir}"sv_only"
plink2 --vcf ${sv_vcf_file} --max-alleles 2 --make-bed --out ${sv_plink_stem}



# Perform hack to deal with fact first column of sv plink fam file is 0
python3 hack_fix_of_zero_column_in_sv_plink_file.py ${merged_genotype_dir}"sv_only.fam"


# Filter to European individuals in 1KG (and have those individuals match snp ukbb individuals)
eur_sv_plink_stem=${merged_genotype_dir}"sv_only_EUR_"
plink2 --bfile ${sv_plink_stem} --keep ${common_snp_plink_dir}"1000G.EUR.QC.22.fam" --make-bed --out ${eur_sv_plink_stem}



# Filter to svs with european maf > .005 and is on chrom 1-22
eur_sv_common_plink_stem=${merged_genotype_dir}"sv_only_EUR_common_"
plink2 --bfile ${eur_sv_plink_stem} --maf "0.005" --chr 1-22 --make-bed --out ${eur_sv_common_plink_stem}


# MERGE SVs and snps
stringer=""
for chr in {1..22}; do
	stringer=${stringer}${common_snp_plink_dir}"1000G.EUR.QC."${chr}"\n"
done

joint_plink_stem=${merged_genotype_dir}"snp_sv_merged_EUR"
printf ${stringer} > ${merged_genotype_dir}"temp_file.txt"
plink --bfile ${eur_sv_common_plink_stem} --merge-list ${merged_genotype_dir}"temp_file.txt" --make-bed --out ${joint_plink_stem}


# Currently SV's CM column is set to zero
# Add hack to set CM column to CM value of closest possible snp with CM column
python3 hack_fix_of_no_cm_values_for_svs.py ${joint_plink_stem}".bim"


# split up final plink file into seperate files for each chromosome
for chr in {1..22}; do
	plink --bfile ${joint_plink_stem} --chr $chr --make-bed --out ${joint_plink_stem}"_chr"$chr
done


