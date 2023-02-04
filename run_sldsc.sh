#!/bin/bash
#SBATCH -c 1                               # Request one core
#SBATCH -t 0-13:00                         # Runtime in D-HH:MM format
#SBATCH -p medium                           # Partition to run in
#SBATCH --mem=20G                         # Memory total in MiB (for all cores)



merged_genotype_dir="$1"
ldsc_baselineld_sv_dir="$2"
ldsc_weights_dir="$3"
ldsc_code_dir="$4"
ldsc_sumstats_dir="$5"
ldsc_sv_results_dir="$6"


source /n/groups/price/ben/environments/sldsc/bin/activate
module load python/2.7.12

trait_name="blood_WHITE_COUNT"
trait_file=$ldsc_sumstats_dir"UKB_460K."$trait_name".sumstats"
if false; then
python ${ldsc_code_dir}ldsc.py --h2 ${trait_file} --ref-ld-chr ${ldsc_baselineld_sv_dir}"baselineLD_SV." --w-ld-chr ${ldsc_weights_dir}"weights.hm3_noMHC." --overlap-annot --print-coefficients --frqfile-chr ${merged_genotype_dir}"snp_sv_merged_EUR_chr" --out ${ldsc_sv_results_dir}${trait_name}"_sldsc_baselineLD_SV"
fi


trait_name="body_BMIz"
trait_file=$ldsc_sumstats_dir"UKB_460K."$trait_name".sumstats"
python ${ldsc_code_dir}ldsc.py --h2 ${trait_file} --ref-ld-chr ${ldsc_baselineld_sv_dir}"baselineLD_SV." --w-ld-chr ${ldsc_weights_dir}"weights.hm3_noMHC." --overlap-annot --print-coefficients --frqfile-chr ${merged_genotype_dir}"snp_sv_merged_EUR_chr" --out ${ldsc_sv_results_dir}${trait_name}"_sldsc_baselineLD_SV"
