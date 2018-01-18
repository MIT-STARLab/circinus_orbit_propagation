% SSO_file_writer.m
% Open position files already created for the satellites and use orbit data
% to calculate access times: observation times, downlink times, crosslink 
% times, eclipse times

% outputs, intended to be saved to a .mat file (see end of this script):

% Note that times in the outputs from this script are in modified julian
% date, obtained from mjuliandate(). To change to another time system, need
% to change mjuliandate call both here and in change_to_windows()

% This new script does not use max elevation as the discriminator for obs
% events anymore, but rather filters observation events to be above a
% minimum elevation cutoff. This should be more representative of how
% observation data is acquired in reality

%% Inputs

tic

% if we're not automating this, then we need to set numbers of satellites
if exist('automated_generation') && automated_generation == 1
    % No-op
else
    % DEPRECATED!!!
    clear
    num_sats = 20;
    
    parameters_filename = 'parameters_descope_7_4gsEq.xlsx'; % Change to 'parameters_descope.xlsx'
    
    yes_crosslinks = 1;

    filename_pre_string = 'Sat_2orb_';
    filename_post_string = '_1gs_matlabprop.mat';

end


addpath(strcat(base_directory,'/AccessUtils'));

[target_in_a, target_in_b] = xlsread(targets_parameters_filename,targets_parameters_sheetname);
num_obs = size(target_in_a,1);

[gs_in_a, gs_in_b] = xlsread(gs_parameters_filename,gs_parameters_sheetname);
num_gs = size(gs_in_a,1);

el_cutoff = 0; % elevation cutoff for finding ground accesses. (deg)
el_cutoff_obs = 60; % elevation cutoff for finding obs times. (deg)

%% Read in Sat files
% Note: assuming sat_time is same for all satellites

disp('read in sat files');

addpath(strcat(base_directory,'/SatPosFileIO'));


% Read in sat 1 first to get num timepoints
sat_num = 1
    
satname = strcat('sat',num2str(sat_num));
pos_file_name = strcat(satname,'_delkep_pos.txt');

num_header_lines = 6;
[sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);
sat_times = sat_time; % store times for all sats

num_timepoints = size(sat_times,1);

sat_locations_all_sats = zeros(num_timepoints,3,num_sats);  % preallocate
sat_locations_all_sats(:,:,sat_num) = sat_locations;  % note this does not currently have velocity in it.

% now the other sats
parfor sat_num = 2:num_sats
    sat_num
    
    satname = strcat('sat',num2str(sat_num));
    pos_file_name = strcat(satname,'_delkep_pos.txt');

    num_header_lines = 6;
    [sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);
    
    sat_locations_all_sats(:,:,sat_num) = sat_locations;  % note this does not currently have velocity in it.
end

%% Calculate eclipse times

disp('calculate eclipse times');

addpath(strcat(base_directory,'/Libraries/Solar_Ephmeris/demo_sun2'));
% initialize sun ephemeris globals for sun2 below (holy cow that library is hacky AF)
global suncoef
suncoef = 1;

sun_locations = [];

rsun = zeros(num_timepoints,3);
for timepoint_num=1:num_timepoints
    jdate = juliandate(sat_times(timepoint_num,:));
    [rasc, decl, rsun(timepoint_num,:)] = sun2 (jdate);  % rsun in km
end

sunecl = cell(1,num_sats);
parfor sat_num = 1:num_sats
    sat_num
    
    eclipse_times = find_eclipse_times(sat_times,sat_locations_all_sats(:,:,sat_num),rsun);
    sunecl{1,sat_num} = change_to_windows(eclipse_times,5/60/24);  % make eclipse windows, with a spaceing of at least 5 minutes between windows
end

%% Calculate Observation Times and AER

disp('calculate observation times');

addpath(strcat(base_directory,'/Libraries/PROPAT/propat_code'));

% Determine obs coordinates in ECEF. Only one point because doesn't change
target_lat_lon_rad = target_in_a(:,3:4)*pi/180;
target_ecef_xyz = zeros(num_obs,3);
parfor target_num=1:num_obs
    % target_lat_lon_rad is a "broadcast variable", but it's so small of an 
    % array it doesn't really matter
    target_ecef_xyz(target_num,:) = sph_geodetic_to_geocentric([target_lat_lon_rad(target_num,2),target_lat_lon_rad(target_num,1),0])/1000; % long, lat, alt (assuming zero for all targets). Output in km.
