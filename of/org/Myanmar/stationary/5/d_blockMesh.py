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
if False:
# if True:
    # reset
    id_pl = True
    # id_pl = False

    import numpy as np
    import time
    import matplotlib.pyplot as plt
    plt.rc('text', usetex=True)
    # plt.rc('font', family='serif')
    plt.rcParams['text.latex.preamble'] = [
        # r'\usepackage{siunitx}',   # i need upright \micro symbols, but you need...
        # r'\sisetup{detect-all}',   # ...this to force siunitx to actually use your fonts
        # r'\usepackage{helvet}',    # set the normal font here
        r'\usepackage{libertine}',    # set the normal font here

        r'\usepackage[libertine]{newtxmath}',
        r'\usepackage{sfmath}',
        r'\usepackage[T1]{fontenc}',

        # r'\usepackage{sansmath}',  # load up the sansmath so that math -> helvet
        # r'\sansmath'
    ]
    # plt.rcParams['font.size'] = 13
    plt.rcParams['axes.linewidth'] = 0.5
    plt.rcParams['lines.linewidth'] = 0.5

    import os

    from scipy.io import loadmat
    from scipy.io import savemat

    s_now = time.strftime("%Y%m%d")
    al = 0
    s_angle = '00'
else:
    pass

#
#   FILE I/O
#
# s_now = time.strftime("%Y%m%d_%H%M%S")
# s_now = time.strftime("%Y%m%d")
# print(s_now)

fileName = 'd_blockMesh_' + s_now + '.log'
f_bl = open(fileName, 'w')
f_bl.write('#\n')
f_bl.write('#   d_openFoam\n')
f_bl.write('#   Author: Saang Bum Kim, sbkim1601@gmail.com\n')
f_bl.write('#   Date  : 2017-08-25T16:55:40+09:00\n')
f_bl.write('#\n')


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

# al = angle_p[id_angle]*np.pi/180
G_al = np.array( [ [np.cos(al),-np.sin(al)], [np.sin(al),np.cos(al)] ] )
xs_al = np.array([ np.dot(G_al, [xs[0][i],xs[1][i]]) for i in range(np.shape(xs)[1])])
xs = xs_al.T

# if not id_pl:
if id_pl:
# if True:
    plt.cla()
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
    plt.savefig('cfd_deck_%s.pdf'%s_angle)

    h[0].remove()
    h1[0].remove()

    # plt.show()

#
#   Wind tunnel
#
wtt_x = [6,1.5*2]
# wtt_x = [1,1]
wtt_xy = [ \
    [wtt_x[0]*1.5/6*-1,wtt_x[0]*4.5/6,wtt_x[0]*4.5/6,wtt_x[0]*1.5/6*-1,wtt_x[0]*1.5/6*-1], \
    # [wtt_x[0]/2*-1,wtt_x[0]/2,wtt_x[0]/2,wtt_x[0]/2*-1,wtt_x[0]/2*-1], \
    [wtt_x[1]/2*-1,wtt_x[1]/2*-1,wtt_x[1]/2,wtt_x[1]/2,wtt_x[1]/2*-1]
    ]

#
#   Boundary layer
#
bd_x = [
    [-dx[0]*2/2/lam_L  , dx[0]*2/2/lam_L*2,dx[0]*2/2/lam_L*2,-dx[0]*2/2/lam_L  ,-dx[0]*2/2/lam_L  ],
    [-dx[1]*5/2/lam_L*2,-dx[1]*5/2/lam_L*2,dx[1]*5/2/lam_L*2, dx[1]*5/2/lam_L*2,-dx[1]*5/2/lam_L*2]
    ]
# G_al = np.array( [ [np.cos(al),-np.sin(al)], [np.sin(al),np.cos(al)] ] )
bd_al = np.array([ np.dot(G_al, [bd_x[0][i],bd_x[1][i]]) for i in range(np.shape(bd_x)[1])])
bd_x = bd_al.T

if id_pl:
    plt.plot(wtt_xy[0],wtt_xy[1], color=[0,0,0.5])
    plt.plot(bd_x[0],bd_x[1], color=[0,0,0.5])
    plt.savefig('cfd_deck_wtt_%s.pdf'%s_angle)
    # plt.show()

