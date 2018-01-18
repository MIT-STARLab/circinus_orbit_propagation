function [statvec] = kepel_statvec (kepel)
%  [statvec] = kepel_statvec (kepel)
%	The function kepel_statvec transforms the keplerian
%	elements kepel into the corresponding state vector in
%	the same reference system.
%
% Input:
%	kepel
% 		vector containing the keplerian elements:
%		(1) - semimajor axis of the orbit in meters.
%		(2) - eccentricity.
%		(3) - inclination in radians.
%		(4) - right ascension of ascending node in radians.
%		(5) - argument of perigee in radians.
%		(6) - mean anomaly in radians.
%
% Output:
%	statvec
%  		state vector in meters and meters/second.
%
% Authors:
%	Helio K. Kuga;
%	Valder M. Medeiros;
%	Valdemir Carrara		february/80		version 1.0
%	Valdemir Carrara		july 2005		(C version)
%   Valdemir Carrara            March/09        Matlab

EARTH_GRAVITY	= 3.9860064e+14;		% Earth's gravitational constant (m**3/s**2)

a    = kepel(1);	% semi-major axis
exc  = kepel(2);	% eccentricity

c1   = sqrt(1. - exc*exc);

%     rotation matrix

orb2iner = rotmaz(-kepel(4))*rotmax(-kepel(3))*rotmaz(-kepel(5));

%     Kepler's equation

E    = kepler(kepel(6), exc);

sE   = sin(E);
cE   = cos(E);
c3   = sqrt(EARTH_GRAVITY/a)/(1. - exc*cE);

%     state vector

statvec = [[a*(cE - exc), a*c1*sE, 0]*orb2iner', [-c3*sE, c1*c3*cE, 0]*orb2iner'];

