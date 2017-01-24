function dxdt = rb_nutation_damper (time, x, flag, ext_torque, tensin, teninv, ...
                nd_axis, nd_inertia, nd_spring, nd_damper)
% dxdt = rigbody (time, x, flag, ext_torque, tensin, teninv)
%   rigbody  returns with the time derivative of a rigid body
%   dynamic equations
% inputs:
%   time
%       Time (s)
%   x
%       Attitude state vector: quaternions (4), angular velocity (rad/s)
%       (3), nutation damper angular momentum (1) and nutation damper angle
%       (1).
%    
%   flag
%       See ODEFILE
%   ext_torque
%       External torques acting on the spacecraft (Nm) including control 
%       and unmodel disturbances.
%   tensin
%       Inertia matrix (kg*m*m).
%   teninv
%       Inverse of the inertia matrix (1/kg*m*m)
%   nd_axis
%       Direction of the nutation damper rotation axis, in spacecraft
%       frame (unit vector).
%   nd_inertia
%       Nutation damper moment of inertia (kg*m*m)
%   nd_spring
%       Nutation damper spring coefficient (Nm/rd)
%   nd_damper
%       Nutation damper coefficient (Nm s/rd)
% outputs:
%   dxdt       - State vector time derivative
% 

% Valdemir Carrara, Sep, 1998.

q = x(1:4);
w  = x(5:7);
nd_momentum = x(8);     % nutation damper angular momentum
nd_angle = x(9);        % nutation damper angle

nd_ang_vel = (nd_momentum - nd_inertia*nd_axis'*w)/nd_inertia;  % eq. 3.249

xp = 0.5*sangvel(w)*q;
torque = ext_torque;

nd_momentum_dot = -nd_spring*nd_angle - nd_damper*nd_ang_vel; % eq. 3.252
nd_angle_dot = nd_ang_vel;  % eq. 3.253

wp = teninv*(torque - cross(w, tensin*w + nd_momentum*nd_axis) - ...
     nd_momentum_dot*nd_axis);      % eq. 3.255

dxdt = [xp; wp; nd_momentum_dot; nd_angle_dot];
