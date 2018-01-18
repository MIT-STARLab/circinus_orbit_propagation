function [mgfield] = mag_field (mjd, sat_t)
% function [mgfield] = mag_field (mjd, dayf, satp)
%	This function calculates the Earth's magnetic field by calling the
%   function igrf_field.
%
% Input:
%	mjd
%       Modified Julian Date in days, referred to 1950.0.
%   sat_t
%       Satellite position in geocentric terrestrial coordinates, in meters.
%
% Output:
%   mgfield
%       Earth's magnetic field in Tesla, in geocentric terrestrial
%       coordinates
%
% Authors:
%   Valdemir Carrara            July/14        Matlab

sphe = rectangular_to_spherical(sat_t);
alt = sphe(3)/1000;
elong = sphe(1);
colat = pi/2 - sphe(2);
ano = djm_inv(mjd);
mjdo = djm(1, 1, ano(3));     % modified julian date of 1/1/year
mjd1 = djm(1, 1, ano(3)+1);   % modified julian date of 1/1/(year+1)
year_frac = ano(3) + (mjd - mjdo)/(mjd1 - mjdo) ;  % year and fraction

field = 1.e-9*igrf_field (year_frac, alt, colat, elong);  % cmt em Tesla, no NED

mgfield = rotmay(sphe(2) + pi/2)*rotmaz(-elong)*field'; % cmt no sistema terrestre

 