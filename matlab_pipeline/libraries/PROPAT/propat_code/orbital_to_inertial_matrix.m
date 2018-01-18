function [rmx_i_o] = orbital_to_inertial_matrix (kepel)
%  [rmx_i_o] = orbital_to_inertial_matrix (kepel)
%	The function orbital_to_inertial_matrix computes the rotation matrix
%	from orbital frame to inertial frame
%   The orbital frame is define as:
%      x_o : along the radius vector, from Earth center to satellite,
%            positive up
%      y_o : close to the velocity vector, but orthogonal to x_o, in
%            the orbital plane
%      z_o : normal to the orbital plane, along the orbital angular
%            momentum
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
%	rmx_i_o
%  		rotation matrix from orbital to inertial frame
%       r_inertial = rmx_i_o * r_orbital
%
% Authors:
%   Valdemir Carrara            Feb/12        Matlab

exc  = kepel(2);	% eccentricity

c1   = sqrt(1. - exc*exc);

%     rotation matrix from perigee to inertial

orb2iner = rotmaz(-kepel(4))*rotmax(-kepel(3))*rotmaz(-kepel(5));

%     Kepler's equation

E    = kepler(kepel(6), exc);   % excentric anomaly

sE   = sin(E);
cE   = cos(E);

r_ov_a = 1 - exc*cE;
cf   = (cE - exc)/r_ov_a;   % cosine of the true anomaly
sf   = c1*sE/r_ov_a;        % sine of the true anomaly

rmx_i_o = orb2iner*[cf, -sf, 0; sf, cf, 0; 0 0 1];
