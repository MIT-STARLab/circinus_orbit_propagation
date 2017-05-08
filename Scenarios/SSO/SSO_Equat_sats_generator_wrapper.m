% Creates file for large constellation scenario. 
% includes sats in 2 different SSO orbits and an equatorial orbit,
% currently

clear

automated_generation = 1;

base_directory = '../..';

%% file inputs

% for sats_per_orbit=7:7
%     sats_per_orbit
    
% Propagate sat orbits

% inputs
num_sats_orbit_1 = 10;
num_sats_orbit_2 = 0;
num_sats_orbit_3 = 10;


%% geometry inputs

% inputs
num_sats = num_sats_orbit_1 + num_sats_orbit_2 + num_sats_orbit_3;

gs_network = 6;
targets_parameters_sheetname = '33_targ';
yes_crosslinks = 1;
filename_pre_string = 'Sat_3orbEquat_';
filename_post_string = '_4gs_matlabprop.mat';

targets_parameters_filename = '../parameters_targets.xlsx';
gs_parameters_filename = '../parameters_gs_network.xlsx'; % Change to 'parameters_descope.xlsx'
gs_parameters_sheetname = num2str(gs_network);


%% Run Scripts

info_string = ['created for ',num2str(num_sats),' satellite scenario from matlab script SSO_Equat_sats_generator_wrapper.m, using targets params file sheet ',targets_parameters_sheetname,' and gs sheet ',gs_parameters_sheetname];
info_string = [info_string, '; orbits: '];

SSO_Equat_file_writer

addpath(strcat(base_directory,'/AccessUtils'))

calc_and_store_accesses