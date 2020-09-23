#!/usr/bin/env python

"""d_openFoam.py: openFoam CFD of a deck."""

__author__ = "Saang Bum Kim"
__copyright__ = "Copyright (C) 2018 Saang Bum Kim"
# __copyright__ = "Copyright (C) 2017 Saang Bum Kim"
__credits__ = ["Saang Bum Kim"]
# __license__ = "GPL"
# __license__ = "Public Domain"
__version__ = "1.1.0"
__date_ = "2018-10-26T02:21:57+09:00"
# __date_ = "2018-10-22T10:17:00+09:00"
# __date_ = "2017-09-04T10:44:44+09:00"
# __date_ = "2017-08-21T10:01:49+09:00"
__maintainer__ = "Saang Bum Kim"
__email__ = "sbkimwind@gmail.com"
__status__ = "Production"


#
#   PART I.     Pre Process
#
exec(open("d_pre.py").read(), globals())

# import os
# import shutil

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

fileName = 'd_openFoam_' + s_now + '.log'
f_in = open(fileName, 'w')
f_in.write('#\n')
f_in.write('#   d_openFoam\n')
f_in.write('#   Author: Saang Bum Kim, sbkimwind@gmail.com\n')
f_in.write('#   Date  : \n', time.strftime("%Y%m%d_%H%M%S"))
f_in.write('#\n')


#
#   PART II.		Main Process
#
s_angle_p = ['00','p2','m2','p4','m4','p6','m6']
angle_p   = [ 0  ,  2 , -2 ,  4 , -4 ,  6 , -6 ]

for id_angle in range(len(angle_p)):
    al = angle_p[id_angle]*np.pi/180
    print('Angle of attack: %d'%al)
    f_in.write('\nAngle of attack: %d'%al)
    s_angle = s_angle_p[id_angle]
    # print('Angle of attack: %s'%s_angle)

    exec(open("d_blockMesh.py").read(), globals())




#     end_time = time.time() - start_time
#     start_time = time.time()
#     print("--- %s minutes ---" % (end_time/60))
#     f_in.write("\nElapsed time is % .3f minutes." % (end_time/60))


# f_in.write('\n')
# f_in.write('\n#')
# f_in.write('\n#   FINE')
# f_in.write('\n#')
# f_in.close()


#
#   FINE
#