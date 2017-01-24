function [sat_time, sat_locations] = import_sat_pos_file(file_name,num_header_lines)

sat_time = [];
sat_locations = [];

fileID = fopen(file_name,'r');

% throw away header lines
for i=1:num_header_lines
    tline = fgetl(fileID);
end

while 1
    tline = fgetl(fileID);
    if ~ischar(tline), break, end
    t_str = tline(1:24);
    pos_str = tline(25:end);
    [pos] = sscanf(pos_str,'%f    %f    %f');
    
    sat_time = [sat_time; t_str];
    sat_locations = [sat_locations; pos(1) pos(2) pos(3)];
end