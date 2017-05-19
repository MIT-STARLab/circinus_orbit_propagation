% Creates file for large constellation scenario. 
% includes sats in 2 different SSO orbits and an equatorial orbit,
% currently

% gs=6 bridgesat

clear

automated_generation = 1;

base_directory = '../..';
sat_headers_loc = '/czml/sat_headers/';

%% file inputs

% header_file = '../../czml/czml_header_33targ_equatalt.czml.part.txt';
header_file = '../../czml/czml_header_33targ_bridgesat.czml.part.txt';
final_czml_file_name_pre = 'sats_file_ssoequat_10000sec_bridgesat_';

% inputs
num_sats_orbit_1 = 30;
num_sats_orbit_2 = 0;
num_sats_orbit_3 = 0;

start_time_str = '15 Mar 2017 10:00:00.000';  % make sure to include the milliseconds! That's necessary to make python epoch updater script work

delta_t_sec = 10;  % seconds
end_time_sec = 86400*3;  % seconds

%% geometry inputs

% inputs
num_sats = num_sats_orbit_1 + num_sats_orbit_2 + num_sats_orbit_3;

gs_network = 6;
targets_parameters_sheetname = '33_targ';
yes_crosslinks = 1;
filename_pre_string = 'sats_file_ssoequat_10000sec_bridgesat_';
filename_post_string = '_gs6_matlabprop.mat';

targets_parameters_filename = '../parameters_targets.xlsx';
gs_parameters_filename = '../parameters_gs_network.xlsx'; % Change to 'parameters_descope.xlsx'
gs_parameters_sheetname = num2str(gs_network);


%% Run Scripts

info_string = ['created for ',num2str(num_sats),' satellite scenario from matlab script SSO_Equat_sats_generator_wrapper.m, using targets params file sheet ',targets_parameters_sheetname,' and gs sheet ',gs_parameters_sheetname,', for ',num2str(end_time_sec),' seconds with ',num2str(delta_t_sec),' seconds timestep'];
info_string = [info_string, '; orbits: '];

SSO_Equat_file_writer

addpath(strcat(base_directory,'/AccessUtils'))

calc_and_store_accesses