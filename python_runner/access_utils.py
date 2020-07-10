import sys
import numpy as np
from astropy.time import Time

def find_eclipse_times(start_time,timesteps,sat_ECI_t,u_from_sun ):
    """Based off Kit Kennedy's MATLAB version
    simple first order approximation to find eclipse times for a satellite in
    orbit around the earth. Assumes sun rays are parallel at earth's orbit,
    and sat is in eclipse when simply behind the earth (no consideration for
    penumbra/umbra difference)

    Inputs:
        start_time - astropy.time.Time object corresponding to start of timesteps
        timesteps - Length N array of times in seconds
        sat_ECI_t - N x 3 np.array of satellite locations in ECI ref frame (km)
        u_from_sun - N x 3 np.array of unit vectors that represent the direction of the sun's rays at Earth (-)

    Outputs: (M is the number of eclipse times)
        eclipse_times - Length M list of astropy.time.Time objects - each Time in here is contained in an eclipse

    Dependencies:
        -numpy
        -astropy.time
    """
    from astropy.time import TimeDelta
    R_e = 6371 #km
    eclipse_times  =[]

    for t_ind in range(len(timesteps)):
        # find projection of the sat's location vector onto the sunlight unit vector - so, the vector along the axis of the cylinder of eclipsed space behind the earth
        o = np.dot(sat_ECI_t[t_ind,:],u_from_sun[t_ind,:])*u_from_sun[t_ind,:]
        # find the component of the satellites position vector in the plane running through earth that is perpendicular to all the rays from the sun
        p = sat_ECI_t[t_ind,:] - o

        if np.linalg.norm(p) <= R_e:
            if np.dot(o,u_from_sun[t_ind,:]) > 0:
                eclipse_times.append(start_time + TimeDelta(timesteps[t_ind],format='sec'))
    
    return eclipse_times

def gst(jd_mod,day_fracs):
    """This function provides the greenwich apparent mean sidereal time referenced to the
    J2000.0 equinoix.
    INPUTS:
        jd_mod: modified julian date, referred to 1950
        day_fracs: fractions of a day that have passed
    OUTPUTS:
        gwst: greenwich apparent sidereal time in radians
    Based on original function from MATLAB PROPAT library by Valdemir Carrara, Apr 2003"""

    tsj = (jd_mod-18262.5)/36525
    tsgo = (24110.54841 + (8640184.812866 + 9.3104e-2*tsj - 6.2e-6*tsj*tsj)*tsj)*np.pi/43200
    earth_rad_s = 7.292116e-5		# angular velocity of Earth (rad/s)
    return np.mod(tsgo + day_fracs*earth_rad_s, 2*np.pi)

def terrestial_to_inertial(gwst_rad, ECEF):
    '''This function returns the ECI vector associated with the angular distance by gwst_rad and the ECEF vector
    Inputs:
        gwst_rad: (radians) output of the gst function - greenwich apparent sidereal time in radians since JD 9150
        ECEF: 1 x 3 np.array of a location in ECEF ref frame (m or km, assumed stationary)
    Outputs:
        ECI: 1 x 3 np.array of a location in ECI ref frame (same units as ECEF)
    Dependencies:
        -numpy
    '''
    ang = gwst_rad
    c,s = np.cos(-ang), np.sin(-ang)
    rot_z = np.array(((c,s,0),(-s,c,0),(0,0,1)))
    temp_array = np.asarray([ECEF[0],ECEF[1],ECEF[2]])
    return np.matmul(temp_array,rot_z.T)

