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

lam_L = 80

dx = [max(xs[0])-min(xs[0]),max(xs[1])-min(xs[1])]
x0 = [(max(xs[0])+min(xs[0]))/2,(max(xs[1])+min(xs[1]))/2]

xs0 = xs
xs = np.array([(xi - x0)/lam_L for xi in xs0.T]).T

# if not id_pl:
if id_pl:
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
    plt.grid()
    plt.savefig('cfd_deck.pdf')

    h[0].remove()
    h1[0].remove()

    plt.show()

#
#   Wind tunnel
#
# wtt_x = [6,1.5*2]
wtt_x = [1,1]
wtt_xy = [ \
    # [wtt_x[0]*1.5/6*-1,wtt_x[0]*4.5/6,wtt_x[0]*4.5/6,wtt_x[0]*1.5/6*-1,wtt_x[0]*1.5/6*-1], \
    [wtt_x[0]/2*-1,wtt_x[0]/2,wtt_x[0]/2,wtt_x[0]/2*-1,wtt_x[0]/2*-1], \
    [wtt_x[1]/2*-1,wtt_x[1]/2*-1,wtt_x[1]/2,wtt_x[1]/2,wtt_x[1]/2*-1]
    ]

#
#   Boundary layer
#
bd_x = [
    [-dx[0]*2/2/lam_L,dx[0]*2/2/lam_L,dx[0]*2/2/lam_L,-dx[0]*2/2/lam_L,-dx[0]*2/2/lam_L],
    [-dx[1]*5/2/lam_L,-dx[1]*5/2/lam_L,dx[1]*5/2/lam_L,dx[1]*5/2/lam_L,-dx[1]*5/2/lam_L]
    ]

if id_pl:
    plt.plot(wtt_xy[0],wtt_xy[1], color=[0,0,0.5])
    plt.plot(bd_x[0],bd_x[1], color=[0,0,0.5])
    plt.savefig('cfd_deck_wtt.pdf')
    # plt.show()

#
#   openFoam vertices
#
of_xy = [
    np.hstack([wtt_xy[0][0],bd_x[0][0],xs[0][0:2],xs[0][3:5],xs[0][6:9],xs[0][10:12],xs[0][13:15],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][0:2],xs[0][3:5],xs[0][6:9],xs[0][10:12],xs[0][13:15],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][0:2],xs[0][3:5],xs[0][6:9],xs[0][10:12],xs[0][13:15],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][0:3],xs[0][5:10],xs[0][12:15],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][19:14:-1],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][19:14:-1],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][19:14:-1],bd_x[0][1],wtt_xy[0][1], \
        ]),
    np.hstack([[wtt_xy[1][0]]*15, \
        [bd_x[1][0]]*15, \
        [xs[1][3]]*5, [xs[1][4]]*4, xs[1][10], [xs[1][11]]*5, \
        [xs[1][0]]*3, xs[1][1:3], xs[1][5:10], xs[1][12:15], [xs[1][14]]*2, \
        [xs[1][19]]*3, xs[1][18:14:-1], [xs[1][15]]*2, \
        [bd_x[1][2]]*9, \
        [wtt_xy[1][2]]*9, \
        ]),
]
# (imsi,of_nv) = np.shape(of_xy)[1]
# print((imsi,of_nv))
of_nv = np.shape(of_xy)[1]
# print(of_nv)

of_xyz = [
    np.r_[of_xy[0],of_xy[0]], \
    np.r_[of_xy[1],of_xy[1]], \
    np.r_[np.zeros(of_nv),np.ones(of_nv)], \
    ]
# print(of_xyz)

def pr_of_face(of_face):
    print(np.array([np.r_[i,of_face[i]] for i in range(np.shape(of_face)[0])]))

