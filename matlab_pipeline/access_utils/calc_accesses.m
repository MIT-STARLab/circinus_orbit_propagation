function [obs,obsaer,gslink,gsaer,sunecl,xlink,xrange] = calc_accesses(all_sats_t_r_eci, params, base_directory,verbose)

% Author: Kit Kennedy
% Adapted from calc_and_store_accesses to remove file io, and enable
% wrapping from python

% all_sats_t_r_eci is cell array of matrices for every sat that look like this:
% | t (sec) | x_eci (km) | y_eci (km) | z_eci (km) |
% |  0.0    | 3000.0000  | 4000.0000  | -100.0000  |
% |  1.0    | 3004.0000  | 4002.0000  |  -99.0000  |
% |  ...    | ...        | ...        | ...        |

% TODO:  this code currently only uses modified Julian date for absolute output times.  ideally this should be configurable

%% Fix parameters

addpath(strcat(base_directory,'/matlab_tools'));
start_time_dt = parse_iso_datestr(params.scenario_start_utc);

num_sats = params.num_sats;
num_obs_targets = params.num_obs_targets;
num_gs = params.num_gs;   % num ground stations
el_cutoff = params.el_cutuff_gs_deg; % elevation cutoff for finding ground accesses.
el_cutoff_obs = params.el_cutuff_obs_deg; % elevation cutoff for finding obs times. 
yes_crosslinks = params.use_crosslinks;  % calculate crosslink accesses or not

% sat orbit data
if params.all_sats_same_time_system
    sat_times_s = all_sats_t_r_eci{1}(:,1);
else
   error('calc_accesses.m: Disimilar time systems across sats not yet implemented!');
end

num_timepoints = size(sat_times_s,1);

% lists of obs and gs latitudes and longitudes
obs_lat_lon_rad = params.obs_lat_lon_deg*pi/180;
gs_lat_lon_rad = params.gs_lat_lon_deg*pi/180;

%% Set up Path

addpath(strcat(base_directory,'/libraries/Solar_Ephemeris/demo_sun2'));
addpath(strcat(base_directory,'/libraries/PROPAT/propat_code'));

%% Calculate eclipse times

if verbose
    disp('calculate eclipse times');
end

% initialize sun ephemeris globals for sun2 below (holy cow that library is hacky AF)
global suncoef
suncoef = 1;

rsun = zeros(num_timepoints,3);
for timepoint_num=1:num_timepoints
    jdate = juliandate(start_time_dt + seconds(sat_times_s(timepoint_num)));
    [rasc, decl, rsun(timepoint_num,:)] = sun2 (jdate);  % rsun in km
end

sunecl = cell(1,num_sats);
parfor sat_num = 1:num_sats
    if verbose
        sat_num
    end
    
    eclipse_times = find_eclipse_times(start_time_dt,sat_times_s,all_sats_t_r_eci{sat_num},rsun);
    sunecl{1,sat_num} = change_to_windows(eclipse_times,5/60/24);  % make eclipse windows, with a spaceing of at least 5 minutes between windows
end

%% Calculate Observation Times and AER

if verbose
    disp('calculate observation times');
end

% Determine obs coordinates in ECEF. Only one point because doesn't change
target_ecef_xyz = zeros(num_obs_targets,3);
parfor target_num=1:num_obs_targets
    % target_lat_lon_rad is a "broadcast variable", but it's so small of an 
    % array it doesn't really matter
    target_ecef_xyz(target_num,:) = sph_geodetic_to_geocentric([obs_lat_lon_rad(target_num,2),obs_lat_lon_rad(target_num,1),0])/1000; % long, lat, alt (assuming zero for all targets). Output in km.
end

% get ECI positions of targets as function of time
target_eci_xyz = zeros(num_timepoints,3,num_obs_targets);
gwst = zeros(num_timepoints,1);
for timepoint_num=1:num_timepoints
    dt = start_time_dt + seconds(sat_times_s(timepoint_num));
    mjdi = djm(day(dt), month(dt), year(dt));  % get modified julian day for ECEF -> ECI conversion
    dayf = mod(datenum(dt),1)*86400;  % get fraction of day in seconds
    gwst(timepoint_num) = gst(mjdi,dayf);  % get greenwhich sidereal time in radians
end
    
if verbose
    disp('calc eci');
end
parfor target_num=1:num_obs_targets
    if verbose
        target_num
    end
    
    for timepoint_num=1:num_timepoints
        temp = terrestrial_to_inertial (gwst(timepoint_num), [target_ecef_xyz(target_num,:),0,0,0]);  % zeros because the function also requires a velocity input, but we don't care about that.
        target_eci_xyz(timepoint_num,:,target_num) = temp(1:3);  % km
    end
end

if verbose
    disp('calc obs, obs aer');
end

