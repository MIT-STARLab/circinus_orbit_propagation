clear

automated_generation = 1;

    
% Propagate sat orbits


% inputs
header_file = '../czml/czml_header_autoconstviz.czml.part.txt';

final_czml_file_name_pre = 'sats_file_autoconst4orb_';

num_sats_orbit_1 = 10;  % SSO 830 LTAN
num_sats_orbit_2 = 10;  % SSO 1230 LTAN
num_sats_orbit_3 = 10;  % SSO 1630 LTAN
num_sats_orbit_4 = 10;  % Equatorial

autoconst_file_writer



%% calculate geometry

% inputs
% more frequent change
gs_network = 1;
targets_parameters_sheetname = 'mov_rev_3_targ';
yes_crosslinks = 0;
filename_pre_string = 'AutoconstSats_';
% filename_pre_string = 'Sat_single_ISS_';
% filename_pre_string = 'Sat_single_Equat_';
filename_post_string = '_matlabprop.mat';

    
%less frequent change
num_sats = num_sats_orbit_1 + num_sats_orbit_2 + num_sats_orbit_3;

% parameters_filename = 'parameters_single_sat_sfn.xlsx'; % Change to 'parameters_descope.xlsx'
targets_parameters_filename = '../parameters_targets.xlsx';
gs_parameters_filename = '../parameters_gs_network.xlsx'; % Change to 'parameters_descope.xlsx'
gs_parameters_sheetname = num2str(gs_network);

info = ['created for ',num2str(num_sats),' satellite scenario from matlab script autoconst_generator_wrapper.m, using targets params file sheet ',targets_parameters_sheetname,' and gs sheet ',gs_parameters_sheetname];


calc_and_store_accesses
% end