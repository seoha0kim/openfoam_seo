#!/usr/bin/env python

"""d_blockMesh.py: generate a blockMeshDict for openFoam CFD of a deck."""

__author__ = "Saang Bum Kim"
__copyright__ = "Copyright (C) 2017 Saang Bum Kim"
__credits__ = ["Saang Bum Kim"]
# __license__ = "GPL"
# __license__ = "Public Domain"
__version__ = "1.0.0"
__date_ = "2017-08-21T10:01:49+09:00"
__maintainer__ = "Saang Bum Kim"
__email__ = "sbkimwind@gmail.com"
__status__ = "Production"


#
#   PART I.     Pre Process
#
# reset
id_pl = True
# id_pl = False

import numpy as np
import time
import matplotlib.pyplot as plt
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.rcParams['text.latex.preamble'] = [
    r'\usepackage{siunitx}',   # i need upright \micro symbols, but you need...
    r'\sisetup{detect-all}',   # ...this to force siunitx to actually use your fonts
    # r'\usepackage{helvet}',    # set the normal font here
    r'\usepackage{libertine}',    # set the normal font here
    r'\usepackage{sansmath}',  # load up the sansmath so that math -> helvet
    r'\sansmath'
]
plt.rcParams['font.size'] = 13
plt.rcParams['axes.linewidth'] = 0.5
plt.rcParams['lines.linewidth'] = 0.5

import os

from scipy.io import loadmat
from scipy.io import savemat


#
#   FILE I/O
#
# s_now = time.strftime("%Y%m%d_%H%M%S")
s_now = time.strftime("%Y%m%d")
# print(s_now)

fileName = 'd_openFoam_post_' + s_now + '.log'
f_in = open(fileName, 'w')
f_in.write('#\n')
f_in.write('#   d_openFoam_post\n')
f_in.write('#   Author: Saang Bum Kim, sbkim1601@gmail.com\n')
f_in.write('#   Date  : 2017-08-25T16:55:40+09:00\n')
f_in.write('#\n')


#
#   PART II.    Steady-state wind load coefficients
#
fileName = 'forceCoeffs.dat'
f_d = open(fileName, 'r')

x = []
for line in f_d:
    n = len(line)
    if n > 0:
        if line[0] != '#':
            x0 = line.split('\t')
            x1 = [float(xi) for xi in x0]
            # print(x1)
            x.append(x1)

fileName = '../500/forceCoeffs.dat'
f_d = open(fileName, 'r')
for line in f_d:
    n = len(line)
    if n > 0:
        if line[0] != '#':
            x0 = line.split('\t')
            x1 = [float(xi) for xi in x0]
            # print(x1)
            x.append(x1)

# print(x)
y = np.array(x)

#
#
#
filled_markers = ('o', 'v', '^', '<', '>', '8', 's', 'p', '*', 'h', 'H', 'D', 'd', 'P', 'X')

h1, = plt.plot(y[:,0],y[:,1],marker=filled_markers[0],fillstyle='none',markevery=5)
h2, = plt.plot(y[:,0],y[:,2],marker=filled_markers[6],fillstyle='none',markevery=5)
h3, = plt.plot(y[:,0],y[:,3],marker=filled_markers[2],fillstyle='none',markevery=5)
h4, = plt.plot(y[:,0],y[:,4],marker=filled_markers[3],fillstyle='none',markevery=5)
h5, = plt.plot(y[:,0],y[:,5],marker=filled_markers[4],fillstyle='none',markevery=5)
plt.legend([h1,h2,h3,h4,h5],['$C_{m}$','$C_{d}$','$C_{l}$','$C_{lf}$','$C_{lr}$'])
plt.xlabel('Iteration \#')
plt.ylabel('Wind load coefficients')
plt.grid()
# plt.legend(handles=[h1])
# plt.legend(handles=[h2])
plt.show()

f_in.write('\n')
f_in.write('\n#')
f_in.write('\n#   FINE')
f_in.write('\n#')
f_in.close()

#
#   FINE
#