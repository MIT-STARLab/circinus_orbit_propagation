function [shadow] = earth_shadow (sat_pos, sun_pos)
% [shadow] = earth_shadow (sat_pos, sun_pos)
%
%	The function earth_shadow verifies if a given position
%	is or isn't in the earth shadow.
%
% Inputs:
%	sat_pos
%		spacecraft coordinates in the inertial system, in meters.
%	sun_pos
%		coordinates of the sun in the inertial frame, in meters.
%
% Remarks:
%	1 - Earth is considered as a sphere
%	2 - Penunbra is calculated as straight horizon line
%
% Outputs:
%	earth_shadow
%		0: spacecraft is in the earth shadow
%		1: spacecraft is illuminated by the sun
%       between 0 and 1: spacecraft is in the Earth penumbra,
%		earth_shadow gives the visible fraction of the sun.
%
% Author:  Valdemir Carrara            mar/88        v. 1.0
%									july/05			C version
%   Valdemir Carrara            March/09        Matlab

EARTH_RADIUS	= 6378139.;		% Earth's radius in meters
SUN_RADIUS		= 0.6953e+09;	% Sun's radius (meters)

dsun   = norm(sun_pos(1:3));
if dsun <= 0
    shadow =  -1;	% a distancia ao Sol é nula
else
	vecsun = sun_pos(1:3)/dsun;
	rcob   = dot(sat_pos(1:3), vecsun);
	if rcob < 0
		radi   = SUN_RADIUS/dsun;
        auxi   = cross(sat_pos(1:3),vecsun);
        auxi   = norm(auxi);
		psvs   = (auxi - EARTH_RADIUS)/rcob/radi;
		if abs(psvs) < 1
            shadow = (acos(psvs) - psvs*sqrt(1. - psvs*psvs))/pi;
        else
            if psvs >= 0
                shadow = 0;
            else
                shadow = 1;
            end
        end
    else
        shadow = 1;
    end
end

