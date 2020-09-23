#!/usr/bin/env python

"""d_blockMesh.py: generate a blockMeshDict for openFoam CFD of a deck."""

__author__ = "Saang Bum Kim"
__copyright__ = "Copyright (C) 2018 Saang Bum Kim"
# __copyright__ = "Copyright (C) 2017 Saang Bum Kim"
__credits__ = ["Saang Bum Kim"]
# __license__ = "GPL"
# __license__ = "Public Domain"
__version__ = "1.0.0"
__date_ = "2018-10-17T13:12:17+09:00"
# __date_ = "2017-08-21T10:01:49+09:00"
__maintainer__ = "Saang Bum Kim"
__email__ = "sbkimwind@gmail.com"
__status__ = "Production"


#
#   PART I.     Pre Process
#
if __name__ == '__main__':
    exec(open("d_pre.py").read(), globals())

    # reset
    id_pl = True
    # id_pl = False
    id_sv = True
    # id_sv = False

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
f_bl.write('#   Author: Saang Bum Kim, sbkimwind@gmail.com\n')
f_bl.write('#   Date  : 2018-10-17T13:13:36+09:00\n')
# f_bl.write('#   Date  : 2017-08-25T16:55:40+09:00\n')
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

lam_Lo = 1./1.
lam_L = 80
# lam_L = 50.

if False:
    # infile = os.path.join(os.path.dirname(__file__), 'deck_vertices.mat')
    infile = os.path.join(os.path.dirname(__file__), 'deck_vertices.mat')
    indict = loadmat(infile)
    x = indict['x'].tolist()
else:
    xo = [
        [-16.02, 1.26],
        [-16.01, 0.66],
        [-15.46, 0.67],
        [-14.76, 1.04],
        [-8.86, 1.19],
        [-7.21, 0.93],
        [-3.45, -2.83],
        [3.45, -2.83],
        [7.21, 0.93],
        [8.86, 1.19],
        [14.76, 1.04],
        [15.46, 0.67],
        [16.01, 0.66],
        [16.02, 1.26],
        [0.55, 1.65],
        [0.50, 1.91],
        [-0.50, 1.91],
        [-0.55, 1.65],
        [-16.02, 1.26]]
    x = [[i[0] for i in xo], [i[1] for i in xo]]
    print(x)
# id_c1 = [1,2,3,11,18,20,19,17,16,15,14,13,12,10,9,8,7,6,5,4,1]
# id_c1 = [1,3,4,5,6,7,12,8,10,14,19,21,17,22,23,24,25,26,27,28,15,2,1]
id_c1 = range(19)
# id_c0 = id_c1[-1::-1]
id_c0 = id_c1
# xs = np.array([[x[0][ii-1],x[1][ii-1]] for ii in id_c0])
xs = np.array([[x[0][ii]*lam_Lo,x[1][ii]*lam_Lo] for ii in id_c0])
xs = xs.T

dx = [max(xs[0])-min(xs[0]),max(xs[1])-min(xs[1])]
x0 = [(max(xs[0])+min(xs[0]))/2,(max(xs[1])+min(xs[1]))/2]

xs_old = xs
xs = np.array([(xi - x0)/lam_L for xi in xs_old.T]).T
dx_old = dx
dx = [max(xs[0])-min(xs[0]),max(xs[1])-min(xs[1])]

f_bl.write('\ndx [mm]: %f, %f'%(dx_old[0]*1e3,dx_old[1]*1e3))
for i in range(19):
    f_bl.write('\ndx [mm]: %f, %f: %d'%(xs_old[0][i]*1e3,xs_old[1][i]*1e3,i))

