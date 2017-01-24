function [q_conj] = quat_inv (q)
% [q_conj] = quat_inv (q)
%   To obtain the inverse quaternion of a given transform.
%   The inverse quaternion is equal to its conjugate
%   The inverse quaternion is such that quat_prod(q, q_conj)= [0 0 0 1]
%
% inputs:
%   q
%       Input quaternion (4)
%
% outputs:
%   q_conj
%       quaternion inverse, defined by:
%         [-q(1); -q(2); -q(3); q(4)]
% 
% Valdemir Carrara, Jan, 2015.

q_conj = [-q(1:3); q(4)];

