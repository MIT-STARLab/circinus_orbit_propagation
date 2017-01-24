function [quaternions] = exyzquat (euler_angles)
% [quaternions] = ezxzquat (euler_angles)
%   To transform Euler angles from a X-Y-Z rotation
%   into quaternions.
% inputs:
%   euler_angles
%       Euler angles from a X-Y-Z rotation, in radians (3)
% outputs:
%   quaternions
%       quaternions corresponding to the Euler angles 
%

% Valdemir Carrara, Sep 1998

rot_mat = exyzrmx (euler_angles);
      
quaternions = rmxquat (rot_mat);

