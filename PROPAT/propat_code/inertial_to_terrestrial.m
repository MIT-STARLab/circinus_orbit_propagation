function [xterrestrial] = inertial_to_terrestrial (tesig, xi)
% [xterrestrial] = inertial_to_terrestrial (tesig, xi)
%	The function inertial_to_terrestrial transforms geocentric
%	inertial state vector into geocentric
%	terrestrial coordinates (referred to
%	Greenwich).
%
% Input:
%	tesig
%		Greenwich sidereal time in radians.
%	xi
%		geocentric inertial position vector.
%       (1) inertial geocentric position x (m)
%       (2) inertial geocentric position y (m)
%       (3) inertial geocentric position z (m)
%       (4) inertial geocentric velocity x (m/s)
%       (5) inertial geocentric velocity y (m/s)
%       (6) inertial geocentric velocity z (m/s)
%
% Output:
%	xterrestrial
%		corresponding geocentric terrestrial vector.
%
% Authors:
%	Helio/Valder/Valdemir-aug. 1981 - version 1.0
%	Helio		-july 1989 - version 1.1
%	Valdemir Carrara		july 2005		(C version)
%   Valdemir Carrara            March/09        Matlab

xterrestrial = [xi(1:3); xi(4:6)]*rotmaz(tesig)';
xterrestrial = [xterrestrial(1,:) xterrestrial(2,:)];


