function [q_mat] = quat_matrix (q)
% [q_mat] = quat_matrix (q)
%   To obtain the quaterniom product matrix, such that
%   quat_matrix(Q)*P = quat_prod(Q, P)
%
% inputs:
%   q              - Input quaternion
%
% outputs:
%   q_mat          - Quaternion product matrix (4 x 4)
% 
% Valdemir Carrara, Jan, 2015.

q_mat = [ q(4), -q(3),  q(2),  q(1); ...
          q(3),  q(4), -q(1),  q(2); ...
         -q(2),  q(1),  q(4),  q(3); ...
         -q(1), -q(2), -q(3),  q(4)];
