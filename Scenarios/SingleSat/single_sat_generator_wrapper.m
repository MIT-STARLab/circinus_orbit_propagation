% Creates files for single sat scenario. Sat can be in one of 3 orbits
% currently, SSO, ISS, or equatorial

clear

automated_generation = 1;
use_prexisting_xlnk_file = 1;

base_directory = '../..';
sat_headers_loc = '/czml/sat_headers/';

out_file_string1 = 'orbitprop_single_sat';

targets_parameters_filename = '../parameters_targets.xlsx';
gs_parameters_filename = '../parameters_gs_network.xlsx'; % Change to 'parameters_descope.xlsx'


%% file inputs
% header_file = '../czml/czml_header_single_sat_sfn.czml.part.txt';
% header_file = '../../czml/czml_header_33targ_bridgesat.czml.part.txt';
% header_file = '../czml/czml_header_single_sat_ksat.czml.part.txt';
%  header_file = '../../czml/czml_header_single_sat_lcrd.czml.part.txt';
% header_file = '../../czml/czml_header_single_sat_wallops.czml.part.txt';
% header_file = '../../czml/czml_header_33targ_equatalt.czml.part.txt';
header_file = '../../czml/czml_header_33targ_sfn2.czml.part.txt'

% gs=1 SFN
% gs=2 KSAT
% gs=4 LCRD
% gs=5 equatorial alternative
% gs=6 bridgesat
% gs=8 wallops
% gs=9 (sfn+antarctica, gs xlsx 1; equatorial 2 ... gs xlsx 2)
% gs=10 (singapore ... gs xlsx 2)

gs_network = 9;

% final_czml_file_name_pre = 'sats_file_single_sfn_';
% final_czml_file_name_pre = 'sats_file_single_bridgesat_';
% final_czml_file_name_pre = 'sats_file_single_ksat_';
% final_czml_file_name_pre = 'sats_file_single_equatalt_';
final_czml_file_name_pre = 'sats_file_single_sfn2_';

num_sats_orbit_1 = 1;  % SSO 1030 LTAN
num_sats_orbit_2 = 0;  % ISS
num_sats_orbit_3 = 0;  % Equatorial


start_time_str = '15 Mar 2017 10:00:00.000';  % make sure to include the milliseconds! That's necessary to make python epoch updater script work

delta_t_sec = 10;  % seconds
end_time_sec = 86400*3;  % seconds

targets_parameters_sheetname = '33_targ';  %(target xlsx 1)
% targets_parameters_sheetname = 'equat_targets_1'; %(target xlsx 2)
yes_crosslinks = 1;



%% Build File Names

out_file_string2 = ['_orb',num2str(num_sats_orbit_1),'-',num2str(num_sats_orbit_2),'-',num2str(num_sats_orbit_3)];
out_file_string3 = ['_gs',num2str(gs_network)];
out_file_string4 = ['_t',num2str(end_time_sec),'-',num2str(10)];

out_file_pre = [out_file_string1,out_file_string2,out_file_string3,out_file_string4];

xlnks_file_name = [out_file_string1,out_file_string2,out_file_string4,'_xlnk.mat'];


%% Run Scripts

num_sats = num_sats_orbit_1 + num_sats_orbit_2 + num_sats_orbit_3;

gs_parameters_sheetname = num2str(gs_network);
info_string = ['created for ',num2str(num_sats),' satellite scenario from matlab script single_sat_generator_wrapper.m, using targets params file sheet ',targets_parameters_filename,'/',targets_parameters_sheetname,' and gs sheet ',gs_parameters_filename,'/',gs_parameters_sheetname,', for ',num2str(end_time_sec),' seconds with ',num2str(delta_t_sec),' seconds timestep'];
info_string = [info_string, '; orbits: ']

single_sat_file_writer

addpath(strcat(base_directory,'/AccessUtils'))

calc_and_store_accesses