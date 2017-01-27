function [access_times, az_el_range] = find_accesses_from_ground(times,sat_locations,ground_locations)
% Author: Kit Kennedy

% simple first order approximation to find eclipse times for a satellite in
% orbit around the earth. Assumes sun rays are parallel at earth's orbit,
% and sat is in eclipse when simply behind the earth (no consideration for
% penumbra/umbra difference)

% Inputs:
% Length N array of time strings
% N x 3 array of satellite locations in ECI ref frame
% N x 3 array of sun locations in ECI ref frame

% Outputs:
% Length M array of time strings - each string in here is contained in an
% eclipse


num_timepoints = size(times,1);

access_times = [];
el = [];
r = [];
az = [];

for timepoint_num=1:num_timepoints
    ground_vec = ground_locations(timepoint_num,:);
    
    % calculate vector from ground to satellite
    vec_gr_sat = sat_locations(timepoint_num,:)-ground_vec;
    
    % figure out angle between that vector and the ground_location vector,
    % get elevation
    temp_ang = dot(vec_gr_sat,ground_vec)/norm(vec_gr_sat)/norm(ground_vec);
    temp_el = 90 - acosd(temp_ang);
    
    if temp_el > 0
        el = [el ; temp_el];
        
        % calc and store range 
        r = [r ; norm(vec_gr_sat)];
        
        % now some effort to get azimuth.
        % calc vector rejection of vec_gr_sat on ground_vec (the component of vec_gr_sat that lies on horizontal plane at ground site)
        o = dot(vec_gr_sat,ground_vec/norm(ground_vec))*ground_vec/norm(ground_vec);  % component along ground_vec
        p = vec_gr_sat - o;  % rejection component, in horizontal plane
        
        % calc north vector in horizontal plane
        e = cross([0 0 1],ground_vec); % cross with up direction in eci to get east
        e_hat = e/norm(e);
        n = cross(ground_vec,e);  % cross with east to get north
        n_hat = n/norm(n);
        
        % calc az angle betwen p and n
        n_comp = dot(p,n_hat);
        e_comp = dot(p,e_hat);
        temp_az = atan2d(e_comp,n_comp);
        
        
        az = [az; temp_az];
       
        access_times = [access_times ; times(timepoint_num,:)];
    end
    
end

az_el_range = [az el r];

end