#
#   openFoam vertices
#
of_xy = [
    np.hstack([ \
        wtt_xy[0][0],bd_x[0][0],xs[0][0:2],xs[0][3:5],xs[0][6:9],xs[0][10:12],xs[0][13:15],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][0:2],xs[0][3:5],xs[0][6:9],xs[0][10:12],xs[0][13:15],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][0:2],xs[0][3:5],xs[0][6:9],xs[0][10:12],xs[0][13:15],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][0:3],xs[0][5:10],xs[0][12:15],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][19:14:-1],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][19:14:-1],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][19:14:-1],bd_x[0][1],wtt_xy[0][1], \
        ]),
    np.hstack([ \
        [wtt_xy[1][0]]*15, \
        [bd_x[1][0]]*15, \
        [xs[1][3]]*5, [xs[1][4]]*2, (xs[1][4]+xs[1][10])/2, [xs[1][10]]*2, [xs[1][11]]*5, \
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
    # np.r_[np.zeros(of_nv),np.ones(of_nv)], \
    np.r_[np.ones(of_nv)*-0.5,np.ones(of_nv)*0.5], \
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
print('dx_min: %f'%dx_min)


n_amp = 4
r_g = 1.1

of_br = np.zeros([np.shape(of_block)[0],5])
n_g0 = np.zeros(np.shape(of_block)[0])
n_g1 = np.zeros(np.shape(of_block)[0])
R_g0 = np.zeros(np.shape(of_block)[0])
R_g1 = np.zeros(np.shape(of_block)[0])
for i in range(np.shape(of_block)[0]):
    ix = of_block[i][[1,2]]
    ix1 = of_block[i][[0,3]]
    xi = np.abs(of_xyz[0][ix] - of_xyz[0][ix1])
    ix = of_block[i][[3,2]]
    ix1 = of_block[i][[0,1]]
    yi = np.abs(of_xyz[1][ix] - of_xyz[1][ix1])
    of_br[i,] = np.maximum(np.r_[xi,yi,1]/dx_min*n_amp,[1,1,1,1,1])

    n_g0[i] = np.log(of_br[i,0]*(r_g-1)+1) / np.log(r_g)
    R_g0[i] = r_g**(n_g0[i]-1)

    n_g1[i] = np.log(of_br[i,2]*(r_g-1)+1) / np.log(r_g)
    R_g1[i] = r_g**(n_g1[i]-1)


# for i in range(np.shape(of_br)[0]):
    # print('%d: %s '%(i, ' '.join( str(int(of_br[i,jj])) for jj in range(5))))

if id_pl:
    # if False:
    if True:
        dx_min0 = np.array([np.abs(of_xy[0][i+1]-of_xy[0][i]) for i in range(len(of_xy[0])-1)])
        # print(np.shape(dx_min))
        id_dx_min = np.argsort(dx_min0,axis=0)
        # print(dx_min[id_dx_min])
        # print(dx_min[id_dx_min[1:5]])
        # print(dx_min[id_dx_min[-1:-5:-1]])
        dx_min1 = dx_min0[id_dx_min[0]]
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

        plt.savefig('cfd_deck_ofm_%s.pdf'%s_angle)
        # plt.show()


if True:
    # fileName = 'blockMeshDict_' + s_now + '.foam'
    fileName = 'system/blockMeshDict'
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
    f.write('            points[i+sz] = point(pt.x(), pt.y(), -pt.z());\n')
    # f.write('            points[i+sz] = point(pt.x(), pt.y(), 1);\n')
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

    gam_ii_jj = [i for i in range(59)]
    # print(gam_ii_jj[27])

    gam_ii_jj[53] = 1
    gam_ii_jj[54] = 46
    gam_ii_jj[55] = 47
    gam_ii_jj[56] = 48
    gam_ii_jj[57] = 49
    gam_ii_jj[58] = 12

    gam_ii_jj[14] = 27
    gam_ii_jj[28] = 39
    gam_ii_jj[40] = 43
    gam_ii_jj[44] = 51

    for ii in range(15,27):
        gam_ii_jj[ii] = ii - 14

    for ii in range(np.shape(of_block)[0]):
        if (ii == 0):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[0], n_g1[13], 1/R_g0[ii], 1/R_g1[ii] ) )
        elif (ii == 13):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                # (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[ii], n_g1[ii], R_g0[ii], 1/R_g1[ii] ) )
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[13], n_g1[13], R_g0[ii], 1/R_g1[ii] ) )
        elif (ii == 52):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[0], n_g1[59], 1/R_g0[ii], R_g1[ii] ) )
        elif (ii == 59):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[13], n_g1[59], R_g0[ii], R_g1[ii] ) )
        elif ((ii > 0) and (ii < 13)):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), of_br[ii,0], n_g1[13], 1, 1/R_g1[ii] ) )
        elif ((ii > 52) and (ii < 59)):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), of_br[gam_ii_jj[ii],0], n_g1[59], 1, R_g1[ii] ) )
        elif (ii == 14) or (ii == 28) or (ii == 40) or (ii == 44):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[0], of_br[gam_ii_jj[ii],2], 1/R_g0[ii], 1 ) )
        elif (ii == 27) or (ii == 39) or (ii == 43) or (ii == 51):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[13], of_br[ii,2], R_g0[ii], 1 ) )
        elif ((ii > 14) and (ii < 27)):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), of_br[gam_ii_jj[ii],0], of_br[27,2]) )
        elif ((ii > 28) and (ii < 32)):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), of_br[ii-28,0], of_br[39,2]) )
        elif ((ii > 31) and (ii < 36)):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), of_br[ii-27,0], of_br[39,2]) )
        elif ((ii > 35) and (ii < 39)):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), of_br[ii-26,0], of_br[39,2]) )
        elif (ii == 41):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), of_br[1,0], of_br[43,2]) )
        elif (ii == 45):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), of_br[1,0], of_br[51,2]) )
        elif (ii == 53):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), of_br[1,0], of_br[59,2]) )
        elif (ii == 42):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), of_br[12,0], of_br[43,2]) )
        elif (ii == 50):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), of_br[12,0], of_br[51,2]) )
        elif (ii == 58):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), of_br[12,0], of_br[59,2]) )
        elif ((ii > 45) and (ii < 50)):
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), of_br[ii+8,0], of_br[51,2]) )
        else:
            f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), of_br[ii,0], of_br[ii,2] ) )
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
    f.write('        type wall;\n')
    # f.write('        type symmetry;\n')
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
#   controlDict
#

