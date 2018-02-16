load('../../SatN10.mat')
num_sats = 10;

start_time =0;
timestep = 60; %seconds
decimation = 5;

for sat=1:num_sats
    x = sat_locations(1,:,sat)'*1000;
    y = sat_locations(2,:,sat)'*1000;
    z = sat_locations(3,:,sat)'*1000;

    pos = [x y z];
    
    copyfile(strcat('sat',num2str(sat),'_pos_stub.czml.part.txt'),strcat('sat',num2str(sat),'_pos.czml.part'));
    
    fileID = fopen(strcat('sat',num2str(sat),'_pos.czml.part'),'a+');
    
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