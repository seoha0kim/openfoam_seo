#!/usr/bin/env python

"""d_cfd_pre.py: openFoam CFD of a deck."""

__author__ = "Saang Bum Kim"
__copyright__ = "Copyright (C) 2017 Saang Bum Kim"
__credits__ = ["Saang Bum Kim"]
# __license__ = "GPL"
# __license__ = "Public Domain"
__version__ = "1.0.0"
# __date_ = "2017-08-21T10:01:49+09:00"
__date_ = "2017-09-04T10:44:44+09:00"
__maintainer__ = "Saang Bum Kim"
__email__ = "sbkimwind@gmail.com"
__status__ = "Production"


#
#   PART I.     Pre Process
#
# reset
import shutil
exec(open("d_pre.py").read(), globals())


#
#   FILE I/O
#
# s_now = time.strftime("%Y%m%d_%H%M%S")
s_now = time.strftime("%Y%m%d")
# print(s_now)

# reset
id_pl = True
# id_pl = False

#
#   FILE I/O
#
# s_now = time.strftime("%Y%m%d_%H%M%S")
s_now = time.strftime("%Y%m%d")
# print(s_now)

fileName = 'd_cfd_' + s_now + '.log'
f_in = open(fileName, 'w')
f_in.write('#\n')
f_in.write('#   d_cfd\n')
f_in.write('#   Author: Saang Bum Kim, sbkim1601@gmail.com\n')
f_in.write('#   Date  : 2017-08-25T16:55:40+09:00\n')
f_in.write('#\n')


#
#   Deck
#
infile = os.path.join(os.path.dirname(__file__), 'deck_vertices.mat')
indict = loadmat(infile)
x = indict['x'].tolist()
# xs = np.array(x)
# id_c1 = [1,3,4,5,6,7,12,11,9,8,10,13,14,16,19,21,20,18,17,22,23,24,25,26,27,28,15,2,1]
id_c1 = [1,3,4,5,6,7,12,8,10,14,19,21,17,22,23,24,25,26,27,28,15,2,1]
# id_c0 = id_c1[-1::-1]
id_c0 = id_c1
xs = np.array([[x[0][ii-1],x[1][ii-1]] for ii in id_c0])
# xs = np.array([[float(x[0][ii-1] * 100.),float(x[1][ii-1] * 100.)] for ii in id_c0])
# xs = xs*5
xs = xs.T

lam_L = 80/1000

dx = [max(xs[0])-min(xs[0]),max(xs[1])-min(xs[1])]
x0 = [(max(xs[0])+min(xs[0]))/2,(max(xs[1])+min(xs[1]))/2]

xs0 = xs
xs = np.array([(xi - x0)/lam_L for xi in xs0.T]).T

# al = angle_p[id_angle]*np.pi/180
al = 4*np.pi/180
s_angle = '04'
G_al = np.array( [ [np.cos(al),-np.sin(al)], [np.sin(al),np.cos(al)] ] )
xs_al = np.array([ np.dot(G_al, [xs[0][i],xs[1][i]]) for i in range(np.shape(xs)[1])])
xs = xs_al.T

# if not id_pl:
if id_pl:
# if True:
    plt.cla()
    plt.plot(xs[0], xs[1], color=[0,0,.5], )
    # if True:
    if False:
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
    for i in range(len(xs[0])):
        plt.text(xs[0][i], xs[1][i], '%d'%i, fontsize=8)


    plt.xlabel(r'Across the bridge [m]')
    plt.ylabel(r'Vertical [m]')
    plt.title(r'$\int_0^\infty\phi[x]dx$')
    # Make room for the ridiculously large title.
    # plt.subplots_adjust(top=0.8)
    plt.axis('equal')
    plt.grid()
    # plt.savefig('cfd_deck_%s.pdf'%s_angle)
    plt.savefig('cfd_deck_%s.pdf'%('aa'+s_angle))

    if False:
        h[0].remove()
        h1[0].remove()

    plt.show()


end_time = time.time() - start_time
start_time = time.time()
print("--- %s minutes ---" % (end_time/60))
f_in.write("\nElapsed time is % .3f minutes." % (end_time/60))

f_in.write('\n')
f_in.write('\n#')
f_in.write('\n#   FINE')
f_in.write('\n#')
f_in.close()


#
#   FINE
#