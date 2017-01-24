function [rot_mat] = ezxzrmx (euler_angles)
% [rot_mat] = ezxzrmx (euler_angles)
%   To transform Euler angles from a Z-X-Z rotation 
%   into the rotation matrix.
% inputs:
%   euler_angles
%       Euler angles from a Z-X-Z rotation, in radians 
%       (3).
% outputs:
%   rot_mat
%       rotation matrix (3, 3)
%

% Valdemir Carrara, Sep, 1998

rot_mat = rotmaz (euler_angles(3))*rotmax (euler_angles(2))*rotmaz (euler_angles(1));
