% Author: Kit Kennedy    
% Entry point for python wrapper script to call code for calculating access
% windows for various events: ground station overpasses, observations,
% crosslinks

function [t_r] = accesses_wrapper(...
        kepler_elems_init,...
        end_time_s,...
        delta_t_s)
   
% find base directory for matlab pipeline code
file_dir = fileparts(mfilename('fullpath'));
base_directory = strcat(file_dir,'/..');

% add path to other code we'll be using
addpath(strcat(base_directory,'/access_utils'))

[obs,obsaer,gslink,gsaer,sunecl,xlink,xrange] = calc_accesses(all_sats_t_r_eci, params, base_directory)