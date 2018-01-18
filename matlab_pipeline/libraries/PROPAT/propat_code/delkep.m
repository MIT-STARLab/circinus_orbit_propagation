function [deltakep] = delkep (kep_el)
% [deltakep] = delkep (kep_el)
%	Function delkep calculates the rate of
%	variation of keplerian elements, considering only
%	J2 and J4.
%
% Input:
%	kep_el
% 		vector with the keplerian elements:
%		(1) - semimajor axis of the orbit in meters.
%		(2) - eccentricity.
%		(3) - inclination in radians.
%		(4) - right ascension of ascending node in radians.
%		(5) - argument of perigee in radians.
%		(6) - mean anomaly in radians.
%       Obs: 4,5 and 6 are not used
%
% Output:
%	deltakep
%		(1) = 0
%		(2) = 0
%		(3) = 0
%		(4) - variation rate of the right ascension of
%		      ascending node, in radians/second.
%		(5) - variation rate of the argument of perigee,
%			  in radians/second.
%		(6) - variation rate of the mean anomaly, in
%			  radians/second.
%
% Authors:
%	Valder M. de Medeiros  	september/81 	version 1.0
%	Valdemir Carrara 		july 2005		(C Version)
%   Valdemir Carrara            March/09        Matlab

EARTH_RADIUS	= 6378139.;				% Earth's radius in meters
EARTH_GRAVITY	= 3.9860064e+14;		% Earth's gravitational constant (m**3/s**2)
J_2 			=  1.0826268362e-3;		% = 484.16544e-6 * SQRT(5.e0)
J_4 			= -1.62336e-6;			% = -0.54112e-6 * 3e0

seix = kep_el(1);
exce = kep_el(2);
exc2 = exce*exce;
eta2 = 1. - exc2;
eta1 = sqrt(eta2);
teta = cos(kep_el(3));
tet2 = teta*teta;
tet4 = tet2*tet2;
aux0 = sqrt(EARTH_GRAVITY/(seix*seix*seix));
plar = EARTH_RADIUS/(seix*eta2);
pla2 = plar*plar;
gam2 = 0.5*J_2*pla2;
gam4 = -0.375*J_4*pla2*pla2;

deltakep = [0, 0, 0, 0, 0, 0];

deltakep(4) = aux0*teta*(3.*gam2*(-1. + 0.125*gam2*(9.*eta2 + 12.*eta1 - ...
	   5. - (5.*eta2 + 36.*eta1 + 35.)*tet2)) + ...
	   1.25*gam4*(5. - 3.*eta2)*(3. - 7.*tet2));
deltakep(5) = aux0*(1.5*gam2*((5.*tet2 - 1.) + ...
	   0.0625*gam2*(25.*eta2 + 24.*eta1 - ...
	   35. + (90. - 192.*eta1 - 126.*eta2)*tet2 + ...
	   (385. + 360.*eta1 + 45.*eta2)*tet4)) + ...
	   0.3125*gam4*(21. - 9.*eta2 + (-270. + 126.*eta2)*tet2 + ...
	   (385. - 189.*eta2)*tet4));
deltakep(6) = aux0*(1. + eta1*(1.5*gam2*((3.*tet2 - 1.) + ...
	   0.0625*gam2*(16.*eta1 + 25.*eta2 - 15. + ...
	   (30. - 96.*eta1 - 90.*eta2)*tet2 + ...
	   (105. + 144.*eta1 + 25.*eta2)*tet4)) + ...
	   0.9375*gam4*exc2*(3. - 30.*tet2 + 35.*tet4)));

