function [kepel] = statvec_kepel (statv)
% [kepel] = statvec_kepel (statv)
%
%	The function statvec_kepel transforms the state vector statv
%	into the corresponding keplerian elements in the
%	same reference system.
%
% Input:
%	statv
%		state vector in meters and meters/second.
%
% Output:
%	statvec_kepel
%		vector containing the keplerian elements:
%		(1) - semimajor axis of the orbit in meters.
%		(2) - eccentricity.
%		(3) - inclination in radians.
%		(4) - right ascension of ascending node in radians.
%		(5) - argument of perigee in radians.
%		(6) - mean anomaly in radians.
%
% Authors:
%	Helio K. Kuga
%    Valder M. Medeiros
%	Valdemir Carrara			february/80			version 1.0
%	Helio K. Kuga     			august/82           version 2.0
%	Ulisses T V Guedes 			december/95	 		version 2.1
%               - fix perigee procedure when orbit plane
%                  equal to equatorial plane
%	Valdemir Carrara 			july/05				(C version)
%   Valdemir Carrara            March/09        Matlab

EARTH_GRAVITY	= 3.9860064e+14;		% Earth's gravitational constant (m**3/s**2)

xp  = statv(1:3);
xv  = statv(4:6);
r      = sqrt(xp*xp');
vq     = xv*xv';
ainv   = 2.0/r - vq/EARTH_GRAVITY;

h      = cross(xp, xv);
hm     = sqrt(h*h');
if (hm < 1.e-10) 
	disp (' *** Message from function statvec_kepel: *** ');
	disp (' There are no keplerian elements corresponding to this state vector');
	kepel = [0, 0, 0, 0, 0, 0];
else
    h      = h/hm;
	incl   = acos(h(3));
	raan   = atan2(h(1), -h(2));
	d      = xp*xv' / EARTH_GRAVITY;
	esene  = d * sqrt(EARTH_GRAVITY*ainv);
	ecose  = 1 - r*ainv;
	exc    = sqrt(esene*esene + ecose*ecose);
	E      = atan2(esene, ecose);
	mean   = mod (E - esene, 2*pi);
	if mean < 0
        mean = mean + 2*pi;
    end
	if exc < 1.e-10
		arpe = 0;
    else
		dp     = 1./r - ainv;
		ev     = dp*xp - d*xv;
        abev   = sqrt(ev*ev');
		ev     = ev/abev;
		an(1)  = cos(raan);
		an(2)  = sin(raan);
		an(3)  = 0;
		fi     = ev*cross(h, an)';
		arpe = acos(ev*an');
		if fi < 0
            arpe  =  -arpe + 2*pi;
        end
    end

	kepel = [1./ainv, exc, incl, raan, arpe, mean];
end

