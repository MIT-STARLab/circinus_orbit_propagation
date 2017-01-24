function [gra_torq] = gg_torque (ggamp, inert, vertic)
% [gra_torq] = gg_torque (ggamp, inert, vertic)
%   Function to evaluate the gravity gradient torque
% inputs:
%   ggamp     
%      3*Gm/(R^3), where Gm is the Earth's gravitational constant
%      (Gm = 3.9860064 E+14 m^3/s^2) and R is the geocentric 
%      distance in meters
%   inert
%      Inertia matrix in kgm^2, in satellite coordinates
%   vertic
%      Local vertical unit vector (towards zenith) in satellite
%      coordinates
%
% outputs:
%   gra_torq 
%      Gravity gradient torque (spacecraft reference coordinates)
%      in Nm
%

% Valdemir Carrara, Sep 1999

gra_torq = ggamp*cross(vertic, inert*vertic);