BD = [x/lam_L for x in dx]
f_bl.write('\nB & D: ' + ' m, '.join([ '%.3g'%x for x in BD ]) + ' m')

# nu = 1e-5
nu = 2.564103e-03
f_bl.write('\nnu: %f'%nu)

f_bl.write('\n')
# Re 195
Re = 195
f_bl.write('\nRe: %f'%Re)
U_mu = [Re * nu / x for x in BD]
f_bl.write('\nU_mu: ' + ' m/s, '.join([ '%.3g'%x for x in U_mu ]) + ' m/s')
U_F = [x / lam_L for x in U_mu]
f_bl.write('\nU_F: ' + ' m/s, '.join([ '%.3g'%x for x in U_F ]) + ' m/s')

f_bl.write('\n')
# U_M 10
U_mu = 10
Re = [x * U_mu / nu for x in BD]
f_bl.write('\nRe: ' + ' '.join(['%.3e'%x for x in Re]))
f_bl.write('\nU_mu: %f m/s'%U_mu)
U_F = U_mu / lam_L
f_bl.write('\nU_F: %f m/s'%U_F)

f_bl.write('\n')
# U_F 100
U_F = 100
U_mu = U_F * lam_L
Re = [x * U_mu / nu for x in BD]
f_bl.write('\nRe: ' + ' '.join(['%.3e'%x for x in Re]))
f_bl.write('\nU_mu: %f m/s'%U_mu)
f_bl.write('\nU_F: %f m/s'%U_F)

#
#   Turbulence
#
f_bl.write('\n')
f_bl.write('\n#   Turbulence')
f_bl.write('\n')

C_mu = 0.09
C1 = 1.44
C2 = 1.92
alpha_K = 1
alpha_epsilon = 0.76923

I_u = np.array([5.,5.,5.])*1e-2
f_bl.write('\nTurbulence intensity: %s'%' '.join([ str(x) for x in I_u ]))

L_u = [x * 7e-2 for x in BD]
f_bl.write('\nTurbulence length scale [m]: %s'%' '.join([ '%f'%x for x in L_u ]))

for U_mu in [5,10,8000]:

    f_bl.write('\n')
    f_bl.write('\nU_mu: %f m/s'%U_mu)

    sig_U = U_mu * I_u
    f_bl.write('\nsig_U [m/s]: %s'%' '.join([ str(x) for x in sig_U ]))

    k = 1/2*sum(sig_U**2)
    f_bl.write('\nk: %f'%k)

    epsilon = [C_mu**0.75 * k**1.5 / x for x in L_u]
    f_bl.write('\nepsilon: ' + ' '.join('%f'%x for x in epsilon))

    omega = [C_mu**-0.25 * k**0.5 / x for x in L_u]
    f_bl.write('\nomega: ' + ' '.join('%f'%x for x in omega))

    nu_t = [np.sqrt(3/2)*sig_U[0]*x for x in L_u]
    f_bl.write('\nnu_t: ' + ' '.join('%f'%x for x in nu_t))

    nu_t = [C_mu**0.25 * np.sqrt(3/2)*sig_U[0]*x for x in L_u]
    f_bl.write('\nnu_t: ' + ' '.join('%f'%x for x in nu_t))

    nu_tilda = [5*x for x in nu_t]
    f_bl.write('\nnu_tilda: ' + ' '.join('%f'%x for x in nu_tilda))

    d_t = dx_min/U_mu
    f_bl.write('\nd_t [s]: %g'%d_t)

    T_f = [x / U_mu for x in BD]
    f_bl.write('\nT_f [s]: ' + ' '.join('%f'%x for x in T_f))

    n_int = T_f/d_t / 10
    f_bl.write('\nn_int: ' + ' '.join('%d'%x for x in n_int))

    T_vor = [x / 0.2 / U_mu for x in BD]
    f_bl.write('\nT_vor [s]: ' + ' '.join(['%.3e'%x for x in T_vor]))

    n_vor = T_vor/d_t
    f_bl.write('\nn_vor: ' + ' '.join('%d'%x for x in n_vor))


# import air

f_bl.write('\n')
f_bl.write('\n#')
f_bl.write('\n#   FINE')
f_bl.write('\n#')
f_bl.close()

#
#   FINE
#
