import numpy as np 
import os
import pdb
import sys






bim_file = sys.argv[1]

# copy bim file
bim_file_cp = bim_file.split('.')[0] + '_cp.bim'
os.system('cp ' + bim_file + ' ' + bim_file_cp)



f = open(bim_file_cp)
t = open(bim_file,'w')
prev_chrom="0"
prev_cm="0"
for line in f:
	line = line.rstrip()
	data = line.split('\t')
	line_variant_id = data[1]
	line_chrom = data[0]
	line_cm = data[2]
	if line_variant_id.startswith('rs') or line_variant_id.startswith('ss'):
		t.write(line + '\n')
		prev_chrom = line_chrom
		prev_cm = line_cm
	else:
		if prev_chrom != line_chrom:
			prev_cm = "0"
		if line_cm != "0":
			print('assumptoiner roro')
			pdb.set_trace()
		t.write(data[0] + '\t' + data[1] + '\t' + prev_cm + '\t' + data[3] + '\t' + data[4] + '\t' + data[5] + '\n')
f.close()
f.close()