# al = angle_p[id_angle]*np.pi/180
# G_al = np.array( [ [np.cos(al),-np.sin(al)], [np.sin(al),np.cos(al)] ] )
# xs_al = np.array([ np.dot(G_al, [xs[0][i],xs[1][i]]) for i in range(np.shape(xs)[1])])
# xs = xs_al.T
# xs = xs.T

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

    # plt.text(0,0,r'$C_D = \int_\Gamma \d \Gamma$')

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
# wtt_x = [6,1.5*2]
wtt_x = [6,1.5]
wtt_xy = [ \
    [wtt_x[0]*1.5/6*-1,wtt_x[0]*4.5/6,wtt_x[0]*4.5/6,wtt_x[0]*1.5/6*-1,wtt_x[0]*1.5/6*-1], \
    # [wtt_x[0]/2*-1,wtt_x[0]/2,wtt_x[0]/2,wtt_x[0]/2*-1,wtt_x[0]/2*-1], \
    [wtt_x[1]/2*-1,wtt_x[1]/2*-1,wtt_x[1]/2,wtt_x[1]/2,wtt_x[1]/2*-1]
    ]


#
#   Boundary layer
#
bd_x = [
    [-dx[0]*2/2  , dx[0]*2/2*2,dx[0]*2/2*2,-dx[0]*2/2  ,-dx[0]*2/2  ],
    [-dx[1]*5/2*2,-dx[1]*5/2*2,dx[1]*5/2*2, dx[1]*5/2*2,-dx[1]*5/2*2]
    ]

# G_al = np.array( [ [np.cos(al),-np.sin(al)], [np.sin(al),np.cos(al)] ] )
# bd_al = np.array([ np.dot(G_al, [bd_x[0][i],bd_x[1][i]]) for i in range(np.shape(bd_x)[1])])
# bd_x = bd_al.T

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
        wtt_xy[0][0],bd_x[0][0],xs[0][1:13],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][1:13],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][1:13],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][18:16:-1],xs[0][14:12:-1],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][18],xs[0][16:14:-1],xs[0][13],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][18],xs[0][16:14:-1],xs[0][13],bd_x[0][1],wtt_xy[0][1], \
        wtt_xy[0][0],bd_x[0][0],xs[0][18],xs[0][16:14:-1],xs[0][13],bd_x[0][1],wtt_xy[0][1], \
        ]),
    np.hstack([ \
        [wtt_xy[1][0]]*16, \
        [bd_x[1][0]]*16, \
        [xs[1][1]]*3, xs[1][2:12], [xs[1][12]]*3, \
        [xs[1][18]]*3, xs[1][17], xs[1][14], [xs[1][13]]*3, \
        [xs[1][16]]*4, [xs[1][15]]*4, \
        [bd_x[1][2]]*8, \
        [wtt_xy[1][2]]*8, \
        ]),
]

G_al = np.array( [ [np.cos(al),-np.sin(al)], [np.sin(al),np.cos(al)] ] )
for i in np.hstack((range(17,31),range(33,47),range(49,55),range(57,63),range(65,71))):
    of_xy[0][i],of_xy[1][i] = np.dot(G_al, [of_xy[0][i],of_xy[1][i]])

if id_pl:
    # print(of_xy)
    plt.cla()
    plt.plot(of_xy[0],of_xy[1],color=[0,0.5,0],\
            marker='o',fillstyle='none', \
            markersize=.5, \
            markeredgewidth=.1, \
            linewidth=0.1, \
            # ,markerfacecolor=[0,0,.5], \
            )

    plt.savefig('cfd_deck_ofm_%s.pdf'%s_angle)
    # if __name__ == '__main__':
    #     plt.show()


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

of_face_back = np.r_[ \
    [[0 +i, 1 +i, 17+i, 16+i] for i in range(15)], \
    [[16+i, 17+i, 33+i, 32+i] for i in range(15)], \
    [[32+i, 33+i, 49+i, 48+i] for i in range(2 )], \
    [[45+i, 46+i, 54+i, 53+i] for i in range(2 )], \
    [[48+i, 49+i, 57+i, 56+i] for i in range(3 )], \
    [[52+i, 53+i, 61+i, 60+i] for i in range(3 )], \
    [[56+i, 57+i, 65+i, 64+i] for i in range(7 )], \
    [[64+i, 65+i, 73+i, 72+i] for i in range(7 )], \
    ]
