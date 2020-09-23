import os

from subprocess import Popen
from scipy.io import loadmat
from scipy.io import savemat

import numpy as np

import matplotlib.pyplot as plt



# infile = os.path.join(os.path.dirname(__file__), 'infile.mat')
infile = os.path.join(os.path.dirname(__file__), 'deck_vertices.mat')
# outfile = os.path.join(os.path.dirname(__file__), 'outfile.mat')
outfile = os.path.join(os.path.dirname(__file__), 'deck_vertices.mat')
#
# with open(infile, 'wb+') as fp: pass
# with open(outfile, 'wb+') as fp: pass

if False:
    A = np.array([
    [1, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 1, 0],
    [0, 0, 0, 1]], dtype=float)

    indict = {'A': A}

    savemat(infile, indict)

    matlab  = ['matlab']
    options = ['-nosplash', '-r']
    command = ["load('{0}');[R, jb]=rref(A);save('{1}');exit;".format(infile, outfile)]

    # on mac use the full path to matlab or add the path to your .profile
    # matlab = ['/Applications/MATLAB_R2016a.app/bin/matlab']

    # on windows use:
    # options = ['-nosplash', '-wait', '-r']

    p = Popen(matlab + options + command)

    stdout, stderr = p.communicate()

outdict = loadmat(outfile)
x = outdict['x'].tolist()[0]
y = outdict['x'].tolist()[1]

# print (x)
# print (y)


id_c0 = [1,2,3,11,18,20,19,17,16,15,14,13,12,10,9,8,7,6,5,4,1]
# id_c = [ii-1 for ii in id_c0]
xs = [x[ii-1] for ii in id_c0]
ys = [y[ii-1] for ii in id_c0]

# should be [1, 2, 3, 4]
# don't forget Matlab is 1-based
# so convert to [0, 1, 2, 3]


plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.plot(xs, ys)

plt.xlabel(r'\textbf{x} (s)')
plt.ylabel(r'\textit{y} (mV)',fontsize=16)
plt.title(r"\TeX\ is Number "
          r"$\displaystyle\sum_{n=1}^\infty\frac{-e^{i\pi}}{2^n}$!",
          fontsize=16, color='gray')
# Make room for the ridiculously large title.
plt.subplots_adjust(top=0.8)

plt.axis('equal')

plt.savefig('tex_demo')
plt.show()