of_face_front = np.r_[ \
    [[0 +i, 1 +i, 16+i, 15+i] for i in range(14)], \
    [[15+i, 16+i, 31+i, 30+i] for i in range(14)], \
    [[30+i, 31+i, 46+i, 45+i] for i in range(4 )], \
    [[35+i, 36+i, 51+i, 50+i] for i in range(4 )], \
    [[40+i, 41+i, 56+i, 55+i] for i in range(4 )], \
    [[45+i, 46+i, 61+i, 60+i] for i in range(2 )], \
    [[57+i, 58+i, 67+i, 66+i] for i in range(2 )], \
    [[60+i, 61+i, 70+i, 69+i] for i in range(8 )], \
    [[69+i, 70+i, 79+i, 78+i] for i in range(8 )], \
    ]
of_face_front = [i[-1::-1] for i in of_face_front]
# print(np.array([np.r_[i,of_face_front[i]] for i in range(np.shape(of_face_front)[0])]))
of_face_back = [i[-1::-1]+87 for i in of_face_front]
# print(np.array([np.r_[i+60,of_face_back[i]] for i in range(np.shape(of_face_back)[0])]))
of_face_top = \
    [[78+i, 79+i, 166+i, 165+i][-1::-1] for i in range(8)]
# pr_of_face(of_face_top)
of_face_bottom = \
    [[88+i, 87+i, 0+i, 1+i] for i in range(14)]
# pr_of_face(of_face_bottom)
of_face_inlet = [ \
    [87,102,15,0],
    [102,117,30,15],
    [117,132,45,30],
    [132,147,60,45],
    [147,156,69,60],
    [156,165,78,69]
    ]
# pr_of_face(of_face_inlet)
of_face_outlet = [ \
    [14,29,116,101],
    [29,44,131,116],
    [44,59,146,131],
    [59,68,155,146],
    [68,77,164,155],
    [77,86,173,164]
    ]
# pr_of_face(of_face_outlet)
of_face_deck = [ \
    [134,135,48,47],
    [135,136,49,48],
    [136,121,34,49],
    [121,122,35,34],
    [122,137,50,35],
    [137,138,51,50],
    [138,139,52,51],
    [139,140,53,52],
    [140,141,54,53],
    [141,126,39,54],
    [126,127,40,39],
    [127,142,55,40],
    [142,143,56,55],
    [143,144,57,56],
    [144,153,66,57],
    [153,152,65,66],
    [152,151,64,65],
    [151,150,63,64],
    [150,149,62,63],
    [149,134,47,62],
    ]
# pr_of_face(of_face_deck)
of_face = np.r_[
    of_face_front,
    of_face_back,
    of_face_top,
    of_face_bottom,
    of_face_inlet,
    of_face_outlet,
    of_face_deck
    ]
# pr_of_face(of_face)


of_block = np.r_[ \
    [[0 +i, 1 +i, 16+i, 15+i, 0 +i+87, 1 +i+87, 16+i+87, 15+i+87] for i in range(14)], \
    [[15+i, 16+i, 31+i, 30+i, 15+i+87, 16+i+87, 31+i+87, 30+i+87] for i in range(14)], \
    [[30+i, 31+i, 46+i, 45+i, 30+i+87, 31+i+87, 46+i+87, 45+i+87] for i in range(4 )], \
    [[35+i, 36+i, 51+i, 50+i, 35+i+87, 36+i+87, 51+i+87, 50+i+87] for i in range(4 )], \
    [[40+i, 41+i, 56+i, 55+i, 40+i+87, 41+i+87, 56+i+87, 55+i+87] for i in range(4 )], \
    [[45+i, 46+i, 61+i, 60+i, 45+i+87, 46+i+87, 61+i+87, 60+i+87] for i in range(2 )], \
    [[57+i, 58+i, 67+i, 66+i, 57+i+87, 58+i+87, 67+i+87, 66+i+87] for i in range(2 )], \
    [[60+i, 61+i, 70+i, 69+i, 60+i+87, 61+i+87, 70+i+87, 69+i+87] for i in range(8 )], \
    [[69+i, 70+i, 79+i, 78+i, 69+i+87, 70+i+87, 79+i+87, 78+i+87] for i in range(8 )], \
    ]
# pr_of_face(of_block)

