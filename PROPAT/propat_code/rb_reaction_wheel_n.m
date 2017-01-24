function dxdt = rb_reaction_wheel_n (time, x, flag, ext_torque, tinerb, tinerbinv, ...
                n, rw_torque, an)
% dxdt = rb_reaction_wheel (time, x, flag, ext_torque, tinerb, tinerbinv, rw_torque, rw_iner)
%   rb_reaction_wheel returns with the time derivative of the dinamic
%   equations of a rigid bod attached to n reaction wheels at any direction
% inputs:
%   time
%       Time (s)
%   x
%       Attitude state vector: quaternions (4), angular velocity (rad/s) (3),
%       wheel's angular momentum (n)
%   flag
%       See ODEFILE
%   ext_torque
%       External torques acting on the spacecraft (Nm) including control 
%       and unmodelled disturbances. Vector(3)
%   tinerb
%       Inertia matrix (kg*m*m) of the non-rotating mass, equal to the
%       difference between the total satellite inertia (including wheels) 
%       and the reaction wheel's rotating mass.
%       tinerb = inertia - rw_iner*identity(3,3). Matrix(3,3)
%   tinerbinv
%       Inverse of the tinerb inertia matrix (1/kg*m*m). Matrix(3, 3)
%   n
%       Number of wheels
%   rw_torque
%       Torque in each reaction wheel (Nm). Colunm vector (n, 1)
%   an
%       Matrix (3, n) with the n unit vectors of the reaction wheel
%       rotation axes.
% outputs:
%   dxdt      
%       State vector time derivatives
% 

% Valdemir Carrara, Nov, 2013.

q = x(1:4);
w  = x(5:7);
hwn = an*x(8:7+n);
tqrw = an*rw_torque;

xp = 0.5*sangvel(w)*q;
wp = tinerbinv*(ext_torque + cross(tinerb*w + hwn, w) - tqrw);
hwnp = tqrw;

dxdt = [xp; wp; hwnp];

