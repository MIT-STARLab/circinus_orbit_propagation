%
% Program to generate a attitude data file to be used by the Povray script
% program "propov.pov", "propov.ini" and "propov.inc" that generates the
% frames of an attitude motion video.
% The attitude is stored in file "propov.txt", in the following format:
%
% First line:
%   [tstep], [tend],
%   tstep : time interval between two animation frames, in seconds. Tipical
%   values are between 15 and 30 frames per second (1/15 to 1/30)
%   tend  : propagation time of the last record, in seconds
% Second and following lines:
%   [stim], <[bx], [by], [bz]>,
%   stim : time stamp of the satellite attitude, in seconds
%   bx, by and bz : Euler angles from a XYZ rotation, in degrees,
%   from the inertial frame to body fixed frame.
%
% Usage:
%   After running this program, open from POV interface the script
%   "propov.pov" and "propov.ini".
%   In the propov.pov script, you may change the myobject variable to the 
%   satellite geometry and material you like.
%   In the propov.ini, change the Final_Frame variable, to the rate 
%   between tend and tstep, i. e. the total number of frames in
%   the animation video (Final_Frame = <tend / tstep>).
%   Run the "propov.ini" and wait till it generates all the frames
%   With an appropriate video encoder-decoder program, like Fast Movie
%   Processor, for instance, generate the output video from the attitude
%   frames (they are stored at the same place where propov.pov is stored).
%

rad = pi/180;
deg = 1/rad;

fid = fopen('propov.txt', 'wt');

% Orbit keplerian elements:
kepel = [7000000, 0.01, 98*rad, 0, 0, 0];   % see function delkep
% Orbit state vector:
stat = kepel_statvec(kepel);
    
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

% tempos de propagação (s):
tini = 0;
tstep = 1/15;
tend = 60.;

% matriz de inércia
massa = 1;      % em kg
lx    = 0.1;    % dimensão, em metros
tensin = massa*lx*lx/6*[1, 0.0, 0.0; 0.0, 0.95, 0.0; 0.0, 0.0, 1.05];

% inversa da matriz de inércia
teninv = inv(tensin);

% ganhos do controle
% propgain = 0.5;     % ganho proporcional
% dervgain = 8;       % ganho derivativo

% atitude de referencia para o controle
% euler_ref = [0; 0; 0]*rad; % ângulos de Euler da referência em graus convertido para rad
% angvec_ref = [0; 0; 0]*pi/30; % velocidade angular em rpm convertida para radianos/s

% iniciação de parâmetros
torqcon = [0; 0; 0];    % torque de controle

% torques externos
ext_torq = [0; 0; 0];   % torques de perturbação ambiental

% iniciação dos torques
torq_att = [0; 0; 0];
torq_dis = [0; 0; 0];
time_att = tini;

% condições iniciais da atitude
angular_velocity = [2; 1; 3]*pi/30;  % em rpm convertido para rad/s
euler_angles = [60; 30; 40]*rad; % em graus convertido para radianos

% momento angular inicial
ele = tensin*angular_velocity;

% valor inicial
euler_att = euler_angles;
euler_ant = euler_att;

% vetor de estado
state_vector_in = [exyzquat(euler_angles); angular_velocity];
state_vector = state_vector_in;

% precisão do integrador:
options = odeset('abstol', 1e-8, 'reltol', 1e-8);

% cabeçalho do arquivo
fprintf(fid, '%15.11f, %12.5f,\n', [tstep, tend]);