n_nf = 80
of_face_back = [i[-1::-1] for i in of_face_back]
# print(np.array([np.r_[i,of_face_back[i]] for i in range(np.shape(of_face_back)[0])]))
of_face_front = [i[-1::-1]+n_nf for i in of_face_back]
# of_face_front = [i+n_nf for i in of_face_back]
# print(np.array([np.r_[i+60,of_face_front[i]] for i in range(np.shape(of_face_front)[0])]))
of_face_top = \
    [[72+i, 73+i, 73+n_nf+i, 72+n_nf+i][-1::-1] for i in range(7)]
# pr_of_face(of_face_top)
of_face_bottom = \
    [[0+i, 1+i, 1+n_nf+i, 0+n_nf+i] for i in range(15)]
# pr_of_face(of_face_bottom)
of_face_inlet = [ \
    [0,16,16+n_nf,0+n_nf][-1::-1],
    [16,32,32+n_nf,16+n_nf][-1::-1],
    [32,48,48+n_nf,32+n_nf][-1::-1],
    [48,56,56+n_nf,48+n_nf][-1::-1],
    [56,64,64+n_nf,56+n_nf][-1::-1],
    [64,72,72+n_nf,64+n_nf][-1::-1],
    ]
# pr_of_face(of_face_inlet)
of_face_outlet = [ \
    [15,31,31+n_nf,15+n_nf],
    [31,47,47+n_nf,31+n_nf],
    [47,55,55+n_nf,47+n_nf],
    [55,63,63+n_nf,55+n_nf],
    [63,71,71+n_nf,63+n_nf],
    [71,79,79+n_nf,71+n_nf],
    ]
# pr_of_face(of_face_outlet)
of_face_deck = [ \
    [34,35,35+n_nf,34+n_nf],
    [35,36,36+n_nf,35+n_nf],
    [36,37,37+n_nf,36+n_nf],
    [37,38,38+n_nf,37+n_nf],
    [38,39,39+n_nf,38+n_nf],
    [39,40,40+n_nf,39+n_nf],
    [40,41,41+n_nf,40+n_nf],
    [41,42,42+n_nf,41+n_nf],
    [42,43,43+n_nf,42+n_nf],
    [43,44,44+n_nf,43+n_nf],
    [44,45,45+n_nf,44+n_nf],
    [45,53,53+n_nf,45+n_nf],
    [53,52,52+n_nf,53+n_nf],
    [52,60,60+n_nf,52+n_nf],
    [60,59,59+n_nf,60+n_nf],
    [59,51,51+n_nf,59+n_nf],
    [51,50,50+n_nf,51+n_nf],
    [50,34,34+n_nf,50+n_nf],
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
    [[0 +i, 1 +i, 17+i, 16+i, 0 +i+n_nf, 1 +i+n_nf, 17+i+n_nf, 16+i+n_nf] for i in range(15)], \
    [[16+i, 17+i, 33+i, 32+i, 16+i+n_nf, 17+i+n_nf, 33+i+n_nf, 32+i+n_nf] for i in range(15)], \
    [[32+i, 33+i, 49+i, 48+i, 32+i+n_nf, 33+i+n_nf, 49+i+n_nf, 48+i+n_nf] for i in range(2 )], \
    [[45+i, 46+i, 54+i, 53+i, 45+i+n_nf, 46+i+n_nf, 54+i+n_nf, 53+i+n_nf] for i in range(2 )], \
    [[48+i, 49+i, 57+i, 56+i, 48+i+n_nf, 49+i+n_nf, 57+i+n_nf, 56+i+n_nf] for i in range(3 )], \
    [[52+i, 53+i, 61+i, 60+i, 52+i+n_nf, 53+i+n_nf, 61+i+n_nf, 60+i+n_nf] for i in range(3 )], \
    [[56+i, 57+i, 65+i, 64+i, 56+i+n_nf, 57+i+n_nf, 65+i+n_nf, 64+i+n_nf] for i in range(7 )], \
    [[64+i, 65+i, 73+i, 72+i, 64+i+n_nf, 65+i+n_nf, 73+i+n_nf, 72+i+n_nf] for i in range(7 )], \
    ]
