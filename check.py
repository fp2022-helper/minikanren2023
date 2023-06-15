from numpy.random import seed
from numpy.random import poisson
from numpy.random import normal
from scipy.stats import kstest

data = [375.594482421875,
      323.340087890625,
      320.297607421875,
      322.656494140625,
      320.990966796875,
      333.43994140625,
      360.850341796875,
      350.103515625,
      351.410400390625,
      337.1123046875]
print(data)
print( kstest(data, 'norm') )

data = poisson(5, 100)
print(data)
print( kstest(data, 'norm') )

data = poisson(5, 100)
print(data)
print( kstest(data, 'norm') )

norm_a = normal(loc = 0, scale = 1, size = 10)
print(norm_a)
print( kstest(norm_a, 'norm') )
norm_b = normal(loc = 3, scale = 2, size = 10)
print(norm_b)
print( kstest(norm_b, 'norm') )
print( kstest(standardize(norm_b), 'norm') )
