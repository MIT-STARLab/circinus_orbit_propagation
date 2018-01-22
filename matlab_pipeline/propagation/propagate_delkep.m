function [t_hist, r_hist, v_hist] = propagate_delkep(end_time_s, delta_t_s, a, e, inc, RAAN, arg_perigee, mean_anom, base_directory)

% Uses delkep.m from the PROPAT toolbox from INPE
% This file is explained in detail in PROPAT_Summary_paper.pdf

% inputs:
% delta_t_sec - time step for orbit prop in seconds, e.g. 60
% end_time_sec - end time for orbit propagation in seconds, e.g. 86400
% a,e,i,RAAN,arg_perigee,mean_anom - keplarian orbit elements, in meters
% (a) and degrees (all else except e)

% notes: if delta_t_sec does not divide evenly into end_time_sec, the very
% last timestep (end_time_sec) will be truncated to make sure the
% propagation history has constant timesteps.

%% Set up Path

addpath(strcat(base_directory,'/libraries/PROPAT/propat_code'));

%% Parse Inputs

% floor in case it doesn't divide evenly
num_timepoints = floor(end_time_s/delta_t_s)+1; 

t_hist = zeros(num_timepoints,1);
r_hist = zeros(num_timepoints,3);
v_hist = zeros(num_timepoints,3);

%% Propagate

RTD = 180/pi;
DTR = pi/180;

kep_elem = [a*1000 e inc*DTR RAAN*DTR arg_perigee*DTR mean_anom*DTR];  % in meters and radians

time = 0;
rv = kepel_statvec(kep_elem);

indx = 1;
while time <= end_time_s
    t_hist(indx) = time;
    r_hist(indx,1:3) = rv(1:3)/1000; % store in km
    v_hist(indx,1:3) = rv(4:6)/1000; % store in km
    
    deltakep = delkep(kep_elem);
    
    kep_elem = kep_elem + deltakep*delta_t_s;
    time = time + delta_t_s;
    rv = kepel_statvec(kep_elem);
    indx = indx + 1;
end

