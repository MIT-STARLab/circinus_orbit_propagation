function wns = rw_speed(w, hwn, rw_iner)
% function wns = rw_speed(w, hwn, rw_iner)
%   The function rw_speed gets the angular speed of the reaction wheels given
%   by their angular momentum.
% inputs:
%   w
%       Satellite angular velocity (rad/s), taken from x(5:7) where x is the
%       attitude state vector. Vector(3)
%   hwn
%       Reaction wheel's angular momentum. Each wheel has its own angular
%       momentum. They are stored in a single vector hwn, aligned with the
%       x, y, and z axis (same as the wheel's axis), taken from x(8:10).
%       Vector(3)
%   rw_iner
%       Reaction wheel inertia around the rotation axis (kg*m*m).
%       All the 3 reaction wheels should have the same inertia. Their
%       rotation axis should be aligned to the satellite axis (x, y and z).
%       Scalar.
% outputs:
%   wns      
%       Reaction wheel's angular velocities
%
% Valdemir Carrara, Nov, 2013.

wns = hwn/rw_iner - w;
