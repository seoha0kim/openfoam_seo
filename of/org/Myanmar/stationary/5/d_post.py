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
# reset
import shutil
exec(open("d_pre.py").read(), globals())

id_pl = True
# id_pl = False

#
#   FILE I/O
#
# s_now = time.strftime("%Y%m%d_%H%M%S")
s_now = time.strftime("%Y%m%d")
# print(s_now)

fileName = 'd_cfd_post_' + s_now + '.log'
f_in = open(fileName, 'w')
f_in.write('#\n')
f_in.write('#   d_cfd_post\n')
f_in.write('#   Author: Saang Bum Kim, sbkim1601@gmail.com\n')
f_in.write('#   Date  : 2017-08-25T16:55:40+09:00\n')
f_in.write('#\n')

s_angle_p = ['00','02','m2','04','m4','06','m6']
angle_p   = [ 0  , 2  , -2 ,  4 , -4 ,  6 , -6]
# s_angle_p = ['02','m2','04','m4','06','m6']
# angle_p = [2,-2,4,-4,6,-6]

x = []
y = []

s_wr = [0,10,50,100,500,1000,5000,10000,50000]
# for id_angle in range(len(angle_p)):
for id_angle in range(1):
    al = angle_p[id_angle]*np.pi/180
    print('Angle of attack: %d'%al)
    f_in.write('Angle of attack: %d'%al)
    s_angle = s_angle_p[id_angle]
    # print('Angle of attack: %s'%s_angle)

    # exec(open("d_blockMesh.py").read(), globals())

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
    # # except Exception as e:
    # #     raise e
    # try:
    #     p = os.popen('mkdir %s'%s_angle,"r")
    #     while 1:
    #         line = p.readline()
    #         if not line: break
    #         print (line)
    # except:
    #     pass
    # # except Exception as e:
    # #     raise e
    for id_wr in s_wr:
        try:
            os.chdir('%s/postProcessing/forceCoeffs/%d'%(s_angle,id_wr))
            p = os.popen('pwd',"r")
            while 1:
                line = p.readline()
                if not line: break
                print (line)

            fileName = 'forceCoeffs.dat'
            f_d = open(fileName, 'r')
            for line in f_d:
                n = len(line)
                if n > 0:
                    if line[0] != '#':
                        x0 = line.split('\t')
                        x1 = [float(xi) for xi in x0]
                        # print(x1)
                        x.append(x1)

            try:
                os.chdir('../../../..')
                p = os.popen('pwd',"r")
                while 1:
                    line = p.readline()
                    if not line: break
                    print (line)
            except:
                pass
            # except Exception as e:
            #     raise e

            os.chdir('%s/postProcessing/forces/%d'%(s_angle,id_wr))
            p = os.popen('pwd',"r")
            while 1:
                line = p.readline()
                if not line: break
                print (line)

            fileName = 'forces.dat'
            f_d = open(fileName, 'r')
            for line in f_d:
                n = len(line)
                if n > 0:
                    if line[0] != '#':
                        x0 = line.replace(')','').replace('(','').split('\t')
                        # print(x0)
                        x1 = float(x0[0])
                        # print(x1)
                        x2 = [float(xi) for xi in x0[1].split(' ')]
                        # print(x2)
                        x2.insert(0,x1)
                        y.append(x2)

            try:
                os.chdir('../../../..')
                p = os.popen('pwd',"r")
                while 1:
                    line = p.readline()
                    if not line: break
                    print (line)
            except:
                pass
            # except Exception as e:
            #     raise e

        except:
            pass
        # except Exception as e:
            # raise e

    # try:
    #     os.chdir('..')
    #     p = os.popen('pwd',"r")
    #     while 1:
    #         line = p.readline(  )
    #         if not line: break
    #         print (line)
    # except:
    #     pass
    # # except Exception as e:
    # #     raise e


xn = np.array(x)
yn = np.array(y)


#   drag
B = 0.3025
U = 5
fig1 = plt.figure()
plt.subplot(121)
plt.plot(xn[:,0],xn[:,2]*0.1/B,color=[0,0,1])
plt.plot(xn[:,0],xn[:,3]*0.1/B,':',color=[0,.25,0])
plt.plot(xn[:,0],xn[:,1]*0.1/B**2,color=[1,0,0])
plt.plot(xn[:,0],xn[:,4]*.1/B,color=[0,1,0])
plt.plot(xn[:,0],xn[:,5]*.1/B,color=[0,.75,0])
plt.plot(xn[:,0],(xn[:,4]+xn[:,5])*.1/B,'--',color=[0,.5,0],linewidth=1)
plt.subplot(122)
id_123 = 3-1
plt.plot(yn[:,0],yn[:,9+id_123+1],color=([0,0,.25]))
plt.plot(yn[:,0],yn[:,9+id_123+4],color=([0,0,.5]))
plt.plot(yn[:,0],yn[:,9+id_123+7],color=([0,0,.75]))
plt.plot(yn[:,0],yn[:,9+id_123+1]+yn[:,9+4]+yn[:,9+7],'--',color=([0,0,1]))
plt.subplot(121)
plt.plot(yn[:,0],(yn[:,1]+yn[:,4]+yn[:,7])/(1/2*1.225*U**2*0.1/0.1*B),'--',color=([0,0,.5]),linewidth=2)
plt.plot(yn[:,0],(yn[:,2]+yn[:,5]+yn[:,8])/(1/2*1.225*U**2*0.1/0.1*B),'--',color=([0,.5,0]),linewidth=2)
# plt.plot(yn[:,0],(yn[:,12]+yn[:,15]+yn[:,18])/(1/2*1.225*5**2*1),color=([.5,0,0]),linewidth=2)
plt.plot(yn[:,0],(yn[:,9+id_123+1]+yn[:,9+id_123+4]+yn[:,9+id_123+7])/(1/2*1.225*U**2*B**2),'--',color=([.5,0,0]),linewidth=2)
# plt.plot(yn[:,0],(yn[:,1]+yn[:,2]+yn[:,3])/(1/2*1.225*5**2*0.1),color=([0,0,.5]))

plt.grid()
plt.savefig('C_DLM_%s_%s.pdf'%(s_angle,s_now))
plt.show()


savemat('res_C_DLM_%s'%s_now, \
    {'xn':xn,'yn':yn,}, appendmat=True, format='5', long_field_names=False, do_compression=False, oned_as='column')


f_in.write('\n')
f_in.write('\n#')
f_in.write('\n#   FINE')
f_in.write('\n#')
f_in.close()


#
#   FINE
#