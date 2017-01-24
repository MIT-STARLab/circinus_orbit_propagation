function [geodetic] = geocentric_to_sph_geodetic (geoc)
% [geodetic] = geocentric_to_sph_geodetic (geoc)
%	Function to transform rectangular terrestrial
%	geocentric coordinates in spherical geodetic
%	coordinates (longitude, latitude and altitude).
%
% Inputs:
%   geoc
%   		geocentric rectangular coordinates vector in meters
%           (1) geocentric position x (m)
%           (2) geocentric position y (m)
%           (3) geocentric position z (m)
%
% Outputs:
%	geodetic
%		Geodetic coordinates vector:
%			1 = east longitude (rad)
%			2 = geodetic latitude (rad)
%			3 = geodetic altitude (meters)
%
% Authors:
%	Helio K. Kuga				august/83		V. 1.0
%	Valdemir Carrara			08/05			C version
%   Valdemir Carrara            March/09        Matlab

EARTH_FLATNESS	= 0.0033528131778969144; % Flattening factor = 1./298.257
EARTH_RADIUS	= 6378139.;				 % Earth's radius in meters

px = geoc(1);
py = geoc(2);
pz = geoc(3);
gama = (1. - EARTH_FLATNESS);
gama = gama*gama;
eps  = 1. - gama;
as = EARTH_RADIUS*EARTH_RADIUS;
ws = px*px + py*py;
zs = pz*pz;
zs1 = gama*zs;
e = 1.;

%   maximum error in altitude dh

det = 0.01*sqrt((2/3)/EARTH_RADIUS);
de = 2*det;

while (de > det) 
	alf = e/(e - eps);
	zs2 = zs1*alf*alf;
	de  = 0.5*(ws + zs2 - as*e*e)/((ws + zs2*alf)/e);
	e = e + de;
end

ss = (e - eps);
ss = eps*zs/as/ss/ss;
ro = EARTH_RADIUS*((1. + ss)/(2. + ss) + 0.25*(2. + ss));
rw = e*ro;

arl = atan2(py, px);
sf = pz/(rw - eps*ro);
cf = sqrt(ws)/rw;
anorma = sqrt(sf*sf + cf*cf);
arf = asin(sf/anorma);
geodetic = [arl, arf, rw - ro];
