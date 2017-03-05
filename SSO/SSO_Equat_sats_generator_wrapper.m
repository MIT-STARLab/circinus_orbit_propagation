automated_generation = 1;

% for sats_per_orbit=7:7
%     sats_per_orbit
    
    % Propagate sat orbits

    % inputs
    num_sats_orbit_1 = 10;
    num_sats_orbit_2 = 0;
    num_sats_orbit_3 = 10;

    SSO_Equat_file_writer


    % calculate geometry

    % inputs
    num_sats = num_sats_orbit_1 + num_sats_orbit_2 + num_sats_orbit_3;
    
    parameters_filename = 'parameters_descope_7_4gsEq.xlsx'; % Change to 'parameters_descope.xlsx'
    
    yes_crosslinks = 1;

    filename_pre_string = 'Sat_3orbEquat_';
    filename_post_string = '_4gs_matlabprop.mat';

    SSO_accesses_MDO_new_obs
% end