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
id_pl = False

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
# plt.rcParams['font.size'] = 13
plt.rcParams['axes.linewidth'] = 0.5
plt.rcParams['lines.linewidth'] = 0.5

import os

from scipy.io import loadmat
from scipy.io import savemat


#
#   PART II.    Vertices
#

#
#   Deck
#
infile = os.path.join(os.path.dirname(__file__), 'deck_vertices.mat')
indict = loadmat(infile)
x = indict['x'].tolist()
id_c1 = [1,2,3,11,18,20,19,17,16,15,14,13,12,10,9,8,7,6,5,4,1]
id_c0 = id_c1[-1::-1]
xs = np.array([[x[0][ii-1],x[1][ii-1]] for ii in id_c0])
xs = xs.T

# print(max(xs[0]))

lam_L = 80

dx = [max(xs[0])-min(xs[0]),max(xs[1])-min(xs[1])]
x0 = [(max(xs[0])+min(xs[0]))/2,(max(xs[1])+min(xs[1]))/2]

xs0 = xs
xs = np.array([(xi - x0)/lam_L for xi in xs0.T]).T

if not id_pl:
# if id_pl:
    # plt.plot(xs.T[0],xs.T[1])
    plt.plot(xs[0],xs[1])
    plt.axis('equal')
    plt.grid()
    plt.show()


print(xs)
print(x0)