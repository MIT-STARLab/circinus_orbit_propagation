% SSO_file_writer.m
% creates a bunch of files for satellites in a two SSO orbits. 

%% Inputs

% if we're not automating this, then we need to set numbers of satellites
if exist('automated_generation') && automated_generation == 1
    % No-op
else
    num_sats_orbit_1 = 3;
    num_sats_orbit_2 = 3;
end

final_czml_file_name = strcat('sats_file_',num2str(num_sats_orbit_1),'_',num2str(num_sats_orbit_2),'.czml');

start_time_str = '15 Mar 2017 10:00:00.000';  % NOTE: currently the czml files are hardcoded to this date ... if the date is changed here, the czml file will no longer work
startdatevec = [2012, 3, 15, 10, 0, 0];
mJDEpoch = mjuliandate(startdatevec);

delta_t_sec = 10;  % seconds
end_time_sec = 86400;  % seconds

addpath('../sat_pos_file_io');
addpath('../czml');

sat_file_names = {};

%% Specify orbit for 10:30 LTAN, write position file, part of czml file

% angles should be in degrees below
LTN = 10.5;  % local time of ascending node for SSO+
Re = 6378.0088;
altitude = 600;  % km
e = 0;
oe = genSSOoe(altitude, e, mJDEpoch, LTN);
a = Re + altitude;  % km
i = oe.i_deg;
RAAN = oe.RAAN;
arg_perigee = 0;

for sat_num = 1:num_sats_orbit_1
    satname = strcat('sat',num2str(sat_num));
    pos_file_name = strcat(satname,'_delkep_pos.txt');
    
    mean_anom = 360/num_sats_orbit_1*(sat_num-1);
    
    delkep_file_writer_wrapper(satname, pos_file_name, start_time_str, delta_t_sec, end_time_sec, a, e, i, RAAN, arg_perigee, mean_anom);

    num_header_lines = 6;
    [sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);
    
    decimation = 5;
    sat_file_name = strcat(satname,'_pos.czml.part.txt');
    sat_locations_to_czml_file(sat_file_name,sat_num,sat_locations,delta_t_sec,decimation);  % note the czml file currently assumes a day long scenario.
    
    sat_file_names = [sat_file_names; sat_file_name];
end


%% Specify orbit for 2:30 LTAN, write position file, part of czml file

% angles should be in degrees below
LTN = 14.5;  % local time of ascending node for SSO
Re = 6378.0088;
altitude = 600;  % km
e = 0;
oe = genSSOoe(altitude, e, mJDEpoch, LTN);
a = Re + altitude;  % km
i = oe.i_deg;
RAAN = oe.RAAN;
arg_perigee = 0;

for sat_num = 1:num_sats_orbit_2
    satname = strcat('sat',num2str(sat_num+num_sats_orbit_1));
    pos_file_name = strcat(satname,'_delkep_pos.txt');
    
    mean_anom = 360/num_sats_orbit_2*(sat_num-1);
    
    delkep_file_writer_wrapper(satname, pos_file_name, start_time_str, delta_t_sec, end_time_sec, a, e, i, RAAN, arg_perigee, mean_anom);

    num_header_lines = 6;
    [sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);
    
    decimation = 5;
    sat_file_name = strcat(satname,'_pos.czml.part.txt');
    sat_locations_to_czml_file(sat_file_name,sat_num+num_sats_orbit_1,sat_locations,delta_t_sec,decimation);  % note the czml file currently assumes a day long scenario.
    
    sat_file_names = [sat_file_names; sat_file_name];
end


%% Combine all czml file parts into a single file

delete(final_czml_file_name)
copyfile('../czml/czml_header.czml.part.txt',final_czml_file_name);

for i=1:size(sat_file_names,1)
    sat_file_name = sat_file_names{i};
    system(['cat ',sat_file_name,' >> ', final_czml_file_name]);
end

fileID = fopen(final_czml_file_name,'a+');
fprintf(fileID,'\n  {}\n]');  %print end matter stuff for czml json file

system('rm *_pos.czml.part.txt');  % remove intermediate files