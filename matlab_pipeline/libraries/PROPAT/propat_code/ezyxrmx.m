function [rot_mat] = ezyxrmx (euler_angles)
% [rot_mat] = ezxyrmx (euler_angles)
%   To transform Euler angles from a Z-Y-X rotation 
%   into the rotation matrix.
% inputs:
%   euler_angles
%       Euler angles from a Z-Y-X rotation, in radians 
%       (3).
% outputs:
%   rot_mat
%       rotation matrix (3, 3)
%
% Valdemir Carrara, Feb, 2009

rot_mat = rotmax (euler_angles(3))*rotmay (euler_angles(2))*rotmaz (euler_angles(1));
