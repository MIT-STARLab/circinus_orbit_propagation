function [gwst] = gst (diju, time)
% [gwst] = gst (diju, time)
%   The function gst furnishes the greenwich aparent mean 
%   sidereal time referred to the J2000.0 equator and equinox.
% inputs:
%   diju
%       Modified Julian Date in days, referred to 1950.0.
%   time
%       UT1 time complement in seconds.
% outputs:
%   gwst
%       Greenwich aparent sidereal time in radians
%
% Valdemir Carrara, Apr, 2003
%

tsj = (diju-18262.5)/36525;
tsgo = (24110.54841 + (8640184.812866 + 9.3104e-2*tsj - 6.2e-6*tsj*tsj)*tsj)*pi/43200;
tetp = 7.292116e-5;		% velocidade angular da Terra (rd/s)
gwst = mod(tsgo + time*tetp, 2*pi);

%      if (gwst<0) gwst = gwst + 2*pi

