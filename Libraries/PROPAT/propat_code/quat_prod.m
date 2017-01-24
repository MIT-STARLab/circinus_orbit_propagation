function [quaternion] = quat_prod (quat1, quat2)
% [quaternion] = quat_prod (quat1, quat2)
%   To compute the product of two quaternions.
% inputs:
%   quat1
%       first quaternion (4) Q = q1 i + q2 j + q3 k + q4
%       second quaternion (4) P = p1 i + p2 j + p3 k + p4
% outputs:
%   quaternion
%       quaternion product (4) R = Q X P
%
% Obs:
%   The resulting quaternion is given equivalently by
%   quaternion = rmxquat(quatrmx(quat2)*quatrmx(quat1))
%   (see the transform sequence)

% Valdemir Carrara, Jan. 2015
v1 = quat1(1:3);
v2 = quat2(1:3);
quaternion = [quat1(4)*v2 + quat2(4)*v1 + cross(v1, v2); ...
    quat1(4)*quat2(4) - dot(v1, v2)];

