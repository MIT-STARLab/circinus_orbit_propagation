function [access_times, range, alt_of_closest_point] = find_crosslink_accesses(start_time_dt,times_s,sat_locations,other_sat_locations)
% Author: Kit Kennedy

% finds crosslink access times between satellites in earth orbit. It is
% assumed a crosslink is available as long as the vector between the sats
% passes roughly above the surface of the earth (using average earth radius)

% Inputs:
% start_time_dt - matlab datetime corresponding to start of times_s
% times_s - Length N array of times in seconds
% sat_locations - N x 3 array of satellite locations in ECI ref frame
% other_sat_locations - N x 3 array of locations of other sat with which to crosslink, in ECI ref frame

% Outputs:
% access_times - Length M array of time strings - each string in here is
% contained in a crosslink access
% range - Length M array of ranges between sats (km)
% alt_of_closest_point - Length M array of altitude of the closest point
% along vector between sats to the center of the earth (NOTE: this is
% calculated using average earth radius, 6371 km)

R_e = 6371; % km

num_timepoints = size(times_s,1);

access_times = [];
range = [];
alt_of_closest_point = [];

for timepoint_num=1:num_timepoints
    
    closest_dist = point_to_line_distance([0,0,0], sat_locations(timepoint_num,:), other_sat_locations(timepoint_num,:)); % find closest distance of earth center to the LOS_vec
    
    if closest_dist > R_e
        access_times = [access_times ; make_iso_datestr(start_time_dt + seconds(times_s(timepoint_num)))];
        
        range = [range ; norm(other_sat_locations(timepoint_num,:)-sat_locations(timepoint_num,:))];
        
        alt_of_closest_point = [alt_of_closest_point; closest_dist-R_e];
    end
    
end

end