function [rot_mat] = exyzrmx (euler_angles)
% [rot_mat] = exyzrmx (euler_angles)
%   To transform Euler angles from a X-Y-Z rotation 
%   into the rotation matrix.
% inputs:
%   euler_angles
%       Euler angles from a X-Y-Z rotation, in radians (3)
% outputs:
%   rot_mat
%       rotation matrix (3, 3)
%

% Valdemir Carrara, Sep, 1998

rot_mat = rotmaz (euler_angles(3))*rotmay (euler_angles(2))*rotmax (euler_angles(1));
