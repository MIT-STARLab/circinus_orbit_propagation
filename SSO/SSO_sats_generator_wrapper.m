automated_generation = 1;

for sats_per_orbit=10:10
    sats_per_orbit
    
    % Propagate sat orbits

    % inputs
    num_sats_orbit_1 = sats_per_orbit;
    num_sats_orbit_2 = sats_per_orbit;

    SSO_file_writer


    % calculate geometry

    % inputs
    num_sats = num_sats_orbit_1 + num_sats_orbit_2;

    SSO_accesses_MDO_new_obs
end