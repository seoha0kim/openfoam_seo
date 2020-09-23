import numpy as np

l = 100
a = 1
r = 1.1
n = np.log(l/a*(r-1)+1)/np.log(r)
print('\n# of cells: %f'%n)

ni = int(n)
print('\n# of cells: %d'%ni)
# er = ni - np.log(l/a*(r-1)+1)/np.log(r)


# from scipy.optimize import minimize
from scipy import optimize

def er(ri):
    return (np.log(l/a*(ri-1)+1)/np.log(ri) - ni)**2

print('\nerr: %f'%(er(r)))

print('\n')

# print('\n#')
print('\n#   brent')
# print('\n#')

rin = optimize.brent(er)
print('\nr = %f'%rin)
print('\n# of cells: %f'%(er(rin)+ni))
print('\nerr: %f'%(er(rin)))


print('\n#   cg')
rin = optimize.fmin_cg(er,[1.1])
print('\nr = %f'%rin)
print('\n# of cells: %f'%(er(rin)+ni))
print('\nerr: %f'%(er(rin)))


print('\n#   least-squares')
ri0 = r
rin0 = optimize.leastsq(er, ri0)
rin = rin0[0]
print(rin)
print('\nr = %s'%(' '.join('%f'%(rin[i]) for i in range(np.shape(rin)[0]))))
print('\n# of cells: %f'%(er(rin)+ni))
print('\nerr: %f'%(er(rin)))
