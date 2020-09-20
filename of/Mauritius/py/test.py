import numpy as np

x = np.array([1,0])

print(x)

y = x**2 - 1
print(y)


print(2**(1/2))



for i in range(3):
    print(i)

for i in range(3,7):
    print(i)

for i in range(30):
    try:
        print(i)
        1/0
    except Exception as e:
        # raise e
        print(e)
        pass



