import numpy as np 
import os
import sys
import pdb





existing_fam_file = sys.argv[1]

# Make copy of existing fam file
existing_fam_file_cp = existing_fam_file.split('.')[0] + '_cp.fam'
os.system('cp ' + existing_fam_file + ' ' + existing_fam_file_cp)


f = open(existing_fam_file_cp)
t = open(existing_fam_file,'w')
for line in f:
	line = line.rstrip()
	data = line.split()
	t.write(data[1] + '\t' + data[1] + '\t' + '\t'.join(data[2:]) + '\n')
f.close()
t.close()

