function [euler_angle] = quatexyz (quaternion)
% [euler_angle] = quatexyz (quaternion)
%   Tto compute the Euler angles from a X-Y-Z rotation 
%   given the quaternions.
% inputs:
%   quaternion
%       attitude quaternions
% outputs:
%   euler_angle
%       Euler angles (X-Y-Z) in radians
%

% Valdemir Carrara, Sep. 1998

% compute size of quaternions:
[m, n] = size(quaternion);
euler_angle = [];

for colin=1:n
	% compute the rotation matrix
	rot_mat = quatrmx (quaternion(:, colin));
	% obtain the Euler angles
	euler_angle = cat(2, euler_angle, rmxexyz (rot_mat));
end
