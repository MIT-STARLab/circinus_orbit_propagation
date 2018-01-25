function eclipse_times = find_eclipse_times(start_time_dt,times_s,sat_t_r_eci,sun_locations)
% Author: Kit Kennedy

% simple first order approximation to find eclipse times for a satellite in
% orbit around the earth. Assumes sun rays are parallel at earth's orbit,
% and sat is in eclipse when simply behind the earth (no consideration for
% penumbra/umbra difference)

% Inputs:
% Length N array of time strings
% start_time_dt - matlab datetime corresponding to start of times_s
% times_s - Length N array of times in seconds
% N x 3 array of satellite locations in ECI ref frame
% N x 3 array of sun locations in ECI ref frame

% Outputs:
% Length M array of time strings - each string in here is contained in an
% eclipse

R_e = 6371; % km

eclipse_times = [];

for i=1:size(sat_t_r_eci,1)
    sun_vec = sun_locations(i,:);
    sunlight_unit_vec = -1*sun_vec./norm(sun_vec);  % direction vector for sunlight arriving at earth - assuming all rays from sun are parallel by the time they reach earth
    
    sat_loc_vec = sat_t_r_eci(i,2:4);
    o = dot(sat_loc_vec,sunlight_unit_vec)*sunlight_unit_vec;  % the projection of the sat's location vector onto the sunlight unit vector - so, the vector along the axis of the cylinder of eclipsed space behind the earth
    p = sat_loc_vec - o;  % the component of the satellites position vector in the plane running through earth that is perpendicular to all the rays from the sun
    
    if norm(p) <= R_e 
        if dot(o,sunlight_unit_vec) > 0
            % then there is an eclipse
            eclipse_times = [eclipse_times; make_iso_datestr(start_time_dt + seconds(times_s(i)))]; 
        end
    end
end

end