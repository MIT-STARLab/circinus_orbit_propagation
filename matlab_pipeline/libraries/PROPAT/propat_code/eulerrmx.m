function [rot_mat] = eulerrmx (euler_angle, euler_vector)
% [rot_mat] = eulerrmx (euler_angle, euler_vector)
%   To transform Euler angle and vector  
%   into the rotation matrix.
% inputs:
%   euler_angle
%       Euler angle, in radians.
%   euler_vector
%       Euler_vector (3x1) (unity vector)
% outputs:
%   rot_mat
%       rotation matrix (3, 3)
%

% Valdemir Carrara, Feb, 2008

coan = cos(euler_angle);
sian = sin(euler_angle);
com1 = 1. - coan;

    rot_mat = coan*eye(3) + com1*euler_vector*euler_vector' - ...
        sian*cross_matrix(euler_vector);

