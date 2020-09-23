#
#
#


import numpy as np
import time
start_time = time.time()
import matplotlib.pyplot as plt
plt.rc('text', usetex=True)
plt.rc('font', family='sans-serif')
if True:
# if False:
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
plt.rcParams['font.size'] = 9
plt.rcParams['axes.linewidth'] = .5
plt.rcParams['lines.linewidth'] = .5

import os

from scipy.io import loadmat
from scipy.io import savemat


#
#   FINE
#