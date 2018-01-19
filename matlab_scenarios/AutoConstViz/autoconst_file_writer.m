% creates a bunch of files for satellites
% Features 3 SSO orbits and 1 equatorial orbit

%% Inputs

% if we're not automating this, then we need to set numbers of satellites
if exist('automated_generation') && automated_generation == 1
    % No-op
else
    num_sats_orbit_1 = 1;
    num_sats_orbit_2 = 0;
    num_sats_orbit_3 = 0;
    header_file = strcat(base_directory,'/czml/iridium/czml_header_iridium.czml.part.txt');
    final_czml_file_name_pre = 'sats_file_single_';
end

final_czml_file_name = strcat(final_czml_file_name_pre,num2str(num_sats_orbit_1),'_',num2str(num_sats_orbit_2),'_',num2str(num_sats_orbit_3),'.czml');

start_time_str = '15 Mar 2017 10:00:00.000';  % NOTE: currently the czml files are hardcoded to this date ... if the date is changed here, the czml file will no longer work
startdatevec = [2012, 3, 15, 10, 0, 0];
mJDEpoch = mjuliandate(startdatevec);

delta_t_sec = 10;  % seconds
end_time_sec = 86400;  % seconds

addpath(strcat(base_directory,'/SatPosFileIO'));
addpath(strcat(base_directory,'/czml'));

sat_file_names = {};

%% Specify orbit for 8:30 LTAN, write position file, part of czml file

addpath(strcat(base_directory,'/MatlabTools'));

% angles should be in degrees below
LTN = 8.5;  % local time of ascending node for SSO+
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
    
    delkep_file_writer_wrapper(satname, pos_file_name, start_time_str, delta_t_sec, end_time_sec, a, e, i, RAAN, arg_perigee, mean_anom, base_directory);

    num_header_lines = 6;
    [sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);
    
    decimation = 5;
    sat_header_file_name = strcat(base_directory,'/czml/',satname,'_pos_stub.czml.part.txt');
    sat_output_file_name = strcat(satname,'_pos.czml.part.txt');
    sat_locations_to_czml_file(sat_output_file_name,sat_header_file_name,sat_locations,delta_t_sec,decimation);  % note the czml file currently assumes a day long scenario.
    sat_output_file_name_obs = strcat(satname,'_obs_pos.czml.part.txt');
    sat_locations_to_czml_file_translate(sat_output_file_name_obs,sat_header_file_name,sat_locations,delta_t_sec,decimation); 
    
    sat_file_names = [sat_file_names; sat_output_file_name];
end


%% Specify orbit for 12:30 LTAN, write position file, part of czml file

% angles should be in degrees below
LTN = 12.5;  % local time of ascending node for SSO+
Re = 6378.0088;
altitude = 600;  % km
e = 0;
oe = genSSOoe(altitude, e, mJDEpoch, LTN);
a = Re + altitude;  % km
i = oe.i_deg;
RAAN = oe.RAAN;
arg_perigee = 0;

sat_name_base_num = num_sats_orbit_1;

for sat_num = 1:num_sats_orbit_2
    satname = strcat('sat',num2str(sat_num+sat_name_base_num));
    pos_file_name = strcat(satname,'_delkep_pos.txt');
    
    mean_anom = 360/num_sats_orbit_1*(sat_num-1);
    
    delkep_file_writer_wrapper(satname, pos_file_name, start_time_str, delta_t_sec, end_time_sec, a, e, i, RAAN, arg_perigee, mean_anom, base_directory);

    num_header_lines = 6;
    [sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);
    
    decimation = 5;
    sat_header_file_name = strcat(base_directory,'/czml/',satname,'_pos_stub.czml.part.txt');
    sat_output_file_name = strcat(satname,'_pos.czml.part.txt');
    sat_locations_to_czml_file(sat_output_file_name,sat_header_file_name,sat_locations,delta_t_sec,decimation);  % note the czml file currently assumes a day long scenario.
    sat_output_file_name_obs = strcat(satname,'_obs_pos.czml.part.txt');
    sat_locations_to_czml_file_translate(sat_output_file_name_obs,sat_header_file_name,sat_locations,delta_t_sec,decimation); 
    
    sat_file_names = [sat_file_names; sat_output_file_name];
