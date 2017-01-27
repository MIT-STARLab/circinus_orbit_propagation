% SSO_file_writer.m
% Open position files already created for the satellites and use orbit data
% to calculate access times: observation times, downlink times, crosslink 
% times, eclipse times

%% Inputs
clear

addpath('../AccessUtils');

num_sats = 20;

parameters_filename = 'parameters_descope.xlsx'; % Change to 'parameters_descope.xlsx'
[target_in_a, target_in_b] = xlsread(parameters_filename,'Target_parameters');
num_obs = size(target_in_a,1);

[gs_in_a, gs_in_b] = xlsread(parameters_filename,'GS_parameters');
num_gs = size(gs_in_a,1);

el_cutoff = 0; % elevation cutoff for finding ground accesses.


%% Read in Sat files
% Note: assuming sat_time is same for all satellites
addpath('../sat_pos_file_io');

sat_times = [];

for sat_num = 1:num_sats
    satname = strcat('sat',num2str(sat_num));
    pos_file_name = strcat(satname,'_delkep_pos.txt');

    num_header_lines = 6;
    [sat_time, sat_locations] = import_sat_pos_file(pos_file_name,num_header_lines);
  
    if sat_num == 1
        sat_times = [sat_times; sat_time];
    end
    
    sat_locations_all_sats(:,:,sat_num) = sat_locations;  % note this does not currently have velocity in it.
end

num_timepoints = size(sat_times,1);

%% Figure out eclipse times

% addpath('../Libraries/Solar_Ephmeris/demo_sun2');
% % initialize sun ephemeris  (kinda dumb...)
% global suncoef
% suncoef = 1;
% 
% sun_locations = [];
% 
% for timepoint_num=1:num_timepoints
%     jdate = juliandate(sat_times(timepoint_num,:));
%     [rasc, decl, rsun(timepoint_num,:)] = sun2 (jdate);  % rsun in km
% end
% 
% sunecl = {};
% for sat_num = 1:num_sats
%     eclipse_times = find_eclipse_times(sat_times,sat_locations_all_sats(:,:,sat_num),rsun);
%     sunecl = [sunecl change_to_windows(eclipse_times,5/60/24)];  % make eclipse windows, with a spaceing of at least 5 minutes between windows
% end

%% Calculate Observation Times

% addpath('../sat_pos_file_io');
% addpath('../Libraries/PROPAT/propat_code');
% 
% % Determine obs coordinates in ECEF. Only one point because doesn't change
% target_lat_lon_rad = target_in_a(:,3:4)*pi/180;
% for target_num=1:num_obs
%     target_ecef_xyz(target_num,:) = sph_geodetic_to_geocentric([target_lat_lon_rad(target_num,2),target_lat_lon_rad(target_num,1),0])/1000; % long, lat, alt (assuming zero for all targets). Output in km.
% end
% 
% % get ECI positions of targets as function of time
% target_lat_lon_rad = target_in_a(:,3:4)*pi/180;
% target_eci_xyz = zeros(num_timepoints,3,num_obs);
% for timepoint_num=1:num_timepoints
%     dt = datetime(sat_times(timepoint_num,:),'InputFormat','dd MMM yyyy HH:mm:ss.sss');
%     mjdi = djm(day(dt), month(dt), year(dt));  % get modified julian day for ECEF -> ECI conversion
%     dayf = mod(datenum(dt),1)*86400;  % get fraction of day in seconds
%     gwst = gst(mjdi,dayf);  % get greenwhich sidereal time in radians
%     
%     for target_num=1:num_obs
%         temp = terrestrial_to_inertial (gwst, [target_ecef_xyz(target_num,:),0,0,0]);  % zeros because the function also requires a velocity input, but we don't care about that.
%         target_eci_xyz(timepoint_num,:,target_num) = temp(1:3);  % km
%     end
% end
% 
% obs = cell(num_sats,num_obs);
% for sat_num = 1:num_sats
%     
%     for target_num=1:num_obs
%         obs_at_target = [];
%         
%         % find obs target overpasses, and then turn into windows
%         [access_times, az_el_range] = find_accesses_from_ground(sat_times,sat_locations_all_sats(:,:,sat_num),target_eci_xyz(:,:,target_num),el_cutoff);
%         [obs_windows,indices] = change_to_windows(access_times,5/60/24);
%         
%         % for each overpass, find max el in it and report that as well as
%         % time and range as an obs event, in a list of all events at this
%         % sat, target combination
%         for i=1:size(indices,1)
%             start_indx = indices(i,1);
%             end_indx = indices(i,2);
%             az_el_range_slice = az_el_range(start_indx:end_indx,:);
%             access_times_slice = access_times(start_indx:end_indx,:);
%             
%             [max_el, indx] = max(az_el_range_slice(:,2)); % find max el
%             obs_event = [ datenum(access_times_slice(indx,:)), max_el, az_el_range_slice(indx,3)]; % obs has time of max el, max el, and range at max el (km).
%             obs_at_target = [obs_at_target ; obs_event];
%         end
%         
%         obs{sat_num,target_num} = obs_at_target;
%     end
%     
% end


