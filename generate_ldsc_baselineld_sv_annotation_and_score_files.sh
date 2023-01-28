#!/bin/bash
#SBATCH -c 1                               # Request one core
#SBATCH -t 0-10:00                         # Runtime in D-HH:MM format
#SBATCH -p short                           # Partition to run in
#SBATCH --mem=20G                         # Memory total in MiB (for all cores)

source ~/.bash_profile



merged_genotype_dir="$1"
baseline_ld_dir="$2"
ldsc_baselineld_sv_dir="$3"
ldsc_weights_dir="$4"
ldsc_code_dir="$5"


# Generate annotation file
if false; then
python3 generate_ldsc_baselineld_sv_annotation_file.py $merged_genotype_dir $baseline_ld_dir $ldsc_baselineld_sv_dir
fi



# Genereate regression snp list
regression_snp_list=${ldsc_baselineld_sv_dir}"hm3_noMHC.rsid"
if false; then
python3 generate_regression_snp_list_from_regression_weights_dir.py $regression_snp_list $ldsc_weights_dir
fi



# Compute ld scores from new annotation and genotype files
source /n/groups/price/ben/environments/sldsc/bin/activate
module load python/2.7.12

for chrom_num in {1..22}; do
	python ${ldsc_code_dir}ldsc.py\
		--l2\
		--bfile ${merged_genotype_dir}snp_sv_merged_EUR_chr${chrom_num}\
		--ld-wind-cm 1\
		--annot ${ldsc_baselineld_sv_dir}baselineLD_SV.${chrom_num}.annot\
		--out ${ldsc_baselineld_sv_dir}baselineLD_SV.${chrom_num}\
		--print-snps ${regression_snp_list}
done