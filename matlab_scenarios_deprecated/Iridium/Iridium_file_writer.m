% Iridium_file_writer.m

% source: http://ccar.colorado.edu/asen5050/projects/projects_2000/redlin/
% 
% 6 planes, 30 deg spacing
% 11 sats per plane
% i = 86.4
% 780 km alt
% 
% Inferred from an image of the coverage (https://en.wikipedia.org/wiki/Iridium_satellite_constellation#/media/File:Iridium_Coverage_Animation.gif)
% 
% intra-plane true anom spacing: 32.73 deg
% inter-plane true anom phasing: 16.36 deg


%% Inputs
% 
% % if we're not automating this, then we need to set numbers of satellites
% if exist('automated_generation') && automated_generation == 1
%     % No-op
% else
%     num_sats_orbit_1 = 10;
%     num_sats_orbit_2 = 10;
% end

header_file = '../czml/iridium/czml_header_iridium.czml.part.txt';

final_czml_file_name = 'sats_file_iridium.czml';

start_time_str = '15 Mar 2017 10:00:00.000';  % NOTE: currently the czml files are hardcoded to this date ... if the date is changed here, the czml file will no longer work
startdatevec = [2012, 3, 15, 10, 0, 0];
mJDEpoch = mjuliandate(startdatevec);

delta_t_sec = 60;  % seconds
end_time_sec = 86400;  % seconds

addpath('../sat_pos_file_io');
addpath('../czml');

sat_file_names = {};

%% Go through all the orbits

% angles should be in degrees below
Re = 6378.0088;
altitude = 780;  % km
e = 0;
a = Re + altitude;  % km
i = 86.4;
arg_perigee = 0;

sats_per_orbit = 11;

for orbit_num = 1:6
    for sat_num = 1:sats_per_orbit
        satname = strcat('Iridium',num2str(sat_num+(orbit_num-1)*sats_per_orbit));
        pos_file_name = strcat(satname,'_delkep_pos.txt');

        mean_anom = 360/sats_per_orbit*(sat_num-1);
        
        RAAN = (orbit_num-1)*30;
        
        if mod(orbit_num,2) == 0
            mean_anom = mean_anom + 16.36;
        end

        delkep_file_writer_wrapper(satname, pos_file_name, start_time_str, delta_t_sec, end_time_sec, a, e, i, RAAN, arg_perigee, mean_anom);

        num_header_lines = 6;
        [sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);

        decimation = 5;
        sat_header_file_name = strcat('../czml/iridium/',satname,'_pos_stub.czml.part.txt');
        sat_output_file_name = strcat(satname,'_pos.czml.part.txt');
        sat_locations_to_czml_file(sat_output_file_name,sat_header_file_name,sat_locations,delta_t_sec,decimation);  % note the czml file currently assumes a day long scenario.

        sat_file_names = [sat_file_names; sat_output_file_name];
    end
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