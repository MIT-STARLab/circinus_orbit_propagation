% Creates file for large constellation scenario. 
% includes sats in 2 different SSO orbits and an equatorial orbit,
% currently

clear

automated_generation = 1;
use_prexisting_xlnk_file = 1;

base_directory = '../..';
sat_headers_loc = '/czml/sat_headers/';

out_file_string1 = 'orbitprop_walker';

targets_parameters_filename = '../parameters_targets.xlsx';
gs_parameters_filename = '../parameters_gs_network.xlsx'; % Change to 'parameters_descope.xlsx'


%% file inputs

% gs inputs
%  header_file = '../../czml/czml_header_33targ_sfn.czml.part.txt';
% header_file = '../../czml/czml_header_33targ_lcrd.czml.part.txt';
%  header_file = '../../czml/czml_header_33targ_ksat.czml.part.txt';
%  header_file = '../../czml/czml_header_33targ_equatalt.czml.part.txt';
% header_file = '../../czml/czml_header_33targ_bridgesat.czml.part.txt';
header_file = '../../czml/czml_header_33targ_wallops.czml.part.txt';

% gs=1 SFN
% gs=2 KSAT
% gs=4 LCRD
% gs=5 equatorial alternative
% gs=6 bridgesat
% gs=6 wallops

gs_network = 8;

% orbit inputs
% num_planes = 3;
% num_sats_orbit_1 = 10;  % RAAN 0
% num_sats_orbit_2 = 10;  % RAAN 120
% num_sats_orbit_3 = 10;  % RAAN 240
% num_sats = num_sats_orbit_1 + num_sats_orbit_2 + num_sats_orbit_3;

num_planes = 4;
num_sats_orbit_1 = 25;  % RAAN 0
num_sats_orbit_2 = 25;  % RAAN 90
num_sats_orbit_3 = 25;  % RAAN 180
num_sats_orbit_4 = 25;  % RAAN 270
num_sats = num_sats_orbit_1 + num_sats_orbit_2 + num_sats_orbit_3+num_sats_orbit_4;

start_time_str = '15 Mar 2017 10:00:00.000';  % make sure to include the milliseconds! That's necessary to make python epoch updater script work

delta_t_sec = 10;  % seconds
end_time_sec = 86400*3;  % seconds

targets_parameters_sheetname = '33_targ';
yes_crosslinks = 1;



%% Build File Names

out_file_string2 = ['_orb',num2str(num_planes),'-',num2str(num_sats)];  % 3 planes
out_file_string3 = ['_gs',num2str(gs_network)];
out_file_string4 = ['_t',num2str(end_time_sec),'-',num2str(10)];

out_file_pre = [out_file_string1,out_file_string2,out_file_string3,out_file_string4];

xlnks_file_name = [out_file_string1,out_file_string2,out_file_string4,'_xlnk.mat'];


%% Run Scripts

gs_parameters_sheetname = num2str(gs_network);
info_string = ['created for ',num2str(num_sats),' satellite scenario from matlab script Walker_generator_wrapper.m, using targets params file sheet ',targets_parameters_sheetname,' and gs sheet ',gs_parameters_sheetname,', for ',num2str(end_time_sec),' seconds with ',num2str(delta_t_sec),' seconds timestep'];
info_string = [info_string, '; 3 plane walker with: '];
info_string = [info_string,', Walker RAAN 0 - ',num2str(num_sats_orbit_1)];
info_string = [info_string,', Walker RAAN 120 - ',num2str(num_sats_orbit_2)];
info_string = [info_string,', Walker RAAN 240 - ',num2str(num_sats_orbit_3)];

if num_planes == 3
    Walker_file_writer_3plane
elseif num_planes == 4
    Walker_file_writer_4plane
end

addpath(strcat(base_directory,'/AccessUtils'))

calc_and_store_accesses