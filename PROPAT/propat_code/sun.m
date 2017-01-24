function [sunpos] = sun (djm, ts)
% [sunpos] = sun (djm, ts)
%
%	The subroutine sun calculates the position vector
%	of the Sun in the geocentric inertial system refered
%	to j2000 equator and equinox.
%
% Input:
%	djm
%		modified julian date in days, referred to 1950.0.
%	ts
%		fraction of the day in seconds.
%
% Output:
%	sunpos
%		position vector of the sun:
%		(1) - first component of earth-sun position vector in meters.
%		(2) - second component of earth-sun position vector in meters.
%		(3) - third component of earth-sun position vector in meters.
%		(4) - right ascension in radians.
%		(5) - declination in radians.
%		(6) - radius vector (distance) in meters.
%
% Remarks:
%	this subroutine is optimized from 1950-1-1 00:01:06
%	until year 2050.
%
% Author:
%	Helio Koiti Kuga and Ulisses T. V. Guedes * version 1.0
%	C version by Valdemir Carrara 7/05
%   Valdemir Carrara            March/09        Matlab

rad = pi/180;
ASTRONOMICAL_UNIT	= 149.60e+09;		% Astronomical unit (meters)

t = djm - 18262.5 + ts/86400.;

%	Long. media do sol, corrigida

alom_ab = mod ((280.460 + 0.9856474*t)*rad, 2*pi);

if alom_ab < 0
    alom_ab = alom_ab + 2*pi;
end

%	Anomalia media

an_mean = mod ((357.528 + 0.9856003*t)*rad, 2*pi);
if an_mean < 0
    an_mean = an_mean + 2*pi;
end

an_mean_2 = an_mean +  an_mean;

if an_mean_2 > 2*pi
    an_mean_2 = mod (an_mean_2, 2*pi);
end

ecli_lo = alom_ab + (1.915*sin(an_mean) +0.02*sin(an_mean_2))*rad;
sin_ecli_lo = sin(ecli_lo);
cos_ecli_lo = cos(ecli_lo);

%	ecliptic latitude	ecli_la = 0

obl_ecli = (23.439 - 4.e-7*t)*rad;
sin_obl_ecli = sin(obl_ecli);
cos_obl_ecli = cos(obl_ecli);

sunpos = [0, 0, 0, 0, 0, 0];
sunpos(4)  = atan2(cos_obl_ecli*sin_ecli_lo, cos_ecli_lo);
if sunpos(4) < 0
    sunpos(4) = sunpos(4) + 2*pi;
end

sunpos(5) = asin(sin_obl_ecli*sin_ecli_lo);
sunpos(6) = (1.00014 - 0.01671*cos(an_mean) - 1.4e-4*cos(an_mean_2))*ASTRONOMICAL_UNIT;

sunpos(1) = sunpos(6) * cos_ecli_lo;
sunpos(2) = sunpos(6) * cos_obl_ecli * sin_ecli_lo;
sunpos(3) = sunpos(6) * sin_obl_ecli * sin_ecli_lo;


