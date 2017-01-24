function [rot_mat] = rotmay (angle)
% [rot_mat] = rotmay (angle)
%   To obtain the rotation matrix around the Y axis given the
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

rot_mat =  [coan, 0, -sian; 0, 1, 0; sian, 0, coan];

