import numpy as np 
import os
import sys
import pdb








####################
# Command line args
#####################
regression_snp_list = sys.argv[1]
ldsc_weights_dir = sys.argv[2]


t = open(regression_snp_list,'w')
for chrom_num in range(1,23):
	chrom_rsid_file = ldsc_weights_dir + 'hm3_noMHC.' + str(chrom_num) + '.rsid'
	f = open(chrom_rsid_file)
	for line in f:
		line = line.rstrip()
		t.write(line + '\n')
	f.close()
t.close()
