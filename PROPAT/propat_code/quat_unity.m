function [q_unit] = quat_unity (q)
% [q_unit] = quat_unity (q)
%   To normalize the quaternion from a non-unity quaternion.
%   Normalization is based on euclidian norm:
%   q_unit = q/sqrt(q'*q);
%
% inputs:
%   q
%       Input quaternion (4)
%
% outputs:
%   q_unit
%       unity quaternion, such that:
%         q'*q = 1
% 
% Valdemir Carrara, May, 2015.

qnorm = sqrt(q'*q);
if (qnorm ~= 0)
    q_unit = q/qnorm;
else
    q_unit = [0; 0; 0; 1];
end
