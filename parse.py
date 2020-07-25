#! /usr/bin/env python3

from Bio import SeqIO

file = open('ncbi.gb')
for gb_record in SeqIO.parse(file, 'genbank'):
	acc = gb_record.annotations['accessions'][0]
	#loc = gb_record.location
	host = ""
	for feature in gb_record.features:
		if feature.type == "host":
			host = feature
	print(acc, host)
