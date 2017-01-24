function [eccentric] = kepler (mean_anomaly, eccentricity)
% [eccentric] = kepler (mean_anomaly, eccentricity)
%	The subroutine kepler finds a solution to the
%	kepler's equation.
%
% Input:
%	mean_anomaly
%		mean anomaly in radians.
%	eccentricity
%		eccentricity.
%
% Output:
%	eccentric
%		eccentric anomaly in radians.
%
% Authors:
%	Valder M. de Medeiros		june/81		version 2.0
%	Valdemir Carrara			july 2005	(C version)
%   Valdemir Carrara            March/09        Matlab

exc2    = eccentricity*eccentricity;
am1     = mod (mean_anomaly, 2*pi);
am2     = am1 + am1;
am3     = am1 + am2;
shoot   = am1 + eccentricity*(1. - 0.125*exc2)*sin(am1) + ...
		0.5*exc2*(sin(am2) + 0.75*eccentricity*sin(am3));
shoot   = mod (shoot, 2*pi);

e1      = 1.0;
ic      = 0;

while ((abs(e1) > 1.e-12) && (ic <= 10)) 
	e1    = (shoot - am1 - eccentricity*sin(shoot)) / ...
			(1.0 - eccentricity*cos(shoot));
    shoot = shoot - e1;
    ic    = ic + 1;
end

if (ic >= 10)
    disp ('warning ** subroutine kepler did not converge in 10 iterations');
end

eccentric = shoot;

