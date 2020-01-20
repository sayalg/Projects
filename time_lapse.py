#! /user/bin/env python3

import time
import random
from matplotlib.figure import Figure
from matplotlib import pyplot as plt


class timesort:
	def __init__(self):
		self.cap = 500
		self.list = []
		self.nlist = 2
		self.timelapse = []
		self.length = []

	def data(self):
		if self.nlist != self.cap:
			for x in range(self.cap):
				list = random.sample(range(10000), self.nlist)
				start = time.time()
				list.sort()
				end = time.time()
				self.timelapse.append(end-start)
				self.length.append(len(list))
				self.nlist = self.nlist + 1
		else:
			pass
	
	def timeplot(self):
		fig, ax = plt.subplots( nrows=1, ncols=1 )
		ax.plot(self.length, self.timelapse)
		fig.savefig('fig.png')


timespent = timesort()
timespent.data()
timespent.timeplot()
