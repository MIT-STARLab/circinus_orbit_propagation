function dxdt = pndbody (time, x, flag, ext_torque, tensin, teninv, tinut, cmat, ...
                    mag_moment, magnetic_field)
% dxdt = pndbody (time, x, flag, ext_torque, tensin, teninv, tinut, cmat)
%   pndbody  returns with the time derivative of dynamic equations 
%   for a rigid body with a passive nutation damper
% inputs:
%   time       - Time (s)
%   x          - Attitude state vector: quaternions (1:4), angular
%                velocity (rad/s) (5:7), and nutation damper 
%                angular momentum (8:10)
%   flag       - See ODEFILE
%   ext_torque - External torques acting on the spacecraft (Nm)
%                including control and disturbances.
%   tensin     - Inertia matrix of the rigid body (kg*m*m).
%   teninv     - Inverse of the rigid body inertia matrix (1/kg/m/m).
%   tinut      - 3 component vector of the nutation damper moments of 
%                inertia (kg m m), in directionx x, y and z.
%   cmat       - Diagonal matrix of the damper coeficients (Nms/rd).
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

q  = x(1:4);
w  = x(5:7);
h  = x(8:10);

xp = 0.5*sangvel(w)*q;
wo = h./tinut;
hp = cmat*(w - wo);

torque = ext_torque;
if nargin > 6
    if nargin < 8
        disp('magnetic_field required')
        stop
    end
    torque = torque + cross(mag_moment, quatrmx(q)*magnetic_field);
end
wp = teninv*(cross(tensin*w + h, w) - hp + torque);
xop = 0.5*sangvel(wo)*x(11:14);

dxdt = [xp; wp; hp; xop];
