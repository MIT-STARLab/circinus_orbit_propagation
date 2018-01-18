function [xinert] = terrestrial_to_inertial (tesig, xt)
% [xinert] = terrestrial_to_inertial (tesig, xt)
%	The function terrestrial_to_inertial transforms geocentric
%	terrestrial coordinates referred to Greenwich into
%	geocentric inertial coordinates.
%
% Input:
%	tesig
% 		Greenwich sidereal time in radians (See function gst).
%	xt
% 		geocentric terrestrial position vector.
%       (1) terrestrial geocentric position x (m)
%       (2) terrestrial geocentric position y (m)
%       (3) terrestrial geocentric position z (m)
%       (4) terrestrial geocentric velocity x (m/s)
%       (5) terrestrial geocentric velocity y (m/s)
%       (6) terrestrial geocentric velocity z (m/s)
%
% Output:
%	xinert
%		inertial geocentric state vector.
%
%Authors:
%	Helio/Valder/Valdemir-aug. 1981 - version 1.0
%	Helio		-july 1989 - version 1.1
%	Valdemir Carrara		july 2005		(C version)
%   Valdemir Carrara            March/09        Matlab

xinert = [xt(1:3); xt(4:6)]*rotmaz(-tesig)';
xinert = [xinert(1,:) xinert(2,:)];
