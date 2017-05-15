% Creates files for single sat scenario. Sat can be in one of 3 orbits
% currently, SSO, ISS, or equatorial

clear

automated_generation = 1;

base_directory = '../..';
sat_headers_loc = '/czml/sat_headers/';


%% file inputs
% header_file = '../czml/czml_header_single_sat_sfn.czml.part.txt';
% header_file = '../czml/czml_header_single_sat_bridgesat.czml.part.txt';
% header_file = '../czml/czml_header_single_sat_ksat.czml.part.txt';
%  header_file = '../../czml/czml_header_single_sat_lcrd.czml.part.txt';
% header_file = '../../czml/czml_header_single_sat_wallops.czml.part.txt';
header_file = '../../czml/czml_header_33targ_equatalt.czml.part.txt';


% final_czml_file_name_pre = 'sats_file_single_sfn_';
% final_czml_file_name_pre = 'sats_file_single_bridgesat_';
% final_czml_file_name_pre = 'sats_file_single_ksat_';
final_czml_file_name_pre = 'sats_file_single_equatalt_';

num_sats_orbit_1 = 0;  % SSO 1030 LTAN
num_sats_orbit_2 = 0;  % ISS
num_sats_orbit_3 = 1;  % Equatorial


start_time_str = '18 Apr 2017 13:00:00.000';  % make sure to include the milliseconds! That's necessary to make python epoch updater script work

delta_t_sec = 10;  % seconds
end_time_sec = 86400*2.5;  % seconds


%% geometry inputs

% inputs
% more frequent change
gs_network = 5;

yes_crosslinks = 0;
% filename_pre_string = 'Sat_single_SSO_';
% filename_pre_string = 'Sat_single_ISS_';
filename_pre_string = 'Sat_single_Equat_';
filename_post_string = '_equatalt_matlabprop.mat';

%less frequent change
num_sats = num_sats_orbit_1 + num_sats_orbit_2 + num_sats_orbit_3;

% parameters_filename = 'parameters_single_sat_sfn.xlsx'; % Change to 'parameters_descope.xlsx'
targets_parameters_filename = '../parameters_targets.xlsx';
targets_parameters_sheetname = '33_targ';
gs_parameters_filename = '../parameters_gs_network.xlsx'; % Change to 'parameters_descope.xlsx'
gs_parameters_sheetname = num2str(gs_network);


%% Run Scripts

info_string = ['created for ',num2str(num_sats),' satellite scenario from matlab script single_sat_generator_wrapper.m, using targets params file sheet ',targets_parameters_sheetname,' and gs sheet ',gs_parameters_sheetname];
info_string = [info_string, '; orbits: '];

single_sat_file_writer

addpath(strcat(base_directory,'/AccessUtils'))

calc_and_store_accesses