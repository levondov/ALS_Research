import numpy as np
import sys
from BPM import BPM


class BPMs:
	""" a class for BPM data (at the moment only for TbT data) """
	data_file_str = 0
	data = 0
	numBPM = 0
	BPMlist = []
	
	def __init__(self,data_file):
		self.data_file_str = data_file
		self.__initialize()
		
	def __initialize(self):
		""" initialize the data file, put everything into a nice format """
		try:
			self.data = np.genfromtxt(self.data_file_str)	
		except:
			self.data = np.nan
			print "Something is wrong with the data file: ", sys.exc_info()[0]
			raise
		
		self.__format()	
		
	def __format(self):
		""" format the data into struct form """
		""" note the txt file data should have 2 columns (x,y) with each BPM """
		""" being separated by a row that has both columns as nan """
		
		# check the number of BPMs by checking nan rows
		self.numBPM = np.sum(np.isnan(self.data),0)[0]
		
		# find the number of turns for each BPM
		turns = (len(self.data) - self.numBPM)/self.numBPM
		
		# Make a array of BPMs using the BPM class
		for i in range(0,self.numBPM):
			x = self.data[1+i*(turns+1):(i+1)*(turns+1),0]
			y = self.data[1+i*(turns+1):(i+1)*(turns+1),1]
			s = self.data[1+i*(turns+1):(i+1)*(turns+1),2]
			a = self.data[1+i*(turns+1):(i+1)*(turns+1),3]
			b = self.data[1+i*(turns+1):(i+1)*(turns+1),4]
			c = self.data[1+i*(turns+1):(i+1)*(turns+1),5]
			d = self.data[1+i*(turns+1):(i+1)*(turns+1),6]
			newBPM = BPM(x,y,s,a,b,c,d)
			self.BPMlist.append(newBPM)
			
	def TBT(self):
		return self.BPMlist
		

