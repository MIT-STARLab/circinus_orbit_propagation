function [euler_angle, euler_vector] = rmxeuler (rot_mat)
% [euler_angle, euler_vector] = rmxeuler (rot_mat)
%   To transform a rotation matrix into Euler angle and vector  
% inputs:
%   rot_mat
%       rotation matrix (3, 3)
% outputs:
%   euler_angle
%       Euler angle, in radians.
%   euler_vector
%       Euler_vector (3x1) (unity vector)
%
% Valdemir Carrara, Feb, 2008

trace = rot_mat(1,1) + rot_mat(2,2) + rot_mat(3,3);
if trace == 3
    euler_angle = 0;
    euler_vector = [1; 0; 0];
elseif trace < -0.99999
    euler_angle = pi;
    w = [rot_mat(1,1); rot_mat(2,2); rot_mat(3,3)];
    euler_vector = sqrt((1+w)/2);
    if euler_vector(1) > 0.5
        euler_vector(2) = sign(rot_mat(1, 2))*euler_vector(2);
        euler_vector(3) = sign(rot_mat(3, 1))*euler_vector(3);
    elseif euler_vector(2) > 0.5
        euler_vector(1) = sign(rot_mat(1, 2))*euler_vector(1);
        euler_vector(3) = sign(rot_mat(2, 3))*euler_vector(3);
    else
        euler_vector(1) = sign(rot_mat(3, 1))*euler_vector(1);
        euler_vector(2) = sign(rot_mat(2, 3))*euler_vector(2);
    end
else
    euler_angle = acos((trace - 1) / 2);
    siang = sin(euler_angle);
    euler_vector = [rot_mat(2, 3) - rot_mat(3, 2);
                    rot_mat(3, 1) - rot_mat(1, 3);
                    rot_mat(1, 2) - rot_mat(2, 1)] /2 /siang;
end



