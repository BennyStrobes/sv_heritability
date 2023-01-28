import numpy as np 
import os
import sys
import pdb
import gzip

def extract_ordered_merged_variants(bim_file):
	dicti = {}
	for chrom_num in range(1,23):
		dicti[chrom_num] = []
	f = open(bim_file)
	for line in f:
		line = line.rstrip()
		data = line.split('\t')
		chrom_num = int(data[0])
		variant_id = data[1]
		variant_string = data[0] + '\t' + data[3] + '\t' + data[1] + '\t' + data[2]
		dicti[chrom_num].append((data[1],variant_string))
	f.close()
	for chrom_num in range(1,23):
		dicti[chrom_num] = dicti[chrom_num]
	return dicti

def generate_annotation_file_for_single_chromosome(ordered_variants, baseline_ld_dir, ldsc_baselineld_sv_dir, chrom_num):
	# Existing baselineld annotation file
	baselineld_anno_file = baseline_ld_dir + 'baselineLD.' + str(chrom_num) + '.annot.gz'
	# New baselineld_sv annotation file
	baselineld_sv_anno_file = ldsc_baselineld_sv_dir + 'baselineLD_SV.' + str(chrom_num) + '.annot'

	# Create mapping from rsid to baselineld annotation vector
	rsid_to_baselineld = {}
	f = gzip.open(baselineld_anno_file)
	head_count = 0
	for line in f:
		line = line.decode('utf-8').rstrip()
		data = line.split('\t')
		if head_count == 0:
			head_count = head_count + 1
			snp_anno_names = np.asarray(data)
			continue
		rsid = data[2]
		annotation_vec = np.asarray(data[4:])
		if rsid in rsid_to_baselineld:
			print('assumption error')
			pdb.set_trace()
		rsid_to_baselineld[rsid] = annotation_vec
	f.close()

	# Print new annotation file
	t = open(baselineld_sv_anno_file,'w')
	t.write('\t'.join(snp_anno_names) + '\tSV_base\n')
	for ordered_variant_tuple in ordered_variants:
		rsid = ordered_variant_tuple[0]
		row_header = ordered_variant_tuple[1]
		if rsid in rsid_to_baselineld:
			t.write(row_header + '\t' + '\t'.join(rsid_to_baselineld[rsid]) + '\t0\n')
		else:
			if rsid.startswith('rs'):
				print('assumptoin eroror')
				pdb.set_trace()
			snp_anno_vec = np.zeros(len(snp_anno_names[4:]))
			snp_anno_vec[0] = 1.0
			t.write(row_header + '\t' + '\t'.join(snp_anno_vec.astype(int).astype(str)) + '\t1\n')
	t.close()
	return



# Command line args
merged_genotype_dir = sys.argv[1]
baseline_ld_dir = sys.argv[2]
ldsc_baselineld_sv_dir = sys.argv[3] # Outputdir

merged_bim_file = merged_genotype_dir + 'snp_sv_merged_EUR.bim'
merged_variants = extract_ordered_merged_variants(merged_bim_file) # Seperate array for each chromosome


for chrom_num in range(1,23):
	print(chrom_num)
	generate_annotation_file_for_single_chromosome(merged_variants[chrom_num], baseline_ld_dir, ldsc_baselineld_sv_dir, chrom_num)

