###########################
# Input data
###########################
# LDSC code directory
ldsc_code_dir="/n/groups/price/ldsc/ldsc/"

# VCF for SVs called in 1K-genomes
sv_vcf_file="/n/groups/price/1000G/SV/ALL.wgs.integrated_sv_map_v2.20130502.svs.genotypes.vcf.gz"

# S-LDSC preprocessed plink files for common snps in 1K-genomes
common_snp_plink_dir="/n/groups/price/ldsc/reference_files/1000G_EUR_Phase3/plink_files/"

# S-LDSC baselindLD dir
baseline_ld_dir="/n/groups/price/ldsc/reference_files/1000G_EUR_Phase3/baselineLD_v2.2/"

# S-LDSC regression snp weights directory
ldsc_weights_dir="/n/groups/price/ldsc/reference_files/1000G_EUR_Phase3/weights/"

###########################
# Output data
###########################
# Output root directory
temp_output_root="/n/scratch3/users/b/bes710/sv_heritability/"
perm_output_root="/n/groups/price/ben/sv_heritability/"

# Directory to store merged genotype data (across svs and common snps)
merged_genotype_dir=$temp_output_root"merged_genotype/"

# Directory store joint-snp-sv ldsc annotation and scores
ldsc_baselineld_sv_dir=$temp_output_root"ldsc_baselineld_sv/"




###########################
# Merge snp and SV plink files
###########################
if false; then
sh merge_snp_and_sv_genotype_data.sh $common_snp_plink_dir $sv_vcf_file $merged_genotype_dir
fi

###########################
# Generate joint-snp-sv ldsc annotation and score files
###########################
if false; then
sbatch generate_ldsc_baselineld_sv_annotation_and_score_files.sh $merged_genotype_dir $baseline_ld_dir $ldsc_baselineld_sv_dir $ldsc_weights_dir $ldsc_code_dir
fi