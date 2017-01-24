function [geoc] = spherical_to_rectangular(spherical)
% [geoc] = spherical_to_rectangular(spherical)
%	Function to transform rectangular terrestrial
%	geocentric coordinates in spherical coordinates
%	(longitude, geocentric latitude and distance).
%
% Inputs:
%	spherical
%		Geocentric coordinates vector:
%			1 = east longitude (rad)
%			2 = geocentric latitude (rad)
%			3 = geocentric distance (meters)
%
% Outputs:
%   geoc
%   		geocentric rectangular coordinates vector in meters
%           (1) geocentric position x (m)
%           (2) geocentric position y (m)
%           (3) geocentric position z (m)
%
% Authors:
%   Valdemir Carrara            May/09        Matlab

clat = cos(spherical(2));
geoc = [cos(spherical(1))*clat, sin(spherical(1))*clat, sin(spherical(2))]*spherical(3);
