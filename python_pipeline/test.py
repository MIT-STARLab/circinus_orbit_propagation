#! /usr/bin/env python

##
# Test script
# @author Kit Kennedy
# 

import matplotlib.pyplot as plt
# plt.ion()

from poliastro.plotting import plot


from poliastro.bodies import Earth
from poliastro.twobody import Orbit
from poliastro.twobody.propagation import kepler
from astropy import units as u

##################### 
# Orbit Propatation


# Data from Curtis, example 4.3
# r = [-6045, -3490, 2500] * u.km
# v = [-3.457, 6.618, 2.533] * u.km / u.s
# ss = Orbit.from_vectors(Earth, r, v)

# earth radius in km
R_e = Earth.R.value/1000

e = 0
r_p = 600+R_e
# r_a = 600+R_e

a = r_p/(1-e) * u.km
ecc = e * u.one
inc = 0 * u.deg
raan = 0 * u.deg
argp = 0 * u.deg
nu = 120 * u.deg

from astropy import time
epoch = time.Time("2018-01-17 10:43")  # UTC by default

ss = Orbit.from_classical(Earth, a, ecc, inc, raan, argp, nu, epoch=epoch)

print(ss.epoch)

import time 
ss_new = ss.propagate(30 * u.min)

a = time.time()
k = ss.attractor.k.to(u.km ** 3 / u.s ** 2).value
r = ss.r.to(u.km).value
v = ss.v.to(u.km / u.s).value
tof = 30*60
r_new, v_new = kepler(k,
                  r, v,
                  tof,
                  rtol=1e-10,)
b = time.time()
print("b-a: %f"%(b-a))

# print(ss_new.epoch)

# plot(ss)
# plot(ss_new)
# plt.show()

##################### 
# Solar Ephemeris

##################### 
# Solar Ephemeris



# import ephem

# if __name__ == "__main__":
#     u = ephem.Uranus()
#     u.compute('1781/3/13')
#     print('%s %s %s' % (u.ra, u.dec, u.mag))
