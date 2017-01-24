function [geoc] = sph_geodetic_to_geocentric (spgd)
% [geoc] = sph_geodetic_to_geocentric (spgd)
%
%	Function to transform spherical geodetic coordinates
%	(longitude, latitude and altitude) in rectangular
%	terrestrial geocentric coordinates
%
% Inputs:
%	spgd
%		Geodetic coordinates
%			(1) east longitude (rad)
%			(2) geodetic latitude (rad)
%			(3) geodetic altitude (meters)
%
% Outputs:
%   sph_geodetic_to_geocentric
%   		geocentric rectangular coordinates in meters
%           (1) geocentric position x (m)
%           (2) geocentric position y (m)
%           (3) geocentric position z (m)
%
% Authors:
%	Helio K. Kuga				august/83		V. 1.0
%	Valdemir Carrara			08/05			C version
%   Valdemir Carrara            March/09        Matlab

EARTH_FLATNESS	= 0.0033528131778969144; % Flattening factor = 1./298.257
EARTH_RADIUS	= 6378139.;				 % Earth's radius in meters

al = spgd(1); 			% east longitude
h  = spgd(3);			% heigth

sf =   sin(spgd(2));	% geodetic latitude
cf =   cos(spgd(2));
gama = (1. - EARTH_FLATNESS);
gama = gama*gama;
s =  EARTH_RADIUS / sqrt (1. - (1. - gama)*sf*sf);
g1 = (s + h) * cf;
geoc = [g1 * cos(al), g1 * sin(al), (s * gama + h) * sf];

