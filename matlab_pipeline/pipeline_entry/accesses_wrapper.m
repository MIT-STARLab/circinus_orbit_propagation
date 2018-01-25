% Author: Kit Kennedy    
% Entry point for python wrapper script to call code for calculating access
% windows for various events: ground station overpasses, observations,
% crosslinks

% params is passed as a python dict, comes in as a struct

function [obs,obsaer,gslink,gsaer,sunecl,xlink,xrange] = accesses_wrapper(...
        all_sats_t_r_eci,...
        params)
   
% find base directory for matlab pipeline code
file_dir = fileparts(mfilename('fullpath'));
base_directory = strcat(file_dir,'/..');  % matlab base

% add path to other code we'll be using
addpath(strcat(base_directory,'/access_utils'))

% save('test_in.mat','all_sats_t_r_eci','params');

[obs,obsaer,gslink,gsaer,sunecl,xlink,xrange] = calc_accesses(all_sats_t_r_eci, params, base_directory, params.verbose);