% nutation_damper
%
%       Program to show how to use PROPAT
%       Type demo_propat from the Matlab prompt

% Inputs:
    
% Attitude elements in Euler angles of a 3-1-3 (z-x-z) rotation
eulzxz = [0, 0, 0]'*pi/180;   % converted from degrees to radians

% Attitude in quaternions
quat = ezxzquat(eulzxz);        % converted from Euler angles

% Angular velocity vector in body frame:
w_ang = [4, 0, 6]';           % in radians/sec
    
% Propagation time in seconds:
tstart = 0;     % initial time (sec)
tstep = 1;    % step time (sec)
tend = 600;     % end time (20 minutes)

% Inertia matrix of axis-symetric satellite:
sat_iner = [12 0 0; 0 12 0; 0 0 20];      % in kg*m*m

% Nutation damper parameters:
nd_axis = [1; 0; 0];    % nutation damper axis
nd_inertia = 0.01;  % nutation damper inertia
nd_spring = 0.16;    % nutation damper spring coefficient
%nd_damper = 0.08;   % nutation damper coefficient critical damping
%nd_damper = 0.1;   % nutation damper coefficient
%nd_damper = 0.01;   % nutation damper coefficient
%nd_damper = 0.0;   % nutation damper coefficient
nd_damper = 0.002;   % nutation damper coefficient

% Reduced inertia matrix: (eq. 3.257)
iner = sat_iner - nd_inertia*nd_axis*nd_axis';

% Inverse inertia matrix:
invin = inv(iner);

% Nutation damper initial conditions
nd_angle = 0;
nd_ang_vel = 0;
nd_momentum = nd_inertia*(nd_axis'*w_ang + nd_ang_vel); % eq. 3.249

% External torques
ext_torq = [0; 0; 0];

% ODE solver precision:
options = odeset('abstol', 1e-6, 'reltol', 1e-6);

% Initial vectors
time = tstart;          % to store time
euler = eulzxz*180/pi;  % Euler angles
omeg = w_ang;           % Angular velocity
omeg_mag = sqrt(w_ang'*w_ang);  
ang_momentum = iner*w_ang + nd_momentum*nd_axis;    % eq. 3.254
ang_mom_mod = sqrt(ang_momentum'*ang_momentum); % angular momentum magnitude
nut_angle = acos(ang_momentum(3)/ang_mom_mod);
body_cone_ang = atan(iner(3,3)/iner(1,1)*tan(nut_angle));
nd_omeg = nd_ang_vel;
nd_teta = nd_angle;
nutat_angle = nut_angle;
in_ang_mom = quatrmx(quat)*ang_momentum;
ang_mod = ang_mom_mod;
ene_cinetica = w_ang'*(iner*w_ang/2 + nd_inertia*nd_axis*nd_ang_vel) + nd_ang_vel*nd_inertia*nd_ang_vel/2;
ene_cin = ene_cinetica;

% Attitude propagation
for t = tstart:tstep:tend

    % Initial attitude vector:
    att_vec = [quat; w_ang; nd_momentum; nd_angle]';     % Transposed

    % ODE Solver parameters
    tspan = [t, t+tstep/2, t+tstep];
    
    % Numeric integration (ODE45)
    [T, Y] = ode45('rb_nutation_damper', tspan, att_vec, options, ...
             ext_torq, iner, invin, nd_axis, nd_inertia, nd_spring, nd_damper);

    att_vec = Y(3, :)';         % propagated attitude vector
    quat = att_vec(1:4);        % propagated quaternion
	w_ang = att_vec(5:7);       % propagated angular velocity
    nd_momentum = att_vec(8);   % nutation damper angular momentum
    nd_angle = att_vec(9);      % nutation damper angle
    nd_ang_vel = (nd_momentum - nd_inertia*nd_axis'*w_ang)/nd_inertia;  % eq. 3.249
    ang_mom = iner*w_ang + nd_momentum*nd_axis;   % eq. 3.254
    ang_mom_mod = sqrt(ang_mom'*ang_mom); %angular momentum magnitude
    nut_angle = acos(ang_mom(3)/ang_mom_mod);
    ene_cinetica = w_ang'*(iner*w_ang/2 + nd_inertia*nd_axis*nd_ang_vel) + nd_ang_vel*nd_inertia*nd_ang_vel/2;

    eulzxz = quatezxz(quat);    % euler angles

    % Store data to be plotted
    time = cat(2, time, t);
    euler = cat(2, euler, eulzxz*180/pi);
    omeg = cat(2, omeg, w_ang);
    ang_momentum = cat(2, ang_momentum, ang_mom); 
    nd_omeg = cat(2, nd_omeg, nd_ang_vel);
    nutat_angle = cat(2, nutat_angle, nut_angle);
    body_cone_ang = cat(2, body_cone_ang, atan(iner(3,3)/iner(1,1)*tan(nut_angle)));
    in_ang_mom = cat(2, in_ang_mom, quatrmx(quat)'*ang_mom);
    ang_mod = cat(2, ang_mod, ang_mom_mod);
    ene_cin = cat(2, ene_cin, ene_cinetica);
    omeg_mag = cat(2, omeg_mag, sqrt(w_ang'*w_ang));
    nd_teta = cat(2, nd_teta, nd_angle);
end

close all

% Output visualization
%plot(time, euler);
%xlabel('Time (s)')
%ylabel('Euler angles (3-1-3) (deg)')
%title('Attitude in Euler angles')

figure
plot(time, omeg);
xlabel('Time (s)')
ylabel('Angular velocity (rad/s)')
title('Attitude angular velocity')

figure
plot(time, omeg_mag);
xlabel('Time (s)')
ylabel('Angular velocity magnitude (rad/s)')
title('Angular velocity magnitude')

%figure
%plot(time, ang_momentum);
%xlabel('Time (s)')
%ylabel('Angular momentum (Nms)')
%title('Angular momentum')

figure
plot(time, in_ang_mom);
xlabel('Time (s)')
ylabel('Angular momentum (Nms)')
title('Angular momentum - Inertial frame')

figure
plot(time, ang_mod);
xlabel('Time (s)')
ylabel('Angular momentum magnitude (Nms)')
title('Angular momentum magnitude')

figure
plot(time, nd_omeg);
xlabel('Time (s)')
ylabel('Nutation damper speed (rd/s)')
title('Nutation damper angular velocity')

figure
plot(time, nd_teta*180/pi);
xlabel('Time (s)')
ylabel('Nutation damper displacement (deg)')
title('Nutation damper angular displacement')

figure
plot(time, nutat_angle*180/pi);
xlabel('Time (s)')
ylabel('Nutation angle (deg)')
title('Nutation angle')

figure
plot(time, body_cone_ang*180/pi);
xlabel('Time (s)')
ylabel('Body cone angle (deg)')
title('Body cone angle')

figure
plot(time, ene_cin);
xlabel('Time (s)')
ylabel('Kinetic energy (J)')
title('Kinetic energy')




    