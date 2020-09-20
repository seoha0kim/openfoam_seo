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
import shutil
exec(open("d_pre.py").read(), globals())

id_pl = True
# id_pl = False

# if False:
# if True:
if __name__ == '__main__':
    #
    #   FILE I/O
    #
    # s_now = time.strftime("%Y%m%d_%H%M%S")
    s_now = time.strftime("%Y%m%d")
    # print(s_now)

    s_angle_p = ['00','02','m2','04','m4','06','m6']
    angle_p   = [  0 ,  2 , -2 ,  4 , -4 ,  6 , -6]
    # s_angle_p = ['02','m2','04','m4','06','m6']
    # angle_p = [2,-2,4,-4,6,-6]

    id_angle = 5

else:
    pass


#
#   FILE I/O
#
fileName = 'd_blockMesh_' + s_now + '.log'
f_bl = open(fileName, 'w')
f_bl.write('#\n')
f_bl.write('#   d_openFoam\n')
f_bl.write('#   Author: Saang Bum Kim, sbkim1601@gmail.com\n')
f_bl.write('#   Date  : 2017-08-25T16:55:40+09:00\n')
f_bl.write('#\n')

al = -angle_p[id_angle]*np.pi/180
print('\nAngle of attack: %d'%(al*180/np.pi))
f_bl.write('\nAngle of attack: %d'%(al*180/np.pi))
s_angle = s_angle_p[id_angle]
# print('Angle of attack: %s'%s_angle)


#
#   PART II.    Vertices
#

#
#   Deck
#
infile = os.path.join(os.path.dirname(__file__), 'deck_vertices.mat')
indict = loadmat(infile)
x = indict['x'].tolist()
# id_c1 = [1,2,3,11,18,20,19,17,16,15,14,13,12,10,9,8,7,6,5,4,1]
id_c1 = [1,3,4,5,6,7,12,8,10,14,19,21,17,22,23,24,25,26,27,28,15,2,1]
# id_c0 = id_c1[-1::-1]
id_c0 = id_c1
xs = np.array([[x[0][ii-1],x[1][ii-1]] for ii in id_c0])
xs = xs.T

lam_L = 80/1000

dx = [max(xs[0])-min(xs[0]),max(xs[1])-min(xs[1])]
x0 = [(max(xs[0])+min(xs[0]))/2,(max(xs[1])+min(xs[1]))/2]

xs_old = xs
xs = np.array([(xi - x0)/lam_L for xi in xs_old.T]).T
dx_old = dx
dx = [max(xs[0])-min(xs[0]),max(xs[1])-min(xs[1])]

# al = angle_p[id_angle]*np.pi/180
# G_al = np.array( [ [np.cos(al),-np.sin(al)], [np.sin(al),np.cos(al)] ] )
# xs_al = np.array([ np.dot(G_al, [xs[0][i],xs[1][i]]) for i in range(np.shape(xs)[1])])
# xs = xs_al.T
# xs = xs.T

# if not id_pl:
# if id_pl:
# if True:
if False:
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

    plt.show()


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
# bd_al = np.array([ np.dot(G_al, [bd_x[0][i],bd_x[1][i]]) for i in range(np.shape(bd_x)[1])])
# bd_x = bd_al.T

# if id_pl:
if False:
    plt.plot(wtt_xy[0],wtt_xy[1], color=[0,0,0.5])
    plt.plot(bd_x[0],bd_x[1], color=[0,0,0.5])
    plt.savefig('cfd_deck_wtt_%s.pdf'%s_angle)
    plt.show()


#
#   openFoam vertices
#
of_xy = [
    np.hstack([ \
        wtt_xy[0][0],bd_x[0][0],xs[0][0:5],xs[0][7:12],xs[0][14:19],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][0:5],xs[0][7:12],xs[0][14:19],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][0:5],xs[0][7:12],xs[0][14:19],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][0:5], xs[0][6], xs[0][12], xs[0][14:19],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][0:5], xs[0][5], xs[0][13], xs[0][14:19],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0], xs[0][21:18:-1], bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0], xs[0][21:18:-1], bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0], xs[0][21:18:-1], bd_x[0][1],wtt_xy[0][1], \
        ]),
    np.hstack([ \
        [wtt_xy[1][0]]*19, \
        [bd_x[1][0]]*19, \
        [xs[1][7]]*8, xs[1][8:11],  [xs[1][11]]*8, \
        [xs[1][6]]*8,               [xs[1][12]]*8, \
        [xs[1][0]]*3, xs[1][1:6], xs[1][13:19], [xs[1][18]]*2, \
        [xs[1][21]]*3, xs[1][20:18:-1], [xs[1][19]]*2, \
        [bd_x[1][2]]*7, \
        [wtt_xy[1][2]]*7, \
        ]),
]

G_al = np.array( [ [np.cos(al),-np.sin(al)], [np.sin(al),np.cos(al)] ] )
for i in np.hstack((range(20,37),range(39,56),range(58,72),range(74,88),range(90,95),range(97,102))):
    of_xy[0][i],of_xy[1][i] = np.dot(G_al, [of_xy[0][i],of_xy[1][i]])