# this function is run for each satellite and for each observation target
# NOTE: this can be done in parallel for each satellite
# follow same flow as "find_accesses_from_ground.m"
# NOTE: if we can get the Astropy conversion time conversion and frame transformation to work, then calculating accesses should be much easier as well
def find_accesses_from_ground(start_time,timesteps,sat_ECI_t,ground_ECI_t, el_cutoff):
    """Based off Kit Kennedy's MATLAB version
    finds access times and azimuth, elevation, range for a satellite as
    viewed from a ground location.

    Inputs:
        start_time - astropy.time.Time object corresponding to start of timesteps
        timesteps - Length N array of times in seconds
        sat_ECI_t - N x 3 np.array of satellite locations in ECI ref frame (km)
        ground_ECI_t - N x 3 np.array of ground locations in ECI ref frame (km)
        el_cutoff - elevation cutoff angle for accesses (deg)

    Outputs: (M is the number of access times)
        access_times - Length M list of astropy.time.Time objects - each Time in here is contained in an access
        az_el_range - Length M list of three elements lists of az (deg), el (deg), range (km) corresponding to access_times

    Dependencies:
        -numpy
        -astropy.time
    """
    from astropy.time import TimeDelta

    num_timepoints = len(timesteps)
    access_times = []
    az_el_range = []
    # initialize loop variables (lists here, convert to np.array before returning)
    #el = []
    #r = []
    #az =[]
  
    for t_ind in range(num_timepoints):
        gr_vec = ground_ECI_t[t_ind,:]

        # vector from ground to satellite
        gr_sat_vec = sat_ECI_t[t_ind,:] - gr_vec

        # calc angle between vectors (angle from pointing straight up @ ground loc)
        temp_ang = np.dot(gr_vec,gr_sat_vec)/(np.linalg.norm(gr_vec)*np.linalg.norm(gr_sat_vec))

        # convert to elevation angle
        temp_el = 90 - np.arccos(temp_ang)*180/np.pi

        if temp_el > el_cutoff:
            el = temp_el
            r = np.linalg.norm(gr_sat_vec)

            # calc azimuth
            #  vector rejection of gr_sat_vec on gr_vec
            o = np.dot(gr_sat_vec,gr_vec/np.linalg.norm(gr_vec))*gr_vec/np.linalg.norm(gr_vec)
            o_hor = gr_sat_vec - o #rejection component in horizontal plane

            # cross z direction in ECI frame with gr_vec to get East vector
            e = np.cross(np.array([0,0,1]), gr_vec)
            e_hat = e/np.linalg.norm(e)
            e_comp = np.dot(o_hor,e_hat) # don't need to scale o_hor because it cancels out in az calc

            # cross gr_vec with East to get North
            n = np.cross(gr_vec,e)
            n_hat = n/np.linalg.norm(n)
            n_comp = np.dot(o_hor,n_hat)

            az = np.arctan2(e_comp,n_comp)*180/np.pi
            # NOTE: storing these times as an Astropy.time.Time vs. just a JD used over double memory (56 bytes vs. 24 bytes)
            # so we can cut down to just the JD representation if we need to
            access_times.append(start_time + TimeDelta(timesteps[t_ind],format='sec'))
            az_el_range.append([az,el,r])

    return (access_times, az_el_range)


# ground access periods into time windows
def change_to_windows(access_times,window_spacing_days):
    '''Based off Kit Kennedy MATLAB version
    This function turns a non-temporally-continuous list of time points into
    a series of windows by searching through the list and finding time gaps
    larger than window_spacing_days

    Inputs
    access_times - list of astropy.time.Time objects sorted in ascending order
    window_spacing_days - the amount of time that must elapse between two 
        consecutive times in times_list in order for them to be considered
        different windows

    Outputs:
    windows - list of windows, where each element is a single window (list) with the following elements :
        start time (astropy.time.Time), end time (astropy.time.Time), size of window in seconds
    indices - list of two element lists, where first element is the start index of the index and last element is the last index'''
    windows = []
    indices = []
    day_to_sec = 24*60*60
    if len(access_times) == 0:
        return (windows, indices)

    # intialize loop variables
    cur_time = access_times[0].mjd # in mjd
    cur_idx = 0
    start_time = cur_time
    start_idx = cur_idx
    last_time = cur_time
    last_idx = cur_idx

    for i in range(1,len(access_times)):
        last_time = cur_time
        last_idx = cur_idx
        cur_time = access_times[i].mjd
        cur_idx = i

        # close window and move to next one
        # NOTE: if trailing point is start of a new window, new window won't make it into final list
        if cur_time - last_time >= window_spacing_days:
            end_time = last_time
            windows.append([start_time, end_time, (end_time-start_time)*day_to_sec])
            indices.append([start_idx, last_idx+1])
            start_time = cur_time
            start_idx = cur_idx
    # handle case were trailing point was in the middle of a valid window
    if cur_time - last_time < window_spacing_days:
        end_time = cur_time
        windows.append([start_time, end_time, (end_time-start_time)*day_to_sec])
        indices.append([start_idx, last_idx+2])           
    # get rid of first window if it only has one point
    if windows[0][2] == 0:
        windows = windows[1:]
        indices = indices[1:]

    return (windows, indices)

