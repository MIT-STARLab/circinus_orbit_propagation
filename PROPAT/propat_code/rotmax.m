function [rot_mat] = rotmax (angle)
% [rot_mat] = rotmax (angle)
%   To obtain the rotation matrix around the X axis given the
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

rot_mat =  [1, 0, 0; 0, coan, sian; 0, -sian, coan];

  