# pr_of_face(of_block)

dx_min = 1e3
dx_max = 0
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
    dx_max = max(np.r_[dx_i[dx_i != 0],dy_i[dy_i != 0],dx_max])
dx_min *= 2
print('dx_min: %f'%dx_min)
f_bl.write('\ndx_min: %f'%dx_min)
print('dx_max: %f'%dx_max)
f_bl.write('\ndx_max: %f'%dx_max)


n_amp = 2
r_g = 1.1

of_br = np.zeros([np.shape(of_block)[0],4])
n_g0 = np.zeros(np.shape(of_block)[0])
n_g1 = np.zeros(np.shape(of_block)[0])
R_g0 = np.zeros([np.shape(of_block)[0],4])
for i in range(np.shape(of_block)[0]):
    ix = of_block[i][[1,2]]
    ix1 = of_block[i][[0,3]]
    xi = np.abs(of_xyz[0][ix] - of_xyz[0][ix1])
    yi = np.abs(of_xyz[1][ix] - of_xyz[1][ix1])
    dx_i = (xi**2 + yi**2)**(1/2)
    of_br[i,[0,1]] = np.maximum(dx_i/dx_min*n_amp,[1,1])
    if i in [0,14,47,53]:
        n_g0[i] = np.log(np.max(of_br[i,[0,1]])*(r_g-1)+1) / np.log(r_g)
        # def er(ri):
        #     return (np.log(dx_i/(dx_min/n_amp)*(ri-1)+1)/np.log(ri) - n_g0[i])
        # r_0 = optimize.leastsq(er, [r_g,r_g])
        # R_g0[i,[0,1]] = r_0[0]**(n_g0[i]-1)
    else:
        n_g0[i] = np.max(of_br[i,[0,1]])
    # f_bl.write('\nBlock ID: %d, # of mesh cell in a block, %d, R: %s'%( \
    #     # i, n_g0[i], ' '.join('%f'%r_0[0][j] for j in range(2))
    #     i, n_g0[i], ' '.join('%f'%R_g0[i,j] for j in range(2))
    #     ))

    ix = of_block[i][[3,2]]
    ix1 = of_block[i][[0,1]]
    xi = np.abs(of_xyz[0][ix] - of_xyz[0][ix1])
    yi = np.abs(of_xyz[1][ix] - of_xyz[1][ix1])
    dx_i = (xi**2 + yi**2)**(1/2)
    of_br[i,[2,3]] = np.maximum(dx_i/dx_min*n_amp,[1,1])
    if i in [0,14,47,53]:
        n_g1[i] = np.log(np.max(of_br[i,[2,3]])*(r_g-1)+1) / np.log(r_g)
    else:
        n_g1[i] = np.max(of_br[i,[2,3]])
    # def er(ri):
    #     return (np.log(dx_i/(dx_min/n_amp)*(ri-1)+1)/np.log(ri) - n_g1[i])
    # r_0 = optimize.leastsq(er, [r_g,r_g])
    # R_g0[i,[2,3]] = r_0[0]**(n_g1[i]-1)
    # # f_bl.write('\nBock ID: %d, # of mesh cell in a block, %d, r: %s'%( \
    # f_bl.write(', %d, R:%s'%( \
    #     # i, n_g0[i], ' '.join('%f'%r_0[0][j] for j in range(2))
    #     n_g1[i], ' '.join('%f'%R_g0[i,j+2] for j in range(2))
    #     ))

#
#   regulation: n_g0, n_g1
#
n_g1[0:14] = n_g1[14]
n_g1[15:29] = n_g1[29]
n_g1[30] = n_g1[31]
n_g1[32] = n_g1[33]
n_g1[34:36] = n_g1[36]
n_g1[37:39] = n_g1[39]
n_g1[40:46] = n_g1[46]
n_g1[47:53] = n_g1[53]

