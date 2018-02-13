% Author: Kit Kennedy    
% Entry point for python wrapper script to call code for calculating access
% windows for various events: ground station overpasses, observations,
% crosslinks

% params is passed as a python dict, comes in as a struct

function [obs_by_sat,obsaer_by_sat,gslink_by_sat,gsaer_by_sat,sunecl_by_sat,xlink_by_sat,xrange_by_sat] = accesses_wrapper(...
        all_sats_t_r_eci,...
        params)
   
% find base directory for matlab pipeline code
file_dir = fileparts(mfilename('fullpath'));
base_directory = strcat(file_dir,'/..');  % matlab base

% add path to other code we'll be using
addpath(strcat(base_directory,'/access_utils'));
addpath(strcat(base_directory,'/matlab_tools'));

[obs,obsaer,gslink,gsaer,sunecl,xlink,xrange] = calc_accesses(all_sats_t_r_eci, params, base_directory, params.verbose);

obs_by_sat = reshape_outputs(obs);
obsaer_by_sat = reshape_outputs(obsaer);
gslink_by_sat = reshape_outputs(gslink);
gsaer_by_sat = reshape_outputs(gsaer);
sunecl_by_sat = reshape_outputs(sunecl);
xlink_by_sat = reshape_outputs(xlink);
xrange_by_sat =  reshape_outputs(xrange);

