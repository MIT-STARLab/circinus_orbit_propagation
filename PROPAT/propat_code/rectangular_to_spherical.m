function [spherical] = rectangular_to_spherical (geoc)
% [spherical] = rectangular_to_spherical (geoc)
%	Function to transform rectangular terrestrial
%	geocentric coordinates in spherical coordinates
%	(longitude, geocentric latitude and distance).
%
% Inputs:
%   geoc
%   		geocentric rectangular coordinates vector in meters
%           (1) geocentric position x (m)
%           (2) geocentric position y (m)
%           (3) geocentric position z (m)
%
% Outputs:
%	spherical
%		Geocentric coordinates vector:
%			1 = east longitude (rad)
%			2 = geocentric latitude (rad)
%			3 = geocentric distance (meters)
%
% Authors:
%   Valdemir Carrara            May/09        Matlab

px = geoc(1);
py = geoc(2);
pz = geoc(3);
ws = px*px + py*py;
rw = sqrt(ws + pz *pz);
lg = atan2(py, px);
lt = atan2(pz, sqrt(ws));
spherical = [lg, lt, rw];