dx_min = 1e3
for i in range(np.shape(of_block)[0]):
    # i = 0
    # ix = np.r_[of_block[i][0:4],of_block[i][0]]
    # ix1 = np.r_[of_block[i][1:4],of_block[i][0]]
    ix = of_block[i][[1,2]]
    ix1 = of_block[i][[0,3]]
    xi = np.abs(of_xyz[0][ix] - of_xyz[0][ix1])
    ix = of_block[i][[3,2]]
    ix1 = of_block[i][[0,1]]
    yi = np.abs(of_xyz[1][ix] - of_xyz[1][ix1])
    dx_min = min(np.r_[xi[xi != 0],yi[yi != 0],dx_min])
    # print(min(xi[xi != 0]))
    # print(min(yi[yi != 0]))
# print(dx_min)

of_br = np.zeros([np.shape(of_block)[0],5])
for i in range(np.shape(of_block)[0]):
    ix = of_block[i][[1,2]]
    ix1 = of_block[i][[0,3]]
    xi = np.abs(of_xyz[0][ix] - of_xyz[0][ix1])
    ix = of_block[i][[3,2]]
    ix1 = of_block[i][[0,1]]
    yi = np.abs(of_xyz[1][ix] - of_xyz[1][ix1])
    of_br[i,] = np.r_[xi,yi,1]/dx_min

# for i in range(np.shape(of_br)[0]):
    # print('%d: %s '%(i, ' '.join( str(int(of_br[i,jj])) for jj in range(5))))

if False:
    dx_min = np.array([np.abs(of_xy[0][i+1]-of_xy[0][i]) for i in range(len(of_xy[0])-1)])
    # print(np.shape(dx_min))
    id_dx_min = np.argsort(dx_min,axis=0)
    # print(dx_min[id_dx_min])
    # print(dx_min[id_dx_min[1:5]])
    # print(dx_min[id_dx_min[-1:-5:-1]])
    dx_min1 = dx_min[id_dx_min[0]]
    print(dx_min1)
    # dx_min = np.array([np.abs(of_xy[1][i+1]-of_xy[1][i]) for i in range(len(of_xy[1])-1)])
    # dx_min_n = dx_min[dx_min != 0]
    # id_dx_min = np.argsort(dx_min_n,axis=0)
    # dx_min2 = dx_min_n[id_dx_min[0:15]]
    # print(dx_min2)

    if id_pl:
        print(of_xy)
        plt.plot(of_xy[0],of_xy[1],color=[0,0.5,0],\
                marker='o',fillstyle='none', \
                markersize=3, \
                # ,markerfacecolor=[0,0,.5], \
                )

        plt.savefig('cfd_deck_ofm.pdf')
        plt.show()


