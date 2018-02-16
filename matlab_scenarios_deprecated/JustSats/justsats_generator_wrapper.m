% Creates file for simple constellation that just has satellites, no ground
% stations or obs targets

clear

automated_generation = 1;

base_directory = '../..';
sat_headers_loc = '/czml/sat_headers/';

out_file_string1 = 'orbitprop_justsats';


%% file inputs

header_file = '../../czml/czml_header_justsats.czml.part.txt';

% orbit inputs
num_sats_orbit_1 = 1;  % SSO 10:30 LTAN
num_sats_orbit_2 = 1;  % GEO, inclination = 0
num_sats = num_sats_orbit_1 + num_sats_orbit_2;

start_time_str = '15 Mar 2017 10:00:00.000';  % make sure to include the milliseconds! That's necessary to make python epoch updater script work

delta_t_sec = 10;  % seconds
end_time_sec = 86400;  % seconds

targets_parameters_sheetname = '33_targ';
yes_crosslinks = 1;



%% Build File Names

out_file_string2 = ['_orb',num2str(2),'-',num2str(num_sats)];  % 2 planes
out_file_string3 = ['_t',num2str(end_time_sec),'-',num2str(10)];

out_file_pre = [out_file_string1,out_file_string2,out_file_string3];


%% Run Scripts

info_string = ['created for ',num2str(num_sats),' satellite scenario from matlab script justsats_generator_wrapper.m, with no obs targets or ground stations, for ',num2str(end_time_sec),' seconds with ',num2str(delta_t_sec),' seconds timestep'];
info_string = [info_string, '; ad hoc const with: '];
info_string = [info_string,', SSO 1030 LTAN - ',num2str(num_sats_orbit_1)];
info_string = [info_string,', GEO inc 0 - ',num2str(num_sats_orbit_2)];

justsats_file_writer

% addpath(strcat(base_directory,'/AccessUtils'))
% 
% calc_and_store_accesses