%% Calculate Downlink Times and AER

% % Determine gs coordinates in ECEF. Only one point because doesn't change
% gs_lat_lon_rad = gs_in_a(:,2:3)*pi/180;
% for gs_num=1:num_gs
%     gs_ecef_xyz(gs_num,:) = sph_geodetic_to_geocentric([gs_lat_lon_rad(gs_num,2),gs_lat_lon_rad(gs_num,1),0])/1000; % long, lat, alt (assuming zero for all targets). Output in km.
% end
% 
% % get ECI positions of gs as function of time
% gs_lat_lon_rad = gs_in_a(:,3:4)*pi/180;
% gs_eci_xyz = zeros(num_timepoints,3,num_gs);
% for timepoint_num=1:num_timepoints
%     dt = datetime(sat_times(timepoint_num,:),'InputFormat','dd MMM yyyy HH:mm:ss.sss');
%     mjdi = djm(day(dt), month(dt), year(dt));  % get modified julian day for ECEF -> ECI conversion
%     dayf = mod(datenum(dt),1)*86400;  % get fraction of day in seconds
%     gwst = gst(mjdi,dayf);  % get greenwhich sidereal time in radians
%     
%     for gs_num=1:num_gs
%         temp = terrestrial_to_inertial (gwst, [gs_ecef_xyz(gs_num,:),0,0,0]);  % zeros because the function also requires a velocity input, but we don't care about that.
%         gs_eci_xyz(timepoint_num,:,gs_num) = temp(1:3);  % km
%     end
% end
% 
% gslink = cell(num_sats,num_gs);
% gsaer = cell(num_sats,num_gs);
% for sat_num = 1:num_sats
%     
%     for gs_num=1:num_gs
%         
%         % find obs target overpasses, and then turn into windows
%         [access_times, az_el_range] = find_accesses_from_ground(sat_times,sat_locations_all_sats(:,:,sat_num),gs_eci_xyz(:,:,gs_num),el_cutoff);
%         [dlnk_windows,indices] = change_to_windows(access_times,5/60/24);
%         
%         % save AER of all the accesses
%         aer = {};
%         for i=1:size(indices,1)
%             start_indx = indices(i,1);
%             end_indx = indices(i,2);
%             az_el_range_slice = az_el_range(start_indx:end_indx,:);
%             aer = [aer; az_el_range_slice];
%         end
%         
%         gslink{sat_num,gs_num} = dlnk_windows;
%         gsaer{sat_num,gs_num} = aer;
%     end
%     
% end


%% Calculate Crosslink Times and Ranges

xlink = cell(num_sats,num_gs);
xrange = cell(num_sats,num_gs);
for sat_num = 1:num_sats
    
    sat_num
    
    for other_sat_num=1:num_sats
        
        if sat_num == other_sat_num
            continue
        end
        
        % find obs target overpasses, and then turn into windows
        [access_times, range, alt_of_closest_point] = find_crosslink_accesses(sat_times,sat_locations_all_sats(:,:,sat_num),sat_locations_all_sats(:,:,other_sat_num));
        [xlnk_windows,indices] = change_to_windows(access_times,5/60/24);
        
        % save AER of all the accesses
        sats_xlnks_range = {};
        for i=1:size(indices,1)
            start_indx = indices(i,1);
            end_indx = indices(i,2);
            range_slice = range(start_indx:end_indx,:);
            sats_xlnks_range = [sats_xlnks_range; range_slice];
        end
        
        xlink{sat_num,other_sat_num} = xlnk_windows;
        xrange{sat_num,other_sat_num} = sats_xlnks_range;
    end
    
end

