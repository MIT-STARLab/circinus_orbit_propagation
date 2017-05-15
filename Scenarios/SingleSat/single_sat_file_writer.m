% Creates file for single sat scenario. Sat can be in one of 3 orbits
% currently, SSO, ISS, or equatorial

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

startdatevec = datevec(start_time_str);
mJDEpoch = mjuliandate(startdatevec);

addpath(strcat(base_directory,'/SatPosFileIO'));
addpath(strcat(base_directory,'/czml'));

sat_file_names = {};

%% Specify orbit for 10:30 LTAN, write position file, part of czml file

addpath(strcat(base_directory,'/MatlabTools'));

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

info_string = [info_string,', 10:30 LTAN ',num2str(num_sats_orbit_1)];

for sat_num = 1:num_sats_orbit_1
    satname = strcat('sat',num2str(sat_num));
    pos_file_name = strcat(satname,'_delkep_pos.txt');
    
    mean_anom = 360/num_sats_orbit_1*(sat_num-1);
    
    delkep_file_writer_wrapper(satname, pos_file_name, start_time_str, delta_t_sec, end_time_sec, a, e, i, RAAN, arg_perigee, mean_anom, base_directory);

    num_header_lines = 6;
    [sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);
    
    decimation = 5;
    sat_header_file_name = strcat(base_directory,sat_headers_loc,satname,'_pos_stub.czml.part.txt');
    sat_output_file_name = strcat(satname,'_pos.czml.part.txt');
    sat_locations_to_czml_file(sat_output_file_name,sat_header_file_name,sat_locations,delta_t_sec,decimation);  % note the czml file currently assumes a day long scenario.
    
    sat_file_names = [sat_file_names; sat_output_file_name];
end


%% Specify ISS orbit, write position file, part of czml file

% source http://heavens-above.com/orbit.aspx?satid=25544
% epoch 09 March 2017 13:21:34
% perigee height:	399 km
% apogee height:	409 km
% angles should be in degrees below
Re = 6378.0088;
r_p = Re + 399;  % km
r_a = Re + 409;  % km
e = 0.0007321;
a = (r_p+r_a)/2;  % km
i = 51.6421;
RAAN = 174.9418;
arg_perigee = 269.1478;

sat_name_base_num = num_sats_orbit_1;

info_string = [info_string,', ISS ',num2str(num_sats_orbit_2)];

for sat_num = 1:num_sats_orbit_2
    satname = strcat('sat',num2str(sat_num+sat_name_base_num));
    pos_file_name = strcat(satname,'_delkep_pos.txt');
    
    mean_anom = 360/num_sats_orbit_2*(sat_num-1);
    
    delkep_file_writer_wrapper(satname, pos_file_name, start_time_str, delta_t_sec, end_time_sec, a, e, i, RAAN, arg_perigee, mean_anom, base_directory);

    num_header_lines = 6;
    [sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);
    
    decimation = 5;
    sat_header_file_name = strcat(base_directory,sat_headers_loc,satname,'_pos_stub.czml.part.txt');
    sat_output_file_name = strcat(satname,'_pos.czml.part.txt');
    sat_locations_to_czml_file(sat_output_file_name,sat_header_file_name,sat_locations,delta_t_sec,decimation);  % note the czml file currently assumes a day long scenario.
    
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

sat_name_base_num = num_sats_orbit_1+num_sats_orbit_2;

info_string = [info_string,', equatorial ',num2str(num_sats_orbit_3)];

for sat_num = 1:num_sats_orbit_3
    satname = strcat('sat',num2str(sat_num+sat_name_base_num));
    pos_file_name = strcat(satname,'_delkep_pos.txt');
    
    mean_anom = 360/num_sats_orbit_3*(sat_num-1);
    
    delkep_file_writer_wrapper(satname, pos_file_name, start_time_str, delta_t_sec, end_time_sec, a, e, i, RAAN, arg_perigee, mean_anom, base_directory);

    num_header_lines = 6;
    [sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);
    
    decimation = 5;
    sat_header_file_name = strcat(base_directory,sat_headers_loc,satname,'_pos_stub.czml.part.txt');
    sat_output_file_name = strcat(satname,'_pos.czml.part.txt');
    sat_locations_to_czml_file(sat_output_file_name,sat_header_file_name,sat_locations,delta_t_sec,decimation);  % note the czml file currently assumes a day long scenario.
    
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
fprintf(fileID,['\n  { "metadata_file_writer":"dummy_string",\n"file_writer_info_string":','"',info_string,'"','}\n]']);  %print helpful info string
fclose(fileID);

system('rm *_pos.czml.part.txt');  % remove intermediate files

% Update epoch times in file
startdatenum = datenum(start_time_str);
enddatenum = startdatenum + end_time_sec/86400;
system(['python ../../czml/Tools/CZMLEpochUpdater.py ',final_czml_file_name,' "',start_time_str,'" "',datestr(enddatenum,'dd mmm yyyy HH:MM:SS.FFF'),'"']);