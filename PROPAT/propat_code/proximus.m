function [angle] = proximus (angleinp, angleprox)
% [angle] = proximus (angleinp, angleprox)
%   returns with angleinp in the nearest position from
%   angleprox
% inputs:
%   angleinp
%       input angle, in radians
%   angleprox
%       given angle to compute variable angle in rad
% outputs:
%   angle
%       equals to angleinp, close to angleprox, in radians
%

% Valdemir Carrara, Oct. 1998

test = 2*pi;
angle = angleprox + mod ((angleinp-angleprox+test/2), test)-test/2;

%arg = mod (angleinp-angleprox, test);
%if arg <= 0 
%   arg = arg + test
%end
%		 IF (ARG.GT.PI)   ARG  = ARG - PIV2
%angle = angleprox + arg;