n_g0[[15,30,34,40,47]] = n_g0[0]
n_g0[[16,31,35,41,48]] = n_g0[1]
n_g0[[17]] = n_g0[2]
n_g0[[18]] = n_g0[3]
n_g0[[19]] = n_g0[4]
n_g0[[20]] = n_g0[5]
n_g0[[21]] = n_g0[6]
n_g0[[22]] = n_g0[7]
n_g0[[23]] = n_g0[8]
n_g0[[24]] = n_g0[9]
n_g0[[25]] = n_g0[10]
n_g0[[26]] = n_g0[11]
n_g0[[27]] = n_g0[12]
n_g0[[28,32,38,45,52]] = n_g0[13]
n_g0[[29,33,39,46,53]] = n_g0[14]

n_g0[[36,42]] = n_g0[49]
n_g0[[43]] = n_g0[50]
n_g0[[37,44]] = n_g0[51]

for i in range(np.shape(of_block)[0]):
    ix = of_block[i][[1,2]]
    ix1 = of_block[i][[0,3]]
    xi = np.abs(of_xyz[0][ix] - of_xyz[0][ix1])
    yi = np.abs(of_xyz[1][ix] - of_xyz[1][ix1])
    dx_i = (xi**2 + yi**2)**(1./2)
    def er(ri):
        return (np.log( np.abs(dx_i/(dx_min/n_amp)*(ri-1)+1) )/np.log( np.abs(ri) ) - n_g0[i])
    r_0 = optimize.leastsq(er, [r_g,r_g])
    R_g0[i,[0,1]] = r_0[0]**(n_g0[i]-1)
    f_bl.write('\nBlock ID: %d, # of mesh cell in a block, %d, R: %s'%( \
        # i, n_g0[i], ' '.join('%f'%r_0[0][j] for j in range(2))
        i, n_g0[i], ' '.join('%f'%R_g0[i,j] for j in range(2))
        ))

    ix = of_block[i][[3,2]]
    ix1 = of_block[i][[0,1]]
    xi = np.abs(of_xyz[0][ix] - of_xyz[0][ix1])
    yi = np.abs(of_xyz[1][ix] - of_xyz[1][ix1])
    dx_i = (xi**2 + yi**2)**(1./2)
    def er(ri):
        return (np.log( np.abs(dx_i/(dx_min/n_amp)*(ri-1)+1) )/np.log( np.abs(ri) ) - n_g1[i])
    r_0 = optimize.leastsq(er, [r_g,r_g])
    print('hey')
    # print(dx_i)
    print(r_0)
    R_g0[i,[2,3]] = r_0[0]**(n_g1[i]-1)
    f_bl.write(', %d, R:%s'%( \
        # i, n_g0[i], ' '.join('%f'%r_0[0][j] for j in range(2))
        n_g1[i], ' '.join('%f'%R_g0[i,j+2] for j in range(2))
        ))


