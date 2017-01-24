function [euler_angle] = quatezxz (quaternion)
% [euler_angle] = quatezxz (quaternion)
%   To compute the Euler angles from a Z-X-Z rotation 
%   given the quaternions.
% inputs:
%   quaternion
%       attitude quaternions.
% outputs:
%   euler_angle
%       Euler angles (Z-X-Z) in radians
%

% Valdemir Carrara, Sep. 1998

% compute size of quaternions:
[m, n] = size(quaternion);
euler_angle = [];

for colin=1:n
   % compute the rotation matrix
   rot_mat = quatrmx (quaternion(:, colin));
	% obtain the Euler angles
	euler_angle = cat(2, euler_angle, rmxezxz (rot_mat));
end

