function [q_norm] = quat_norm (q)
% [q_norm] = quat_norm (q)
%   To normalize the quaternion from a non-unity quaternion.
%   The scalar component (q4) remains unchanged.
%
% inputs:
%   q
%       Input quaternion (4)
%
% outputs:
%   q_unit
%       unity quaternion, such that:
%         q*q' = 1
% 
% Valdemir Carrara, May, 2015.

v     = q(1:3);
e     = q(4);
if (e > 1)
    e = 1;
end
if (e < -1)
    e = -1;
end
vnorm = v'*v;
enorm = e*e;

if (vnorm ~= 0)
    enorm    = sqrt((1 - enorm)/vnorm);
    q_norm = [enorm*v; e];
else
    q_norm = [0; 0; 0; 1];
end