end


%% Specify orbit for 16:30 LTAN, write position file, part of czml file

% angles should be in degrees below
LTN = 16.5;  % local time of ascending node for SSO+
Re = 6378.0088;
altitude = 600;  % km
e = 0;
oe = genSSOoe(altitude, e, mJDEpoch, LTN);
a = Re + altitude;  % km
i = oe.i_deg;
RAAN = oe.RAAN;
arg_perigee = 0;

sat_name_base_num = num_sats_orbit_1+num_sats_orbit_2;

for sat_num = 1:num_sats_orbit_3
    satname = strcat('sat',num2str(sat_num+sat_name_base_num));
    pos_file_name = strcat(satname,'_delkep_pos.txt');
    
    mean_anom = 360/num_sats_orbit_1*(sat_num-1);
    
    delkep_file_writer_wrapper(satname, pos_file_name, start_time_str, delta_t_sec, end_time_sec, a, e, i, RAAN, arg_perigee, mean_anom, base_directory);

    num_header_lines = 6;
    [sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);
    
    decimation = 5;
    sat_header_file_name = strcat(base_directory,'/czml/',satname,'_pos_stub.czml.part.txt');
    sat_output_file_name = strcat(satname,'_pos.czml.part.txt');
    sat_locations_to_czml_file(sat_output_file_name,sat_header_file_name,sat_locations,delta_t_sec,decimation);  % note the czml file currently assumes a day long scenario.
    sat_output_file_name_obs = strcat(satname,'_obs_pos.czml.part.txt');
    sat_locations_to_czml_file_translate(sat_output_file_name_obs,sat_header_file_name,sat_locations,delta_t_sec,decimation); 
    
    sat_file_names = [sat_file_names; sat_output_file_name];
end


%% Specify equatorial orbit, write position file, part of czml file

% angles should be in degrees below
Re = 6378.0088;
altitude = 600;  % km
e = 0;
a = Re + altitude;  % km
i = 0;
RAAN = 0;
arg_perigee = 0;

sat_name_base_num = num_sats_orbit_1+num_sats_orbit_2+num_sats_orbit_3;

for sat_num = 1:num_sats_orbit_4
    satname = strcat('sat',num2str(sat_num+sat_name_base_num));
    pos_file_name = strcat(satname,'_delkep_pos.txt');
    
    mean_anom = 360/num_sats_orbit_4*(sat_num-1);
    
    delkep_file_writer_wrapper(satname, pos_file_name, start_time_str, delta_t_sec, end_time_sec, a, e, i, RAAN, arg_perigee, mean_anom, base_directory);

    num_header_lines = 6;
    [sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);
    
    decimation = 5;
    sat_header_file_name = strcat(base_directory,'/czml/',satname,'_pos_stub.czml.part.txt');
    sat_output_file_name = strcat(satname,'_pos.czml.part.txt');
    sat_locations_to_czml_file(sat_output_file_name,sat_header_file_name,sat_locations,delta_t_sec,decimation);  % note the czml file currently assumes a day long scenario.
    sat_output_file_name_obs = strcat(satname,'_obs_pos.czml.part.txt');
    sat_locations_to_czml_file_translate(sat_output_file_name_obs,sat_header_file_name,sat_locations,delta_t_sec,decimation); 
    
    sat_file_names = [sat_file_names; sat_output_file_name];
end




%% Combine all czml file parts into a single file

delete(final_czml_file_name)
copyfile(header_file,final_czml_file_name);

for i=1:size(sat_file_names,1)
    sat_file_name = sat_file_names{i};
    system(['cat ',sat_file_name,' >> ', final_czml_file_name]);
end

fileID = fopen(final_czml_file_name,'a+');
fprintf(fileID,'\n  {}\n]');  %print end matter stuff for czml json file

system('rm *_pos.czml.part.txt');  % remove intermediate files