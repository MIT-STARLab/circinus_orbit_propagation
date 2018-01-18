function [] = delkep_file_writer_wrapper(satname, filename, start_time_str, delta_t_sec, end_time_sec, a, e, i, RAAN, arg_perigee, mean_anom, base_directory)

% delkep_file_writer.m
% Meant to serve as an easy-to-use wrapper for propagating a LEO
% satellite's orbit forward in time

% Makes use of delkep.m from the PROPAT toolbox from INPE
% This file is explained in detail in PROPAT_Summary_paper.pdf

% Produces an output text file with the inertial coordinates of the
% spacecraft as a function of time, similar to what STK would produce

% inputs:
% satname - name of satellite, e.g. 'Satellite1'
% start_time_str - start time of senario as a string
% delta_t_sec - time step for orbit prop in seconds, e.g. 60
% end_time_sec - end time for orbit propagation in seconds, e.g. 86400
% a,e,i,RAAN,arg_perigee,mean_anom - keplarian orbit elements, in meters
% (a) and degrees (all else except e)

%% Parse Inputs

start_time = datenum(start_time_str);
mJDEpoch = mjuliandate(start_time);


%% Setup output file

fileID = fopen(filename,'w');

creation_time = datestr(datetime('now'));

fprintf(fileID,'Sat ephemeris file created in MATLAB using delkep_wrapper.m @ %s\n',creation_time);  % print info line
fprintf(fileID,'%s\n\n\n',satname);  % print sat name, and a bunch of header space to file
fprintf(fileID,'      Time (UTCG)              x (km)          y (km)          z (km)   \n');
fprintf(fileID,'------------------------    ------------    ------------    ------------\n');

formatOut = 'dd mmm yyyy HH:MM:SS.FFF';

%% Propagate

addpath(strcat(base_directory,'/Libraries/PROPAT/propat_code'))

RTD = 180/pi;
DTR = pi/180;

kep_elem = [a*1000 e i*DTR RAAN*DTR arg_perigee*DTR mean_anom*DTR];  % in meters and radians

time = 0;
rv = kepel_statvec(kep_elem);
fprintf(fileID,'%s    % 12.6f    % 12.6f    % 12.6f \n',datestr(start_time+time/86400,formatOut),rv(1)/1000,rv(2)/1000,rv(3)/1000);

while time < end_time_sec
    deltakep = delkep(kep_elem);
    kep_elem = kep_elem + deltakep*delta_t_sec;
    time = time + delta_t_sec;
    
    rv = kepel_statvec(kep_elem);
    fprintf(fileID,'%s    % 12.6f    % 12.6f    % 12.6f \n',datestr(start_time+time/86400,formatOut),rv(1)/1000,rv(2)/1000,rv(3)/1000);
end

fclose(fileID);

