clear

automated_generation = 1;

% for sats_per_orbit=7:7
%     sats_per_orbit
    
% Propagate sat orbits


% inputs
% header_file = '../czml/czml_header_single_sat_sfn.czml.part.txt';
header_file = '../czml/czml_header_single_sat_lcrd.czml.part.txt';
final_czml_file_name_pre = 'sats_file_single_';

num_sats_orbit_1 = 0;  % SSO 1030 LTAN
num_sats_orbit_2 = 0;  % ISS
num_sats_orbit_3 = 1;  % Equatorial

single_sat_file_writer


% calculate geometry

% inputs
num_sats = num_sats_orbit_1 + num_sats_orbit_2 + num_sats_orbit_3;

gs_network = 4;
% parameters_filename = 'parameters_single_sat_sfn.xlsx'; % Change to 'parameters_descope.xlsx'
targets_parameters_filename = 'parameters_targets.xlsx';
gs_parameters_filename = 'parameters_gs_network.xlsx'; % Change to 'parameters_descope.xlsx'
yes_crosslinks = 0;
info = ['created for ',num2str(num_sats),' satellite scenario from matlab script single_sat_generator_wrapper.m, using params files ',targets_parameters_filename,' and ',gs_parameters_filename];
% filename_pre_string = 'Sat_single_SSO_';
% filename_pre_string = 'Sat_single_ISS_';
filename_pre_string = 'Sat_single_Equat_';
filename_post_string = '_lcrd_matlabprop.mat';

SSO_accesses_MDO_new_obs
% end