if id_pl:
    plt.cla()
    plt.plot(of_xy[0],of_xy[1], color=[0,0,0.5])
    # plt.savefig('cfd_deck_wtt_%s.pdf'%s_angle)
    plt.show()


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
    [[0 +i, 1 +i, 20+i, 19+i] for i in range(18)], \
    [[19+i, 20+i, 39+i, 38+i] for i in range(18)], \
    [[38+i, 39+i, 58+i, 57+i] for i in range(7 )], \
    [[49+i, 50+i, 66+i, 65+i] for i in range(7 )], \
    [[57+i, 58+i, 74+i, 73+i] for i in range(7 )], \
    [[65+i, 66+i, 82+i, 81+i] for i in range(7 )], \
    [[73+i, 74+i, 90+i, 89+i] for i in range(2 )], \
    [[86+i, 87+i, 94+i, 93+i] for i in range(2 )], \
    [[89+i, 90+i, 97+i, 96+i] for i in range(6 )], \
    [[96+i, 97+i, 104+i, 103+i] for i in range(6 )], \
    ]
of_face_front = [i[-1::-1] for i in of_face_front]
# print(np.array([np.r_[i,of_face_front[i]] for i in range(np.shape(of_face_front)[0])]))
of_face_back = [i[-1::-1]+110 for i in of_face_front]
# of_face_back = [i+110 for i in of_face_front]
# print(np.array([np.r_[i+60,of_face_back[i]] for i in range(np.shape(of_face_back)[0])]))
of_face_top = \
    [[103+i, 104+i, 104+110+i, 103+110+i][-1::-1] for i in range(6)]
# pr_of_face(of_face_top)
of_face_bottom = \
    [[0+i, 1+i, 1+110+i, 0+110+i] for i in range(18)]
# pr_of_face(of_face_bottom)
of_face_inlet = [ \
    [0,19,19+110,0+110][-1::-1],
    [19,38,38+110,19+110][-1::-1],
    [38,57,57+110,38+110][-1::-1],
    [57,73,73+110,57+110][-1::-1],
    [73,89,89+110,73+110][-1::-1],
    [89,96,96+110,89+110][-1::-1],
    [96,103,103+110,96+110][-1::-1],
    ]
# pr_of_face(of_face_inlet)
of_face_outlet = [ \
    [18,37,37+110,18+110],
    [37,56,56+110,37+110],
    [56,72,72+110,56+110],
    [72,88,88+110,72+110],
    [88,95,95+110,88+110],
    [95,102,102+110,95+110],
    [102,109,109+110,102+110],
    ]
# pr_of_face(of_face_outlet)
of_face_deck = [ \
    [75,76,76+110,75+110],
    [76,77,77+110,76+110],
    [77,78,78+110,77+110],
    [78,79,79+110,78+110],
    [79,80,80+110,79+110],
    [80,64,64+110,80+110],
    [64,45,45+110,64+110],
    [45,46,46+110,45+110],
    [46,47,47+110,46+110],
    [47,48,48+110,47+110],
    [48,49,49+110,48+110],
    [49,65,65+110,49+110],
    [65,81,81+110,65+110],
    [81,82,82+110,81+110],
    [82,83,83+110,82+110],
    [83,84,84+110,83+110],
    [84,85,85+110,84+110],
    [85,86,86+110,85+110],
    [86,93,93+110,86+110],
    [93,92,92+110,93+110],
    [92,91,91+110,92+110],
    [91,75,75+110,91+110],
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
    [[0 +i, 1 +i, 20 +i, 19 +i, 0 +i+110, 1 +i+110, 20 +i+110, 19 +i+110] for i in range(18)], \
    [[19+i, 20+i, 39 +i, 38 +i, 19+i+110, 20+i+110, 39 +i+110, 38 +i+110] for i in range(18)], \
    [[38+i, 39+i, 58 +i, 57 +i, 38+i+110, 39+i+110, 58 +i+110, 57 +i+110] for i in range(7 )], \
    [[49+i, 50+i, 66 +i, 65 +i, 49+i+110, 50+i+110, 66 +i+110, 65 +i+110] for i in range(7 )], \
    [[57+i, 58+i, 74 +i, 73 +i, 57+i+110, 58+i+110, 74 +i+110, 73 +i+110] for i in range(7 )], \
    [[65+i, 66+i, 82 +i, 81 +i, 65+i+110, 66+i+110, 82 +i+110, 81 +i+110] for i in range(7 )], \
    [[73+i, 74+i, 90 +i, 89 +i, 73+i+110, 74+i+110, 90 +i+110, 89 +i+110] for i in range(2 )], \
    [[86+i, 87+i, 94 +i, 93 +i, 86+i+110, 87+i+110, 94 +i+110, 93 +i+110] for i in range(2 )], \
    [[89+i, 90+i, 97 +i, 96 +i, 89+i+110, 90+i+110, 97 +i+110, 96 +i+110] for i in range(6 )], \
    [[96+i, 97+i, 104+i, 103+i, 96+i+110, 97+i+110, 104+i+110, 103+i+110] for i in range(6 )], \
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
    yi = np.abs(of_xyz[1][ix] - of_xyz[1][ix1])
    dx_i = (xi**2 + yi**2)**(1/2)

    ix = of_block[i][[3,2]]
    ix1 = of_block[i][[0,1]]
    xi = np.abs(of_xyz[0][ix] - of_xyz[0][ix1])
    yi = np.abs(of_xyz[1][ix] - of_xyz[1][ix1])
    dy_i = (xi**2 + yi**2)**(1/2)

    dx_min = min(np.r_[dx_i[dx_i != 0],dy_i[dy_i != 0],dx_min])
print('dx_min: %f'%dx_min)

if id_pl:
    plt.plot(of_xy[0],of_xy[1],color=[0,0.5,0],\
            marker='o',fillstyle='none', \
            markersize=3, \
            # ,markerfacecolor=[0,0,.5], \
            )

    plt.savefig('cfd_deck_ofm_%s.pdf'%s_angle)
    plt.show()
