#!/usr/bin/env python3

import re, sys
from Bio import SeqIO

def count_mat_peptides_per_record():
	input = "sequence.gb.txt"
	result_dic = {}
	for record in SeqIO.parse(input, "genbank"):
		count_mp = 0
		for feature in record.features:
			if(feature.type == "mat_peptide"):
				count_mp += 1
		result_dic[record.id] = count_mp
	return result_dic

def report_count(result_dic):
	sys.stdout.write("Entries: {}\nPeptides per entry:\n".format(len(result_dic)))
	count = 0
	for id in sorted(result_dic):
		sys.stdout.write("{}\t{}\n".format(id, result_dic[id]))
		if result_dic[id] != 0:
			count += 1
	sys.stdout.write("Entries with annotations beyond the polyprotein level: {} ({})\n".format(count, float(count)/float(len(result_dic))))
	return

result_dic = count_mat_peptides_per_record()
report_count(result_dic)

exit()
