% SSO_file_writer.m
% Open position files already created for the satellites and use orbit data
% to calculate access times: observation times, downlink times, crosslink 
% times, eclipse times

%% Inputs
clear

addpath('../Libraries/AccessUtils');


%% Read in Sat files
% Note: assuming sat_time is same for all satellites

sat_times = [];


for sat_num = 1:20
    satname = strcat('sat',num2str(sat_num));
    pos_file_name = strcat(satname,'_delkep_pos.txt');

    num_header_lines = 6;
    [sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);
  
    if sat_num == 1
        sat_times = [sat_times; sat_time];
    end
    
    sat_locations_all_sats(:,:,sat_num) = sat_locations;  % note this does not currently have velocity in it.
end

%% Figure out eclipse times

addpath('../Libraries/Solar_Ephmeris/demo_sun2');
% initialize sun ephemeris  (kinda dumb...)
global suncoef
suncoef = 1;

sun_locations = [];

for i=1:size(sat_times,1)
    jdate = juliandate(sat_times(i,:));
    [rasc, decl, rsun(i,:)] = sun2 (jdate);  % rsun in km
end

sunecl = {};
for sat_num = 1:20
    eclipse_times = find_eclipse_times(sat_times,sat_locations_all_sats(:,:,sat_num),rsun);
    sunecl = [sunecl change_to_windows(eclipse_times,5/60/24)];  % make eclipse windows, with a spaceing of at least 5 minutes between windows
end