obs = cell(num_sats,num_obs_targets);
obsaer = cell(num_sats,num_obs_targets);
parfor sat_num = 1:num_sats
    if verbose
        sat_num
    end
    
    for target_num=1:num_obs_targets
        
        % find obs target overpasses, and then turn into windows
        [access_times, az_el_range] = find_accesses_from_ground(start_time_dt,sat_times_s,all_sats_t_r_eci{sat_num},target_eci_xyz(:,:,target_num),el_cutoff_obs);
        [obs_windows,indices] = change_to_windows(access_times,5/60/24);
        
        % save AER of all the accesses
        aer = {};
        for i=1:size(indices,1)
            start_indx = indices(i,1);
            end_indx = indices(i,2);
            access_times_slice = access_times(start_indx:end_indx,:);
            az_el_range_slice = az_el_range(start_indx:end_indx,:);
            
            aer = [aer; mjuliandate(parse_iso_datestr(access_times_slice)) az_el_range_slice];
        end
        
        obs{sat_num,target_num} = obs_windows;
        obsaer{sat_num,target_num} = aer;
    end
    
end


%% Calculate Downlink Times and AER

if verbose
    disp('calculate downlink times');
end

% Determine gs coordinates in ECEF. Only one point because doesn't change
gs_ecef_xyz = zeros(num_gs,3);
parfor gs_num=1:num_gs
    % gs_lat_lon_rad is a "broadcast variable", but it's so small of an 
    % array it doesn't really matter
    gs_ecef_xyz(gs_num,:) = sph_geodetic_to_geocentric([gs_lat_lon_rad(gs_num,2),gs_lat_lon_rad(gs_num,1),0])/1000; % long, lat, alt (assuming zero for all targets). Output in km.
end

% get ECI positions of gs as function of time
gs_eci_xyz = zeros(num_timepoints,3,num_gs);
gwst = zeros(num_timepoints,1);
for timepoint_num=1:num_timepoints
    dt = start_time_dt + seconds(sat_times_s(timepoint_num));
    mjdi = djm(day(dt), month(dt), year(dt));  % get modified julian day for ECEF -> ECI conversion
    dayf = mod(datenum(dt),1)*86400;  % get fraction of day in seconds
    gwst(timepoint_num) = gst(mjdi,dayf);  % get greenwhich sidereal time in radians
end
   
if verbose
    disp('calc eci');
end
parfor gs_num=1:num_gs
    if verbose
        gs_num
    end
    
    for timepoint_num=1:num_timepoints
        temp = terrestrial_to_inertial (gwst(timepoint_num), [gs_ecef_xyz(gs_num,:),0,0,0]);  % zeros because the function also requires a velocity input, but we don't care about that.
        gs_eci_xyz(timepoint_num,:,gs_num) = temp(1:3);  % km
    end
end

if verbose
    disp('calc gslink, gsaer');
end

gslink = cell(num_sats,num_gs);
gsaer = cell(num_sats,num_gs);
for sat_num = 1:num_sats
    if verbose
        sat_num
    end
    
    for gs_num=1:num_gs
        
        % find obs target overpasses, and then turn into windows
        [access_times, az_el_range] = find_accesses_from_ground(start_time_dt,sat_times_s,all_sats_t_r_eci{sat_num},gs_eci_xyz(:,:,gs_num),el_cutoff);
        [dlnk_windows,indices] = change_to_windows(access_times,5/60/24);
        
        % save AER of all the accesses
        aer = {};
        for i=1:size(indices,1)
            start_indx = indices(i,1);
            end_indx = indices(i,2);
            access_times_slice = access_times(start_indx:end_indx,:);
            az_el_range_slice = az_el_range(start_indx:end_indx,:);
            
            aer = [aer; mjuliandate(parse_iso_datestr(access_times_slice)) az_el_range_slice];
        end
        
        gslink{sat_num,gs_num} = dlnk_windows;
        gsaer{sat_num,gs_num} = aer;
    end
    
end


%% Calculate Crosslink Times and Ranges

if verbose
    disp('calculate crosslink times');
end

% TODO: incorporate usage of cached xlnk data again?

if yes_crosslinks

    xlink = cell(num_sats,num_sats);
    xrange = cell(num_sats,num_sats);
    for sat_num = 1:num_sats
        if verbose
            sat_num
        end

        sat_positions_sat = all_sats_t_r_eci{sat_num}; % do this before the parfor so that sat_positions_sat is slicable below and we don't have to send the whole array!

        parfor other_sat_num=sat_num+1:num_sats  % need the parfor on the second level so that e.g. xlink{sat_num,other_sat_num} call below is slicable

            % find obs target overpasses, and then turn into windows
            [access_times, range, alt_of_closest_point] = find_crosslink_accesses(start_time_dt,sat_times_s,sat_positions_sat,all_sats_t_r_eci{other_sat_num});
            [xlnk_windows,indices] = change_to_windows(access_times,5/60/24);

            % save AER of all the accesses
            sats_xlnks_range = {};
            for i=1:size(indices,1)
                start_indx = indices(i,1);
                end_indx = indices(i,2);
                access_times_slice = access_times(start_indx:end_indx,:);
                range_slice = range(start_indx:end_indx,:);
                alt_of_closest_point_slice = alt_of_closest_point(start_indx:end_indx,:);
                sats_xlnks_range = [sats_xlnks_range; mjuliandate(parse_iso_datestr(access_times_slice)) range_slice alt_of_closest_point_slice];
            end

            xlink{sat_num,other_sat_num} = xlnk_windows;  % Note: had a problem earlier where I declared 'xlink' to be the wrong size, and kept on getting abstruse "you can't index this way!!1" errors from matlab. Super helpful  debug message (not). To be on the lookout for in future... 
            xrange{sat_num,other_sat_num} = sats_xlnks_range;
        end

    end

end