if True:
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

        for ii in range(np.shape(of_block)[0]):
            if (ii == 0):
                # f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                f.write('    hex (%s) (%03d %03d 1) edgeGrading (%.1e %.1e %.1e %.1e %.1e %.1e %.1e %.1e 1 1 1 1)\n'% \
                    (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[0], n_g1[14], 1/R_g0[ii,0], 1/R_g0[ii,1], 1/R_g0[ii,1], 1/R_g0[ii,0], 1/R_g0[ii,2], 1/R_g0[ii,3], 1/R_g0[ii,3], 1/R_g0[ii,2] ) )
            elif (ii == 14):
                # f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                f.write('    hex (%s) (%03d %03d 1) edgeGrading (%.1e %.1e %.1e %.1e %.1e %.1e %.1e %.1e 1 1 1 1)\n'% \
                    # (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[ii], n_g1[ii], R_g0[ii], 1/R_g1[ii] ) )
                    (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[14], n_g1[14], R_g0[ii,0], R_g0[ii,1], R_g0[ii,1], R_g0[ii,0], 1/R_g0[ii,2], 1/R_g0[ii,3], 1/R_g0[ii,3], 1/R_g0[ii,2] ) )
            elif (ii == 47):
                # f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                f.write('    hex (%s) (%03d %03d 1) edgeGrading (%.1e %.1e %.1e %.1e %.1e %.1e %.1e %.1e 1 1 1 1)\n'% \
                    (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[0], n_g1[47], 1/R_g0[ii,0], 1/R_g0[ii,1], 1/R_g0[ii,1], 1/R_g0[ii,0], R_g0[ii,2], R_g0[ii,3], R_g0[ii,3], R_g0[ii,2] ) )
            elif (ii == 53):
                # f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                f.write('    hex (%s) (%03d %03d 1) edgeGrading (%.1e %.1e %.1e %.1e %.1e %.1e %.1e %.1e 1 1 1 1)\n'% \
                    (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[14], n_g1[53], R_g0[ii,0], R_g0[ii,1], R_g0[ii,1], R_g0[ii,0], R_g0[ii,2], R_g0[ii,3], R_g0[ii,3], R_g0[ii,2] ) )
            elif ((ii > 0) and (ii < 14)):
                # f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                f.write('    hex (%s) (%03d %03d 1) edgeGrading (%.1e %.1e %.1e %.1e %.1e %.1e %.1e %.1e 1 1 1 1)\n'% \
                    (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[ii], n_g1[14], 1, 1, 1, 1, 1/R_g0[ii,2], 1/R_g0[ii,3], 1/R_g0[ii,3], 1/R_g0[ii,2] ) )
            elif ((ii > 47) and (ii < 53)):
                # f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                f.write('    hex (%s) (%03d %03d 1) edgeGrading (%.1e %.1e %.1e %.1e %.1e %.1e %.1e %.1e 1 1 1 1)\n'% \
                    (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[ii], n_g1[53], 1, 1, 1, 1, R_g0[ii,2], R_g0[ii,3], R_g0[ii,3], R_g0[ii,2] ) )
            # left
            elif (ii == 15) or (ii == 30) or (ii == 34) or (ii == 40):
                # f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                f.write('    hex (%s) (%03d %03d 1) edgeGrading (%.1e %.1e %.1e %.1e %.1e %.1e %.1e %.1e 1 1 1 1)\n'% \
                    (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[0], n_g1[ii], 1/R_g0[ii,0], 1/R_g0[ii,1], 1/R_g0[ii,1], 1/R_g0[ii,0], 1, 1, 1, 1 ) )
            # right
            elif (ii == 29) or (ii == 33) or (ii == 39) or (ii == 46):
                # f.write('    hex (%s) (%03d %03d 1) simpleGrading (%7.3f %7.3f 1)\n'% \
                f.write('    hex (%s) (%03d %03d 1) edgeGrading (%.1e %.1e %.1e %.1e %.1e %.1e %.1e %.1e 1 1 1 1)\n'% \
                    (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[14], n_g1[ii], R_g0[ii,0], R_g0[ii,1], R_g0[ii,1], R_g0[ii,0], 1, 1, 1, 1 ) )
            elif ((ii > 15) and (ii < 29)):
                f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                    (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[ii], n_g1[ii]) )
            elif (ii == 31):
                f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                    (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[ii], n_g1[ii]) )
            elif (ii == 32):
                f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                    (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[ii], n_g1[ii]) )
            elif ((ii > 34) and (ii < 39)):
                f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                    (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[ii], n_g1[ii]) )
            elif ((ii > 40) and (ii < 46)):
                f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                    (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[ii], n_g1[ii]) )
            else:
                f.write('    hex (%s) (%03d %03d 1) simpleGrading (1 1 1)\n'% \
                    (' '.join( '%03d'%of_block[ii][jj] for jj in range(8) ), n_g0[ii], n_g1[ii]) )
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
        for ii in range(np.shape(of_face_front)[0]):
            f.write('            (%s)\n'%(' '.join( str(of_face_front[ii][jj]) for jj in range(4) )) )
        for ii in range(np.shape(of_face_back)[0]):
            f.write('            (%s)\n'%(' '.join( str(of_face_back[ii][jj]) for jj in range(4) )) )
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

    BD = [x/lam_L for x in dx_old]
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