def calc_aer_and_windows_from_ground(start_time,timesteps,sat_ECI_all ,ground_ECI_all, el_cutoff, window_spacing_days, verbose_flag = False, ground_type = "ground"):
    '''Primary function to return Az / El / Range and time windows between all sats and all ground objects.
    Inputs:
        start_time - astropy.time.Time object corresponding to start of timesteps
        timesteps - Length N array of times in seconds
        sat_ECI_all - N x 3 x num_sats np.array of satellite locations in ECI ref frame (km). 
        ground_ECI_all - N x 3 x num_ground np.array of ground locations in ECI ref frame (km)
        el_cutoff - elevation cutoff angle for accesses (deg)
        window_spacing_days - the amount of time that must elapse between two 
        consecutive times in times_list in order for them to be considered
        different windows

    Outputs:
        aer_list: a heavily nested list (to facilite json writing).  Example below from Zhou scenario
        - list with N_sat=6 elements (constant per scenario)
        --[0] list with N_ground=5 elements (constant per scenario)
        ---[0][2] list with N_ob_access_windows = 2 elements (dependent on time horizon and IC)
        ----[0][2][0] list with N_timesteps_per_window = 9 elements (timesteps where that window is active) (dependent on time horizon and IC)
        -----[0][2][0][0] list with 4 elements ((JD_start, Az, El, Range)) (size is constant over all sims, if exists)
        time_windows_list: a heavily nested list (to facilite json writing).  Example below from Zhou scenario
        - list with N_sat=6 elements (constant per scenario)
        --[0] list with N_obs=5 elements (constant per scenario)
        ---[0][2] list with N_ob_access_windows = 2 elements (dependent on time horizon and IC) 
        ----[0][2][0] list with 3 elements (JD_start, JD_end, duration_seconds)
    '''

    time_windows_list = []
    aer_list = []
    num_sats = np.shape(sat_ECI_all)[2]
    num_ground = np.shape(ground_ECI_all)[2]

    for sat_ind in range(num_sats):
        sat_ECI_t = sat_ECI_all[:,:,sat_ind]
        time_windows_list.append([])
        aer_list.append([])
        if verbose_flag:
            print('Calculating %s accesses for Sat %d of %d, updating every 20%%' %(ground_type, sat_ind+1,num_sats))
            prev_ground_status = 0
        for gr_ind in range(num_ground):
            time_windows_list[sat_ind].append([])
            aer_list[sat_ind].append([])
            gr_ECI_t = ground_ECI_all[:,:,gr_ind]
            (access_times, az_el_range) = find_accesses_from_ground(start_time,timesteps,sat_ECI_t ,gr_ECI_t , el_cutoff)
            (obs_windows,indices) = change_to_windows(access_times,window_spacing_days)

            if verbose_flag:
                # print an update every 20%
                ground_status = gr_ind / num_ground -  prev_ground_status
                if ground_status >= .2:
                    print('SAT # %d: On %s object %d of %d' % (sat_ind+1,ground_type, gr_ind, num_ground))
                    prev_ground_status = gr_ind / num_ground 
            # save AER of all accesses, in a list element for each separate window
            aer = []
            for idx,w_inds in enumerate(indices):

                aer.append([])
                start_idx = w_inds[0]
                end_idx = w_inds[1]
                access_times_slice = access_times[start_idx:end_idx]
                az_el_range_slice = az_el_range[start_idx:end_idx]
                for i in range(len(access_times_slice)):
                    mjd = access_times_slice[i].mjd
                    aer[idx].append([mjd] + az_el_range_slice[i])
    
            time_windows_list[sat_ind][gr_ind] = obs_windows
            aer_list[sat_ind][gr_ind] = aer
    return (aer_list, time_windows_list)

