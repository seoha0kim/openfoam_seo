#!/usr/bin/env python

"""d_cfd.py: openFoam CFD of a deck."""

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
import time
start_time = time.time()

# reset
id_pl = True
# id_pl = False

import numpy as np
import matplotlib.pyplot as plt
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
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
plt.rcParams['font.size'] = 13
plt.rcParams['axes.linewidth'] = 0.5
plt.rcParams['lines.linewidth'] = 0.5

import os
import shutil

from scipy.io import loadmat
from scipy.io import savemat


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

s_angle_p = ['00','02','m2','04','m4','06','m6']
angle_p   = [ 0  ,  2 , -2 ,  4 , -4 ,  6 , -6]
# s_angle_p = ['02','m2','04','m4','06','m6']
# angle_p = [2,-2,4,-4,6,-6]



for id_angle in range(len(angle_p)):
    al = angle_p[id_angle]*np.pi/180
    print('Angle of attack: %d'%al)
    f_in.write('\nAngle of attack: %d'%al)
    s_angle = s_angle_p[id_angle]
    # print('Angle of attack: %s'%s_angle)

    exec(open("d_blockMesh.py").read(), globals())

    p = os.popen('pwd',"r")
    while 1:
        line = p.readline()
        if not line: break
        print (line)
    # try:
    #     # os.remove("%s"%s_angle)
    #     shutil.rmtree('%s'%s_angle)
    # except:
    #     pass
    # except Exception as e:
    #     raise e
    try:
        p = os.popen('mkdir %s'%s_angle,"r")
        while 1:
            line = p.readline()
            if not line: break
            print (line)
    except:
        pass
    try:
        os.chdir('%s'%s_angle)
        p = os.popen('pwd',"r")
        while 1:
            line = p.readline()
            if not line: break
            print (line)
    except:
        pass
    try:
        p = os.popen('cp -r ../system .',"r")
        while 1:
            line = p.readline()
            if not line: break
            print (line)
        p = os.popen('cp -r ../constant .',"r")
        while 1:
            line = p.readline()
            if not line: break
            print (line)
        p = os.popen('cp -r ../0 .',"r")
        while 1:
            line = p.readline()
            if not line: break
            print (line)
    except:
        pass

    try:
        p = os.popen('blockMesh >> log.blockMesh',"r")
        while 1:
            line = p.readline()
            if not line: break
            print (line)
    except:
        pass
    try:
        p = os.popen('checkMesh >> log.checkMesh',"r")
        while 1:
            line = p.readline()
            if not line: break
            print (line)
    except:
        pass
    try:
        # p = os.popen('simpleFoam >> log.simpleFoam',"r")
        p = os.popen('pisoFoam >> log.pisoFoam',"r")
        while 1:
            line = p.readline()
            if not line: break
            print (line)
    except:
        pass

    try:
        os.chdir('..')
        p = os.popen('pwd',"r")
        while 1:
            line = p.readline()
            if not line: break
            print (line)
    except:
        pass

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
