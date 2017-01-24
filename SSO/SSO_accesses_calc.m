% SSO_file_writer.m
% Open position files already created for the satellites and use orbit data
% to calculate access times: observation times, downlink times, crosslink 
% times, eclipse times

%% Inputs

%% Read in Sat files

for sat_num = 1:10
    satname = strcat('sat',num2str(sat_num));
    pos_file_name = strcat(satname,'_delkep_pos.txt');

    num_header_lines = 6;
    [sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);
  
end
