function [t_r] = orbit_prop_wrapper(...
        kepler_elems_init,...
        end_time_s,...
        delta_t_s)

% Entry point for python wrapper script to call orbit propagation code.
% Currently uses the delkep propagation method
   
file_dir = fileparts(mfilename('fullpath'));
base_directory = strcat(file_dir,'/..');

addpath(strcat(base_directory,'/propagation'))
addpath(strcat(base_directory,'/libraries/PROPAT/propat_code'))
    
a = kepler_elems_init(1);
e = kepler_elems_init(2);
inc = kepler_elems_init(3);
RAAN = kepler_elems_init(4);
arg_perigee = kepler_elems_init(5);
mean_anom = kepler_elems_init(6);

[t_hist, r_hist, v_hist] = propagate_delkep(end_time_s, delta_t_s, a, e, inc, RAAN, arg_perigee, mean_anom);

t_r = [t_hist,r_hist];