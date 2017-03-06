function [] = sat_locations_to_czml_file(sat_output_file_name,sat_header_file_name,sat_locations, timestep, decimation)
% creates a section of a czml json file, with the data for a single satellite

% note the czml file currently assumes a day long scenario.

start_time = 0;

x = sat_locations(:,1)*1000;
y = sat_locations(:,2)*1000;
z = sat_locations(:,3)*1000;

pos = [x y z];

copyfile(sat_header_file_name,sat_output_file_name);

fileID = fopen(sat_output_file_name,'a+');

time = start_time;
dec_counter = 5;
for line=1:size(pos,1)
    if dec_counter == decimation
        if line == size(pos,1)
            fprintf(fileID,'        %d,%f,%f,%f\n',time,pos(line,:));  %notice the missing trailing comma
        else
            fprintf(fileID,'        %d,%f,%f,%f,\n',time,pos(line,:));
        end
    end

    dec_counter = dec_counter + 1;
    if dec_counter > decimation
        dec_counter = dec_counter - decimation;
    end

    time = time+timestep;
end

fprintf(fileID,'      ]\n    }\n  },');  %end matter

end