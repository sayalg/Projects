#! /usr/bin/env python

class geneExpressionTCGA:

	def __init__(self):
		pass
	
	def parse(self, file):
		dictionary = dict()
		for line in file.readlines():
			key, val = line.split()
			dictionary[key] = val
		return dictionary
		
	def search(self, dict, name):
		if name in dict:
			print(dict[name])
		else:
			print("Gene %s not found" % name)
	
	def compare(self, dict1, dict2, name):
		if name in dict1 and name in dict2:
			val1 = round(float(dict1[name]), 4)
			val2 = round(float(dict2[name]), 4)
			diff = (val1 - val2)
		else:
			return "Gene not available for comparison" 
		return "Gene\t 2670\t 2683\t Difference\n%s\t %f\t %f\t %f\n" % (name, val1, val2, diff)

file_2670 = open("TCGA-A6-2670-01A-02R-0821-07-geneExpression.txt")
file_2683 = open("TCGA-A6-2683-01A-01R-0821-07-geneExpression.txt")
TCGA = geneExpressionTCGA()
TCGA_2670 = TCGA.parse(file_2670)
TCGA_2683 = TCGA.parse(file_2683)
TCGA.search(TCGA_2670, "CFHR5")
outfile = TCGA.compare(TCGA_2670, TCGA_2683, "ELMO2")
print(outfile)

with open("output5.txt", "w") as file:
	file.write(outfile)
