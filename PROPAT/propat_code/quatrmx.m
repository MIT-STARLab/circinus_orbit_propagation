function [rot_mat] = quatrmx (quaternion)
% [rot_mat] = quatrmx (quaternion)
%   To compute the rotation matrix given the quaternions.
% inputs:
%   quaternion
%       attitude quaternions (4) Q = q1 i + q2 j + q3 k + q4
% outputs:
%   rot_mat
%       rotation matrix (3, 3)
%

% Valdemir Carrara, Sep. 1998

q1q    = quaternion(1)^2;
q2q    = quaternion(2)^2;
q3q    = quaternion(3)^2;
q4q    = quaternion(4)^2;

q12    = 2*quaternion(1)*quaternion(2);
q13    = 2*quaternion(1)*quaternion(3);
q14    = 2*quaternion(1)*quaternion(4);
q23    = 2*quaternion(2)*quaternion(3);
q24    = 2*quaternion(2)*quaternion(4);
q34    = 2*quaternion(3)*quaternion(4);

rot_mat = [q1q - q2q - q3q + q4q, q12 + q34, q13 - q24;
           q12 - q34, q2q + q4q - q1q - q3q, q23 + q14;
           q13 + q24, q23 - q14, q3q + q4q - q1q - q2q];

