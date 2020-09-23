#
#   d_pre.py
#
__author__ = "Saang Bum Kim"


import numpy as np
import time
start_time = time.time()



import matplotlib as mpl
import matplotlib.pyplot as plt

# if True:
if False:
    mpl.use("pgf")

    ## TeX preamble
    preamble = [
        r'\usepackage{fontspec}',
        # r'\setmainfont{Linux Libertine O}',
        r'\setmainfont{Libertinus Serif Regular}',

        r'\usepackage{unicode-math}',
        r'\setmathfont{Libertinus Math}',
    ]

    params = {
        'font.family': 'serif',
        'text.usetex': True,
        # 'text.latex.unicode': True,
        'pgf.rcfonts': False,
        'pgf.texsystem': 'xelatex',
        'pgf.preamble': preamble,
    }

    mpl.rcParams.update(params)


    plt.rcParams['font.size'] = 9
    plt.rcParams['font.size'] = 13
    plt.rcParams['axes.linewidth'] = 0.5
    plt.rcParams['lines.linewidth'] = 0.5



from scipy.io import loadmat
from scipy.io import savemat

from scipy import optimize


#
#   FINE
#