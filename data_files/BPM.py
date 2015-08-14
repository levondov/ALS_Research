
class BPM:
	""" a class to mimic the struct arrays for BPMs in matlab """
	X = []
	Y = []
	S = []
	A = []
	B = []
	C = []
	D = []
	
	def __init__(self,X,Y,S,A,B,C,D):
		self.X = X
		self.Y = Y
		self.S = S
		self.A = A
		self.B = B
		self.C = C
		self.D = D

