import numpy as np


for ii in range(3):
    ij = (ii+1,ii+2,ii+3)
    print(ij)
    print(ij[-1::-1])

# a = [1,2,3]
# b = [4,5]

# c = np.hstack([a,b,a[2:0:-1],b*3]*2)

# print(c)