function wns = rw_speed_n(x, rw_iner, an)
% function wns = rw_speed_n(x, rw_iner, an)
%   The function rw_speed_n gets the angular speed of the reaction wheels
%   given their angular momentum and rotation axis.
% inputs:
%   x
%       Attitude state vector: quaternions (4), angular velocity (rad/s) (3),
%       wheel's angular momentum (n)
%   rw_iner
%       Reaction wheel inertias around their rotation axis (kg*m*m).
%       Vector(n)
%   an
%       Matrix (3, n) with the n unit vectors of the reaction wheel
%       rotation axes.
% outputs:
%   wns      
%       Reaction wheel angular velocities. Vector(n).
%
% Valdemir Carrara, Sep, 2014.

wns = x(8:7+n)./rw_iner - an'*x(5:7);

