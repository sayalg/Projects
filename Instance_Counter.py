#! /usr/bin/env python

class InstanceClass:
	InstanceCount = 0
	
	@classmethod
	def IncrementCount(self):
		self.InstanceCount += 1 
		
	def __init__(self, args):
		self.number = self.InstanceCount
		self.IncrementCount()
	
	def display(self):
		return self.InstanceCount

file1 = open("TCGA-A6-2670-01A-02R-0821-07-geneExpression.txt")
file2 = open("TCGA-A6-2683-01A-01R-0821-07-geneExpression.txt")
out = open("Output4.txt", "w")
inst1 = InstanceClass(file1)
print(inst1.display())
out.write(str(inst1.display()) + "\n")
inst2 = InstanceClass(file2)
print(inst2.display())
out.write(str(inst2.display()) + "\n")
print(inst1.display())
out.write(str(inst1.display()) + "\n")