# Helper function to find minimum altitude of a crosslink
def point_to_line_distance(pt,l1,l2):
    """Based off Kit Kennedy's MATLAB version, which is based on:
    https://www.mathworks.com/matlabcentral/answers/95608-is-there-a-function-in-matlab-that-calculates-the-shortest-distance-from-a-point-to-a-line
    Inputs: (all are 3x1 numpy arrays)
    pt - the point to find the shortest distance to the line
    l1  - first point on the line
    l2  - second point on the line

    Dependencies:
    -numpy
    -astropy.time
    """
    a = l1 - l2
    b = pt - l2
    # cross product gives area of parallelogram. Dividing by side of parallelogram gives height.
    return np.linalg.norm(np.cross(a,b))/np.linalg.norm(a)

# Crosslink accesses
def find_crosslink_accesses(start_time,timesteps,sat_ECI_t,other_sat_ECI_t,same_plane_fast_forward_flag = False):
    """Based off Kit Kennedy's MATLAB version
    finds crosslink access times between satellites in Earth orbit. It is assumed
    that a crosslink is available as long as the vector between the sats passes
    roughly above the surfce of the Earth (using average Earth Radius of 6371 km)

    Main changes in python version (Default off - changes in range are significant even for in plane sats):
        -Added a speed-up mechanism, where if the closest_dist doesn't change by more than 1 meter over 10 timesteps, then 
        just fill in the rest of the outputs with the current answer
            --Rationale: the two satellites must be in the same plane and their relative distance is not changing

    Inputs:
    start_time - astropy.time.Time object corresponding to start of timesteps
    timesteps - Length N array of times in seconds
    sat_ECI_t - N x 3 np.array of satellite locations in ECI ref frame (km)
    other_sat_ECI_t - N x 3 np.array of target satellite locations in ECI ref frame (km)

    Outputs: (M is the number of access times)
    access_times - Length M list of astropy.time.Time objects - each Time in here is contained in an access
    ranges - Length M list of range (km) between the sats
    alt_of_closest_points - Length M list of altitude of closest point to Earth along the vector between sats

    Dependencies:
    -numpy
    -astropy.time
    """
    from astropy.time import TimeDelta
    R_e = 6371 #km

    access_times = []
    ranges = []
    alt_of_closest_points = []
    same_flag = False
    if same_plane_fast_forward_flag:
        same_counter = 0
        threshold_km = 0.001
        threshold_counts = 10
        
        
    c = np.array([0,0,0])
    for t_ind in range(len(timesteps)):
        closest_dist = point_to_line_distance(c,sat_ECI_t[t_ind,:],other_sat_ECI_t[t_ind,:])

        if same_plane_fast_forward_flag and t_ind > 0:
            if np.abs(closest_dist-prev_closest_dist) < threshold_km:
                same_counter =+ 1
            if same_counter > threshold_counts:
                same_flag = True
                break

        prev_closest_dist = closest_dist

        if closest_dist > R_e:
            access_times.append(start_time + TimeDelta(timesteps[t_ind],format='sec'))
            ranges.append(np.linalg.norm(other_sat_ECI_t[t_ind,:]-sat_ECI_t[t_ind,:]))
            alt_of_closest_points.append(closest_dist-R_e)

    if same_plane_fast_forward_flag and same_flag:
        static_range = ranges[-1]
        static_alt = alt_of_closest_points[-1]
        for _ in timesteps[t_ind:]:
            access_times.append(start_time + TimeDelta(timesteps[t_ind],format='sec'))
            ranges.append(static_range)
            alt_of_closest_points.append(static_alt)

    return (access_times,ranges,alt_of_closest_points)



