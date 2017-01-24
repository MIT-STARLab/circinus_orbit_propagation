function [rot_mat] = rotmaz (angle)
% [rot_mat] = rotmaz (angle)
%   To obtain the rotation matrix around the Z axis given the
%   rotation angle.
% inputs:
%   angle
%       rotation angle, in radians.
% outputs:
%   rot_mat
%       rotation matrix (3, 3)
%

% Valdemir Carrara, Sep, 1998

coan    =  cos(angle);
sian    =  sin(angle);

rot_mat =  [coan, sian, 0; -sian, coan, 0; 0, 0, 1];