end

% get ECI positions of targets as function of time
target_lat_lon_rad = target_in_a(:,3:4)*pi/180;
target_eci_xyz = zeros(num_timepoints,3,num_obs);
gwst = zeros(num_timepoints,1);
for timepoint_num=1:num_timepoints
    dt = datetime(sat_times(timepoint_num,:),'InputFormat','dd MMM yyyy HH:mm:ss.sss');
    mjdi = djm(day(dt), month(dt), year(dt));  % get modified julian day for ECEF -> ECI conversion
    dayf = mod(datenum(dt),1)*86400;  % get fraction of day in seconds
    gwst(timepoint_num) = gst(mjdi,dayf);  % get greenwhich sidereal time in radians
end
    
disp('calc eci');
parfor target_num=1:num_obs
    target_num
    
    for timepoint_num=1:num_timepoints
        temp = terrestrial_to_inertial (gwst(timepoint_num), [target_ecef_xyz(target_num,:),0,0,0]);  % zeros because the function also requires a velocity input, but we don't care about that.
        target_eci_xyz(timepoint_num,:,target_num) = temp(1:3);  % km
    end
end


disp('calc obs, obs aer');
obs = cell(num_sats,num_obs);
obsaer = cell(num_sats,num_obs);
parfor sat_num = 1:num_sats
    
    sat_num
    
    for target_num=1:num_obs
        obs_at_target = [];
        
        % find obs target overpasses, and then turn into windows
        [access_times, az_el_range] = find_accesses_from_ground(sat_times,sat_locations_all_sats(:,:,sat_num),target_eci_xyz(:,:,target_num),el_cutoff_obs);
        [obs_windows,indices] = change_to_windows(access_times,5/60/24);
        
        % save AER of all the accesses
        aer = {};
        for i=1:size(indices,1)
            start_indx = indices(i,1);
            end_indx = indices(i,2);
            access_times_slice = access_times(start_indx:end_indx,:);
            az_el_range_slice = az_el_range(start_indx:end_indx,:);
            
            aer = [aer; mjuliandate(access_times_slice) az_el_range_slice];
        end
        
        obs{sat_num,target_num} = obs_windows;
        obsaer{sat_num,target_num} = aer;
    end
    
end


%% Calculate Downlink Times and AER

disp('calculate downlink times');

% Determine gs coordinates in ECEF. Only one point because doesn't change
gs_lat_lon_rad = gs_in_a(:,2:3)*pi/180;
gs_ecef_xyz = zeros(num_gs,3);
parfor gs_num=1:num_gs
    % gs_lat_lon_rad is a "broadcast variable", but it's so small of an 
    % array it doesn't really matter
    gs_ecef_xyz(gs_num,:) = sph_geodetic_to_geocentric([gs_lat_lon_rad(gs_num,2),gs_lat_lon_rad(gs_num,1),0])/1000; % long, lat, alt (assuming zero for all targets). Output in km.
end

% get ECI positions of gs as function of time
gs_lat_lon_rad = gs_in_a(:,3:4)*pi/180;
gs_eci_xyz = zeros(num_timepoints,3,num_gs);
gwst = zeros(num_timepoints,1);
for timepoint_num=1:num_timepoints
    dt = datetime(sat_times(timepoint_num,:),'InputFormat','dd MMM yyyy HH:mm:ss.sss');
    mjdi = djm(day(dt), month(dt), year(dt));  % get modified julian day for ECEF -> ECI conversion
    dayf = mod(datenum(dt),1)*86400;  % get fraction of day in seconds
    gwst(timepoint_num) = gst(mjdi,dayf);  % get greenwhich sidereal time in radians
end
   
disp('calc eci');
parfor gs_num=1:num_gs
    gs_num
    
    for timepoint_num=1:num_timepoints
        temp = terrestrial_to_inertial (gwst(timepoint_num), [gs_ecef_xyz(gs_num,:),0,0,0]);  % zeros because the function also requires a velocity input, but we don't care about that.
        gs_eci_xyz(timepoint_num,:,gs_num) = temp(1:3);  % km
    end
