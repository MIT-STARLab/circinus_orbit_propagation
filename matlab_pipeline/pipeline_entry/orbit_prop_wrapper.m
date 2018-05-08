% Author: Kit Kennedy    
% Entry point for python wrapper script to call orbit propagation code.
% Currently uses the delkep propagation method

function [t_r_eci,t_r_ecef] = orbit_prop_wrapper(...
        kepler_elems_init,...
        end_time_s,...
        delta_t_s,...
        params)
   
% find base directory for matlab pipeline code
file_dir = fileparts(mfilename('fullpath'));
base_directory = strcat(file_dir,'/..');

% add path to other code we'll be using
addpath(strcat(base_directory,'/propagation'))
addpath(strcat(base_directory,'/matlab_tools'));

a = kepler_elems_init(1);  % km
e = kepler_elems_init(2);
inc = kepler_elems_init(3);  % deg
RAAN = kepler_elems_init(4);  % deg
arg_perigee = kepler_elems_init(5);  % deg 
mean_anom = kepler_elems_init(6);   % deg 

[t_hist, r_eci_hist, v_eci_hist] = propagate_delkep(end_time_s, delta_t_s, a, e, inc, RAAN, arg_perigee, mean_anom, base_directory);

% python wrapper only cares about time and position for now
t_r_eci = [t_hist,r_eci_hist];

start_time_dt = parse_iso_datestr(params.scenario_start_utc);
if params.calc_ecef
    t_r_ecef = zeros(size(t_r_eci));
    for indx= 1:size(t_hist,1)
        dt = start_time_dt + seconds(t_hist(indx,1));
        mjdi = djm(day(dt), month(dt), year(dt));  % get modified julian day for ECI -> ECEF conversion
        dayf = mod(datenum(dt),1)*86400;  % get fraction of day in seconds
        gwst = gst(mjdi,dayf);  % get greenwhich sidereal time in radians

        t_r_ecef(indx,1) = t_hist(indx,1);
        rv_ecef = inertial_to_terrestrial (gwst, [t_r_eci(indx,2:4),0,0,0]);  % zeros because the function also requires a velocity input, but we don't care about that.
        t_r_ecef(indx,2:4) = rv_ecef(1:3); % only grab r terms
    end
    save('yo.mat','t_r_ecef')
else
    t_r_ecef = [];
end