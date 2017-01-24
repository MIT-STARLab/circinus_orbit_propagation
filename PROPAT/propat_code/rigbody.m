function dxdt = rigbody (time, x, flag, ext_torque, tensin, teninv, ...
                mag_moment, magnetic_field)
% dxdt = rigbody (time, x, flag, ext_torque, tensin, teninv)
%   rigbody  returns with the time derivative of a rigid body
%   dynamic equations
% inputs:
%   time
%       Time (s)
%   x
%       Attitude state vector: quaternions (4), angular velocity (rad/s) (3).
%   flag
%       See ODEFILE
%   ext_torque
%       External torques acting on the spacecraft (Nm) including control 
%       and unmodel disturbances.
%   tensin
%       Inertia matrix (kg*m*m).
%   teninv
%       Inverse of the inertia matrix (1/kg*m*m)
%   mag_moment
%       (optional) vector 3x1 of the satellite magnetic moment, to 
%       compute the magnetic torque in Ampere*m.
%   magnetic_field
%       vector (3x1) of the Earth's magnetic field in Tesla (required if 
%       mag_moment was provided), is inertial reference frame.
% outputs:
%   dxdt       - State vector time derivative
% 

% Valdemir Carrara, Sep, 1998.

q = x(1:4);
w  = x(5:7);
xp = 0.5*sangvel(w)*q;
torque = ext_torque;
if nargin > 6
    if nargin < 8
        disp('magnetic_field required')
        stop
    end
    torque = torque + cross(mag_moment, quatrmx(q)*magnetic_field);
end
wp = teninv*(cross(tensin*w, w) + torque);

dxdt = [xp; wp];
