clear

automated_generation = 1;

    
% Propagate sat orbits


%% inputs
% header_file = '../czml/czml_header_single_sat_sfn.czml.part.txt';
% header_file = '../czml/czml_header_single_sat_bridgesat.czml.part.txt';
header_file = '../czml/czml_header_autoconstviz.czml.part.txt';

% final_czml_file_name_pre = 'sats_file_single_';
final_czml_file_name_pre = 'sats_file_autoconst_';

num_sats_orbit_1 = 1;  % SSO 1030 LTAN
num_sats_orbit_2 = 0;  % ISS
num_sats_orbit_3 = 0;  % Equatorial

single_sat_file_writer


%% calculate geometry

% inputs
% more frequent change
gs_network = 1;
targets_parameters_sheetname = 'mov_rev_3_targ';
yes_crosslinks = 0;
filename_pre_string = 'Sat_single_SSO_';
% filename_pre_string = 'Sat_single_ISS_';
% filename_pre_string = 'Sat_single_Equat_';
filename_post_string = '_bridgesat_matlabprop.mat';


%less frequent change
num_sats = num_sats_orbit_1 + num_sats_orbit_2 + num_sats_orbit_3;

% parameters_filename = 'parameters_single_sat_sfn.xlsx'; % Change to 'parameters_descope.xlsx'
targets_parameters_filename = '../parameters_targets.xlsx';
gs_parameters_filename = '../parameters_gs_network.xlsx'; % Change to 'parameters_descope.xlsx'
gs_parameters_sheetname = num2str(gs_network);

info = ['created for ',num2str(num_sats),' satellite scenario from matlab script single_sat_generator_wrapper.m, using params files ',targets_parameters_filename,' and ',gs_parameters_filename];


calc_and_store_accesses
% end