end

disp('calc gslink, gsaer');
gslink = cell(num_sats,num_gs);
gsaer = cell(num_sats,num_gs);
parfor sat_num = 1:num_sats
    
    sat_num
    
    for gs_num=1:num_gs
        
        % find obs target overpasses, and then turn into windows
        [access_times, az_el_range] = find_accesses_from_ground(sat_times,sat_locations_all_sats(:,:,sat_num),gs_eci_xyz(:,:,gs_num),el_cutoff);
        [dlnk_windows,indices] = change_to_windows(access_times,5/60/24);
        
        % save AER of all the accesses
        aer = {};
        for i=1:size(indices,1)
            start_indx = indices(i,1);
            end_indx = indices(i,2);
            access_times_slice = access_times(start_indx:end_indx,:);
            az_el_range_slice = az_el_range(start_indx:end_indx,:);
            
            aer = [aer; mjuliandate(access_times_slice) az_el_range_slice];
        end
        
        gslink{sat_num,gs_num} = dlnk_windows;
        gsaer{sat_num,gs_num} = aer;
    end
    
end


%% Calculate Crosslink Times and Ranges

if yes_crosslinks
    if use_prexisting_xlnk_file 
        if exist(xlnks_file_name, 'file')     
            disp(['load crosslink times from: ',xlnks_file_name]);
            load(xlnks_file_name);
        else
            disp(['couldnt load crosslink file: ',xlnks_file_name]);
            use_prexisting_xlnk_file = 0;
        end
    end
        
    if ~use_prexisting_xlnk_file

        disp('calculate crosslink times');

        xlink = cell(num_sats,num_sats);
        xrange = cell(num_sats,num_sats);
        for sat_num = 1:num_sats

            sat_num

            sat_locations_sat = sat_locations_all_sats(:,:,sat_num); % do this before the parfor so that sat_locations_sat is slicable below and we don't have to send the whole array!

            parfor other_sat_num=sat_num+1:num_sats  % need the parfor on the second level so that e.g. xlink{sat_num,other_sat_num} call below is slicable

                % find obs target overpasses, and then turn into windows
                [access_times, range, alt_of_closest_point] = find_crosslink_accesses(sat_times,sat_locations_sat,sat_locations_all_sats(:,:,other_sat_num));
                [xlnk_windows,indices] = change_to_windows(access_times,5/60/24);

                % save AER of all the accesses
                sats_xlnks_range = {};
                for i=1:size(indices,1)
                    start_indx = indices(i,1);
                    end_indx = indices(i,2);
                    access_times_slice = access_times(start_indx:end_indx,:);
                    range_slice = range(start_indx:end_indx,:);
                    alt_of_closest_point_slice = alt_of_closest_point(start_indx:end_indx,:);
                    sats_xlnks_range = [sats_xlnks_range; mjuliandate(access_times_slice) range_slice alt_of_closest_point_slice];
                end

                xlink{sat_num,other_sat_num} = xlnk_windows;  % Note: had a problem earlier where I declared 'xlink' to be the wrong size, and kept on getting abstruse "you can't index this way!!1" errors from matlab. Super helpful right debug message (not). To be on the lookout for in future... 
                xrange{sat_num,other_sat_num} = sats_xlnks_range;
            end

        end

    end
end
%% Save relevant info for running sim_constellation to file

tstep_dayf = (datenum(sat_times(2,:)) - datenum(sat_times(1,:)));
startdatestr = sat_times(1,:);
enddatestr = sat_times(end,:);

if yes_crosslinks
    save([out_file_pre,'.mat'],'info_string','num_timepoints','tstep_dayf','startdatestr','enddatestr','gs_in_a','gs_in_b','target_in_a','target_in_b','obs','obsaer','gslink','gsaer','sunecl','xlink','xrange','gs_network','targets_parameters_sheetname');
else
% or no crosslinks
    save([out_file_pre,'.mat'],'info_string','num_timepoints','tstep_dayf','startdatestr','enddatestr','gs_in_a','gs_in_b','target_in_a','target_in_b','obs','obsaer','gslink','gsaer','sunecl','gs_network','targets_parameters_sheetname');
end


toc