% euler_att = -rmxexyz(exyzrmx(euler_angles)');
% euler_ant = euler_att;
% imprimir linha referente ao tempo inicial
fprintf(fid, '%8.3f, <%8.3f, %8.3f, %8.3f>,\n',...
    [tini, euler_angles'*deg]);

for time = tini:tstep:tend-tstep
    tspan = [time, time+tstep/2, time+tstep];
    
    % Time stamp
    disp(time)
    
    % Orbit propagation
    kep2 = kepel + delk*time;
    
    % To convert from keplerian elements to state vector (if needed)
    stat = kepel_statvec(kep2);

    % Numeric integration (ODE45)
    [T, Y] = ode45('rigbody', tspan, state_vector, options, ext_torq, tensin, teninv);

    % vetor de estado da atitude
    state_vector = Y(3, :)';
   
   % valor inicial
   rot_mat = quatrmx(state_vector);
   euler_att = rmxexyz(rot_mat);
   
   angvec_att = state_vector(5:7);
   
   for ind = 1: 3
   	if euler_att(ind) > pi
			euler_att(ind) = euler_att(ind) - 2*pi;
	   end
   	if euler_att(ind) < -pi
	      euler_att(ind) = euler_att(ind) + 2*pi;
	   end
   end

   euler_att = proximus(euler_att, euler_ant);
   euler_ant = euler_att;
   euler_deg = 180/pi*euler_ant;
   time_att = cat(2, time_att, T(3));
   
    % Earth's magnetic field
    tsgr = gst(mjd, dfra + time);
    geoc = inertial_to_terrestrial(tsgr, stat);
    sphe = rectangular_to_spherical(geoc);
    alt = sphe(3)/1000;
    elong = sphe(1);
    colat = pi/2 - sphe(2);
    earth_field = 1.e-9*igrf_field (year_frac, alt, colat, elong);  % no sistema NED
    earth_mag   = rotmay(sphe(2) + pi/2)*rotmaz(-elong)*earth_field'; % para o sistema terrestre
    earth_mag   = [earth_mag', 0, 0, 0];
    earth_iner  = terrestrial_to_inertial(tsgr, earth_mag); % para o sistema inercial
    b_sat = rot_mat*earth_iner(1:3)';   % para o sistema do satélite
    
    % Sun position
    sun_sat = sun(mjd, dfra + time);
    sun_sat = rot_mat*sun_sat(1:3)';
    
   % -------------------------------------------------------
   % controle
   torqcon = -2*(euler_att + 4*angvec_att);
   for ind = 1:3
      if (abs(torqcon(ind))<1/15)
         torqcon(ind) = 0;
      else
         torqcon(ind) = 0.5*sign(torqcon(ind));
      end
   end
   cont_torq = torqcon;
   cont_torq = [0; 0; 0];   % anular o torque de controle para teste
   ang_vec = torqcon/0.1;
   % -------------------------------------------------------
   %   soundw = cat(2, soundw, sum(abs(ang_vec))/5);
   
   % 	dis_torq = disturb (time, state_vector);
   dis_torq = [0; 0; 0];
   
   ext_torq = cont_torq + dis_torq;
   torq_att = cat(2, torq_att, cont_torq);
   torq_dis = cat(2, torq_dis, dis_torq);

   % imprimir nova atitude
	fprintf(fid, '%8.3f, <%8.3f, %8.3f, %8.3f>, \n',...
      [time+tstep, euler_deg']);
     
   euler_angles = cat(2, euler_angles, euler_deg);
   angular_velocity = cat(2, angular_velocity, angvec_att*30/pi);
   
end

close all

subplot (3,1,1), plot (time_att, euler_angles(1,:), 'r', time_att, euler_angles(2,:), 'g', ...
      time_att, euler_angles(3,:), 'b');
%figure
subplot (3,1,2), plot (time_att, angular_velocity(1, :), 'r', time_att, angular_velocity(2, :), 'g', ...
	   time_att, angular_velocity(3, :), 'b');
%figure
subplot (3,1,3), plot (time_att, torq_att(1, :), 'r', time_att, torq_att(2, :), 'g', ...
      time_att, torq_att(3, :), 'b');
%figure
%plot (time_att, torq_dis(1,:), 'r', time_att, torq_dis(2,:), 'g', ...
%      time_att, torq_dis(3,:), 'b');

figure

plot (euler_angles(1, :), angular_velocity(1, :), 'r', euler_angles(2, :), ...
      angular_velocity(2, :), 'g', euler_angles(3, :), angular_velocity(3, :), 'b');
   
figure
   
   plot (time_att, angular_velocity(1, :), 'r')
   figure
   plot (time_att, angular_velocity(2, :), 'g')
   figure
   plot (time_att, angular_velocity(3, :), 'b');

% plot (T, euler_angles);
% plot (euler_angles(1, :), euler_angles(2, :));

st = fclose(fid);