if True:
    #
    #   FILE I/O
    #
    # s_now = time.strftime("%Y%m%d_%H%M%S")
    s_now = time.strftime("%Y%m%d")

    print(s_now)

    fileName = 'blockMeshDict_' + s_now + '.foam'
    f = open(fileName, 'w')

    f.write('/*--------------------------------*- C++ -*----------------------------------*\\\n')
    f.write('| =========                 |                                                 |\n')
    f.write('| \\\\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |\n')
    f.write('|  \\\\    /   O peration     | Version:  5                                     |\n')
    f.write('|   \\\\  /    A nd           | Web:      www.OpenFOAM.org                      |\n')
    f.write('|    \\\\/     M anipulation  |                                                 |\n')
    f.write('\*---------------------------------------------------------------------------*/\n')
    f.write('FoamFile\n')
    f.write('{\n')
    f.write('    version     2.0;\n')
    f.write('    format      ascii;\n')
    f.write('    class       dictionary;\n')
    f.write('    object      blockMeshDict;\n')
    f.write('}\n')
    f.write('// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //\n')
    f.write('\n')
    f.write('convertToMeters 1;\n')
    f.write('\n')
    # f.write('vertices\n')
    f.write('vertices #codeStream\n')
    # f.write('(\n')
    f.write('{\n')
    f.write('    codeInclude\n')
    f.write('    #{\n')
    f.write('        #include "pointField.H"\n')
    f.write('    #};\n')
    f.write('\n')
    f.write('    code\n')
    f.write('    #{\n')
    f.write('        pointField points(%d);\n'%int(np.shape(of_xyz)[1]/2))
    # for ii in range(len(of_xyz[0])):
    for ii in range(int(np.shape(of_xyz)[1]/2)):
        f.write('        points[%d] = point(%f, %f, %f);\n'%(ii,of_xyz[0][ii],of_xyz[1][ii],of_xyz[2][ii]))
    f.write('\n')
    f.write('        // Duplicate z points\n')
    f.write('        label sz = points.size();\n')
    f.write('        points.setSize(2*sz);\n')
    f.write('        for (label i = 0; i < sz; i++)\n')
    f.write('        {\n')
    f.write('            const point& pt = points[i];\n')
    # f.write('            points[i+sz] = point(pt.x(), pt.y(), -pt.z());\n')
    f.write('            points[i+sz] = point(pt.x(), pt.y(), 1);\n')
    f.write('        }\n')
    f.write('\n')
    f.write('        os << points;\n')
    f.write('    #};\n')
    f.write('};\n')
    # f.write(');\n')
    f.write('\n')
    f.write('blocks\n')
    f.write('(\n')
    # f.write('    hex (0 1 2 3 4 5 6 7) (20 20 1) simpleGrading (1 1 1)\n')
    for ii in range(np.shape(of_block)[0]):
        f.write('    hex (%s) (%d %d 1) simpleGrading (1 1 1)\n'%(' '.join( str(of_block[ii][jj]) for jj in range(8) ), of_br[ii,0], of_br[ii,2] ) )
        # f.write('    hex (%d %d %d %d %d %d %d %d) (1 1 1) simpleGrading (1 1 1)\n'%of_block[ii])
    f.write(');\n')
    f.write('\n')
    f.write('edges\n')
    f.write('(\n')
    f.write(');\n')
    f.write('\n')
    f.write('boundary\n')
    f.write('(\n')
    f.write('    top\n')
    f.write('    {\n')
    # f.write('        type wall;\n')
    f.write('        type symmetryPlane;\n')
    f.write('        faces\n')
    f.write('        (\n')
    # f.write('            (3 7 6 2)\n')
    for ii in range(np.shape(of_face_top)[0]):
        f.write('            (%s)\n'%(' '.join( str(of_face_top[ii][jj]) for jj in range(4) )) )
    f.write('        );\n')
    f.write('    }\n')
    f.write('    bottom\n')
    f.write('    {\n')
    # f.write('        type wall;\n')
    f.write('        type symmetryPlane;\n')
    f.write('        faces\n')
    f.write('        (\n')
    # f.write('            (1 5 4 0)\n')
    for ii in range(np.shape(of_face_bottom)[0]):
        f.write('            (%s)\n'%(' '.join( str(of_face_bottom[ii][jj]) for jj in range(4) )) )
    f.write('        );\n')
    f.write('    }\n')
    f.write('    inlet\n')
    f.write('    {\n')
    # f.write('        type wall;\n')
    f.write('        type patch;\n')
    f.write('        faces\n')
    f.write('        (\n')
    for ii in range(np.shape(of_face_inlet)[0]):
        f.write('            (%s)\n'%(' '.join( str(of_face_inlet[ii][jj]) for jj in range(4) )) )
    f.write('        );\n')
    f.write('    }\n')
    f.write('    outlet\n')
    f.write('    {\n')
    # f.write('        type wall;\n')
    f.write('        type patch;\n')
    f.write('        faces\n')
    f.write('        (\n')
    for ii in range(np.shape(of_face_outlet)[0]):
        f.write('            (%s)\n'%(' '.join( str(of_face_outlet[ii][jj]) for jj in range(4) )) )
    f.write('        );\n')
    f.write('    }\n')
    f.write('    deck\n')
    f.write('    {\n')
    # f.write('        type wall;\n')
    f.write('        type symmetry;\n')
    f.write('        faces\n')
    f.write('        (\n')
    for ii in range(np.shape(of_face_deck)[0]):
        f.write('            (%s)\n'%(' '.join( str(of_face_deck[ii][jj]) for jj in range(4) )) )
    f.write('        );\n')
    f.write('    }\n')
    f.write('    frontAndBack\n')
    f.write('    {\n')
    f.write('        type empty;\n')
    f.write('        faces\n')
    f.write('        (\n')
    for ii in range(14):
        id_bl = (0+ii,1+ii,16+ii,15+ii)
        f.write('            (%d %d %d %d)\n'%id_bl[-1::-1])
    for ii in range(14):
        id_bl = (15+ii,16+ii,31+ii,30+ii)
        f.write('            (%d %d %d %d)\n'%id_bl[-1::-1])
    for ii in range(4):
        id_bl = (30+ii,31+ii,46+ii,45+ii)
        f.write('            (%d %d %d %d)\n'%id_bl[-1::-1])
    for ii in range(4):
        id_bl = (35+ii,36+ii,51+ii,50+ii)
        f.write('            (%d %d %d %d)\n'%id_bl[-1::-1])
    for ii in range(4):
        id_bl = (40+ii,41+ii,56+ii,55+ii)
        f.write('            (%d %d %d %d)\n'%id_bl[-1::-1])
    for ii in range(2):
        id_bl = (45+ii,46+ii,61+ii,60+ii)
        f.write('            (%d %d %d %d)\n'%id_bl[-1::-1])
    for ii in range(2):
        id_bl = (57+ii,58+ii,67+ii,66+ii)
        f.write('            (%d %d %d %d)\n'%id_bl[-1::-1])
    for ii in range(8):
        id_bl = (60+ii,61+ii,70+ii,69+ii)
        f.write('            (%d %d %d %d)\n'%id_bl[-1::-1])
    for ii in range(8):
        id_bl = (69+ii,70+ii,79+ii,78+ii)
        f.write('            (%d %d %d %d)\n'%id_bl[-1::-1])

    for ii in range(87,87+14):
        id_bl = (0+ii,1+ii,16+ii,15+ii)
        f.write('            (%d %d %d %d)\n'%id_bl)
    for ii in range(87,87+14):
        id_bl = (15+ii,16+ii,31+ii,30+ii)
        f.write('            (%d %d %d %d)\n'%id_bl)
    for ii in range(87,87+4):
        id_bl = (30+ii,31+ii,46+ii,45+ii)
        f.write('            (%d %d %d %d)\n'%id_bl)
    for ii in range(87,87+4):
        id_bl = (35+ii,36+ii,51+ii,50+ii)
        f.write('            (%d %d %d %d)\n'%id_bl)
    for ii in range(87,87+4):
        id_bl = (40+ii,41+ii,56+ii,55+ii)
        f.write('            (%d %d %d %d)\n'%id_bl)
    for ii in range(87,87+2):
        id_bl = (45+ii,46+ii,61+ii,60+ii)
        f.write('            (%d %d %d %d)\n'%id_bl)
    for ii in range(87,87+2):
        id_bl = (57+ii,58+ii,67+ii,66+ii)
        f.write('            (%d %d %d %d)\n'%id_bl)
    for ii in range(87,87+8):
        id_bl = (60+ii,61+ii,70+ii,69+ii)
        f.write('            (%d %d %d %d)\n'%id_bl)
    for ii in range(87,87+8):
        id_bl = (69+ii,70+ii,79+ii,78+ii)
        f.write('            (%d %d %d %d)\n'%id_bl)

    f.write('        );\n')
    f.write('    }\n')
    f.write(');\n')
    f.write('\n')
    f.write('mergePatchPairs\n')
    f.write('(\n')
    f.write(');\n')
    f.write('\n')
    f.write('// ************************************************************************* //\n')

    f.close()


#
#   FINE
#