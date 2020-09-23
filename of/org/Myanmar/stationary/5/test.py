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
# if False:
if True:
    # reset
    id_pl = True
    # id_pl = False

    import numpy as np
    import time

    import matplotlib.pyplot as plt
    plt.rc('text', usetex=True)
    # plt.rc('font', family='sans')
    plt.rc('font', family='sans-serif')
    # plt.rc('font', family='serif')
    if True:
    # if False:
        plt.rcParams['text.latex.preamble'] = [
            # r'\usepackage{siunitx}',   # i need upright \micro symbols, but you need...
            # r'\sisetup{detect-all}',   # ...this to force siunitx to actually use your fonts
            # r'\usepackage{helvet}',    # set the normal font here
            r'\usepackage{libertine}',    # set the normal font here

            r'\usepackage[libertine]{newtxmath}',
            # r'\usepackage{sfmath}',
            r'\usepackage[T1]{fontenc}',

            r'\usepackage{sansmath}',  # load up the sansmath so that math -> helvet
            # r'\sansmath'
        ]
        # plt.rc('font', family='sans-serif')
    plt.rcParams['font.size'] = 13
    plt.rcParams['axes.linewidth'] = 0.5
    plt.rcParams['lines.linewidth'] = 0.5


import os

from scipy.io import loadmat
from scipy.io import savemat


s_now = time.strftime("%Y%m%d")
al = 0


infile = os.path.join(os.path.dirname(__file__), 'deck_vertices.mat')
indict = loadmat(infile)
x = indict['x'].tolist()
id_c1 = [1,2,3,11,18,20,19,17,16,15,14,13,12,10,9,8,7,6,5,4,1]
id_c0 = id_c1[-1::-1]
xs = np.array([[x[0][ii-1],x[1][ii-1]] for ii in id_c0])
xs = xs.T

lam_L = 80

dx = [max(xs[0])-min(xs[0]),max(xs[1])-min(xs[1])]
x0 = [(max(xs[0])+min(xs[0]))/2,(max(xs[1])+min(xs[1]))/2]

xs0 = xs
xs = np.array([(xi - x0)/lam_L for xi in xs0.T]).T

# al = angle_p[id_angle]*np.pi/180
G_al = np.array( [ [np.cos(al),-np.sin(al)], [np.sin(al),np.cos(al)] ] )
xs_al = np.array([ np.dot(G_al, [xs[0][i],xs[1][i]]) for i in range(np.shape(xs)[1])])
xs = xs_al.T

# if not id_pl:
if id_pl:
# if True:
    plt.plot(xs[0], xs[1], color=[0,0,.5], )
    if True:
    # if False:
        h = plt.plot(xs[0][0], xs[1][0], color=[0,0,.5],
            marker='o',fillstyle='none', \
            markersize=4, \
            # ,markerfacecolor=[0,0,.5], \
            )
        h1 = plt.plot(xs[0][1], xs[1][1], color=[0,0,.5],
            marker='s',fillstyle='none', \
            markersize=4, \
            # ,markerfacecolor=[0,0,.5], \
            )

    plt.xlabel(r'Across the bridge [m]')
    plt.ylabel(r'Vertical [m]')
    # Make room for the ridiculously large title.
    # plt.subplots_adjust(top=0.8)
    plt.axis('equal')
    plt.title('$\int_0^\infty \alpha$ across bridge')
    plt.grid()
    # plt.savefig('cfd_deck_%s.pdf'%s_angle)

# plt.plot([1,2,3])
    plt.show()
