% demo_propat
%
%       Program to show how to use PROPAT
%       Type demo_propat from the Matlab prompt

% Inputs:
% Orbit keplerian elements:
kepel = [7000000, 0.01, 98, 0, 0, 0];   % see function delkep
% Orbit state vector:
stat = kepel_statvec(kepel);
    
% Attitude elements in Euler angles of a 3-1-3 (z-x-z) rotation
eulzxz = [30, 50, 20]'*pi/180;   % converted from degrees to radians

% Attitude in quaternions
quat = ezxzquat(eulzxz);        % converted from Euler angles

% Angular velocity vector in body frame:
w_ang = [0.1, 0, 0.5]';           % in radians/sec
    
% Compute the variations in keplerian elements due to the Earth oblateness
delk = delkep(kepel);

% Ephemerides date in Modified Julian date:
year = 2009;
mjd = djm(13, 4, year);     % Format (day, month, year)
mjdo = djm(1, 1, year);     % modified julian date of 1/1/year
mjd1 = djm(1, 1, year+1);   % modified julian date of 1/1/(year+1)
year_frac = year + (mjd - mjdo)/(mjd1 - mjdo);  % year and fraction

% Ephemerides time:
dfra = time_to_dayf (10, 20, 0);    % UTC time in (hour, minute, sec)

% Propagation time in seconds:
tstart = 0;     % initial time (sec)
tstep = 0.5;    % step time (sec)
tend = 600;     % end time (10 minutes)

% Inertia matrix of axis-symetric rigid body:
iner = [8 0 0; 0 8 0; 0 0 12];      % in kg*m*m

% Inverse inertia matrix:
invin = inv(iner);

% Initial control torque:
contq = [0 0 0]';

% Magnetic moment torque flag and moment:
flag_mag = 0;   % 1=compute magnetic moment / 0=discard magnetic moment
mag_mon = [0; 0; 0.1];      % in A.m

% ODE solver precision:
options = odeset('abstol', 1e-4, 'reltol', 1e-4);

% Initial vectors
time = tstart;          % to store time
euler = eulzxz*180/pi;  % Euler angles
omeg = w_ang;           % Angular velocity
orbit = stat';          % Orbit elements (state vector)
keorb = kepel';         % Orbit elements (keplerian)

% Attitude and orbit propagation
for t = tstart:tstep:tend

    % Orbit propagation
    kep2 = kepel + delk*t;
    
    % To convert from keplerian elements to state vector (if needed)
    stat = kepel_statvec(kep2);

    % Perturbation torques:
    ambt = [0 0 0]';
    
    
    % External torques (perturbation + control)
    ext_torq = ambt + contq;
    
    % Initial attitude vector:
    att_vec = [quat; w_ang]';         % Transposed

    % ODE Solver parameters
    tspan = [t, t+tstep/2, t+tstep];
    
    % Numeric integration (ODE45)
    if flag_mag == 0
        [T, Y] = ode45('rigbody', tspan, att_vec, options, ext_torq, iner, invin);
    else
        % To convert from inertial state vector to terrestrial vector
        geoc = inertial_to_terrestrial(gst(mjd, dfra+t), stat);
    
        % Earth's magnetic field
        sphe = rectangular_to_spherical(geoc);
        alt = sphe(3)/1000;
        elong = sphe(1);
        colat = pi/2 - sphe(2);
        earth_field = 1.e-9*igrf_field (year_frac, alt, colat, elong);
        
        [T, Y] = ODE45('rigbody', tspan, att_vec, options, ext_torq, iner, invin, ...
            mag_mom, earth_field);
    end

    att_vec = Y(3, :)';         % propagated attitude vector
    quat = att_vec(1:4);        % propagated quaternion
	w_ang = att_vec(5:7);       % propagated angular velocity

    eulzxz = quatezxz(quat);    % euler angles

    % attitude control torque logic (if any)
 	cont_torq = [0; 0; 0];
 
    % Store data to be plotted
    time = cat(2, time, t);
    euler = cat(2, euler, eulzxz*180/pi);
    omeg = cat(2, omeg, w_ang);
    orbit = cat(2, orbit, stat');
    keorb = cat(2, keorb, kep2');

end

close all

% Output visualization
plot(time, euler);
xlabel('Time (s)')
ylabel('Euler angles (3-1-3) (deg)')
title('Attitude in Euler angles')

figure
plot(time, omeg);
xlabel('Time (s)')
ylabel('Angular velocity (rad/s)')
title('Attitude angular velocity')

figure
subplot(3, 1, 1);
plot(time, keorb(4,:)*180/pi);
xlabel('Time (s)')
ylabel('Ascencion node (deg)')
title('Right ascencion of the ascending node')

subplot(3, 1, 2);
plot(time, keorb(5,:)*180/pi);
xlabel('Time (s)')
ylabel('Perigee argument (deg)')
title('Perigee argument')

subplot(3, 1, 3);
plot(time, keorb(6,:)*180/pi);
xlabel('Time (s)')
ylabel('Mean anomaly (deg)')
title('Mean anomaly')

figure
subplot(2, 1, 1);
plot(time, orbit(1:3,:)/1000);
xlabel('Time (s)')
ylabel('Position (km)')
title('Satellite inertial position ')

subplot(2, 1, 2);
plot(time, orbit(4:6,:)/1000);
xlabel('Time (s)')
ylabel('Velocity (km/s)')
title('Satellite velocity')

    