# Class definition file for python accesses calculator class

import numpy as np
from astropy import units as u
from astropy.time import Time, TimeDelta

from poliastro.bodies import Earth
from poliastro.twobody import Orbit, classical, propagation

import access_utils

from datetime import datetime
import time

SEC_TO_DAY = 1/(24*60*60)

class AccessesCalculator:
    def __init__(self,orbit_prop_inputs,sat_orbit_data,verbose_flag = True, cached_accesses = None, window_spacing_days = 5/60/24,use_new_input_format = True):
        """
        orbit_prop_inputs: dict, built from inputs json file
        sat_orbit_data: dict, containing the ECI vectors for each timestep for each satellite
        cached_accesses: a dict containing cached accesses (may be partially populated), will use whatever is already populated
        """
        # main TODO: should be able to use any subset of accesses (dlnk, xlnk, obs, eclipse) if they haven't changed
        # this can probably be implemented in the .get_all_accesses_dict() method by deciding which access to run
        if cached_accesses:
            raise NotImplementedError('Use of cached_acceses not implemented yet')

        if use_new_input_format:
            self.crosslinks_flag = orbit_prop_inputs['use_crosslinks']
            self.start_time = Time(orbit_prop_inputs['start_utc'], scale = 'utc')
        else:
            self.crosslinks_flag = orbit_prop_inputs['scenario_params']['use_crosslinks']
            self.start_time = Time(orbit_prop_inputs['scenario_params']['start_utc'], scale = 'utc')
            

        # General Params
        self.timesteps = np.asarray(sat_orbit_data[0]['time_s_pos_eci_km'])[:,0]
        self.window_spacing_days = window_spacing_days
        self.verbose_flag = verbose_flag

        # Sats
        self.num_sats = len(sat_orbit_data)
        sat_ECI_all = np.zeros((len(self.timesteps),3,self.num_sats))
        for sat_ind in range(self.num_sats):
            sat_ECI_t = np.asarray(sat_orbit_data[sat_ind]['time_s_pos_eci_km'])[:,1:]
            sat_ECI_all[:,:,sat_ind] = sat_ECI_t
        self.sat_ECI_all = sat_ECI_all

        # Ground Stations
        self.el_cutoff_gs = orbit_prop_inputs['gs_params']['elevation_cutoff_deg']
        self.stations_list = orbit_prop_inputs['gs_params']['stations']
        self.gs_name = orbit_prop_inputs['gs_params']['gs_network_name']

        # Observations
        self.el_cutoff_obs = orbit_prop_inputs['obs_params']['elevation_cutoff_deg']
        self.obs_list = orbit_prop_inputs['obs_params']['targets']
        self.obs_name  = orbit_prop_inputs['obs_params']['target_set_name']

    def _convert_geodetic_to_terrestial_list(self,geodetic_list):
        from astropy.coordinates.earth import EarthLocation
        """ # NOTE: the geodetic list must be a list of dictionary objects that have fields:
        - latitude_deg
        - longitude_deg
        - height_m """
        ground_locations = []
        ground_ECEF = []
        for gs in geodetic_list:
            gs_EarthLoc = EarthLocation.from_geodetic(lat=gs['latitude_deg']*u.deg,lon = gs['longitude_deg']*u.deg,height=gs['height_m']*u.m)
            ground_locations.append(gs_EarthLoc)
            ground_ECEF.append(gs_EarthLoc.value)
        
        return ground_ECEF

    def _calculate_angular_gwst(self):
        # TODO: refactor to remove this once the error below is addressed
        """ test_ob = obs_locations[0]
        from astropy.coordinates.builtin_frames import GCRS
        day0= test_ob.get_gcrs(obstime = start_time)
        daydefault = test_ob.get_gcrs(obstime = Time('J2000',scale='utc') )
        # convert ECEF to ECI at each timestep (can use .get_gcrs(obstime = astropy.time.Time object))
        # NOTE: this does not work in the current version of Astropy.  I get an error: "ValueError: invalid literal for int() with base 10: 'N'"
        #    appears to be independent of "obstime" used and the frame being converted to.  
        #    NOTE: that the same error occurs when I try to do time conversions to greenwich mean time!  So it is probably a time object error
        #    NOTE: I tried example code with sidereal time and it also failed with the same error: http://docs.astropy.org/en/stable/time/#sidereal-time
        #   gcrs should get me an inertial value, but it will be in RA, DEC, dist, so need to convert to ECI x-y-z
        """

        # convert ECEF
        all_times_JD = self.start_time.mjd + self.timesteps*SEC_TO_DAY
        # retrieve day fractions
        all_day_fractions = np.modf(self.start_time.mjd + self.timesteps*SEC_TO_DAY)[0]
        # to get the same as Kit's result and because of the Astropy error noted above,
        #  we will reimplement the methods from the MATLAB library used
        # The MATLAB PROPAT library uses a base JD from 1950 for some reason, for testing we use the same base in the gst() function
        mjd_base = Time('J1950.0', scale = 'utc')
        jd_mod = all_times_JD - mjd_base.mjd
        gwst = access_utils.gst(jd_mod,all_day_fractions*86400 )

        return gwst

    def _convert_all_ECEF_to_ECI(self, ground_ECEF):
        num_ground = len(ground_ECEF)
        ground_ECI_all = np.zeros((len(self.timesteps),3,num_ground ))
        gwst = self._calculate_angular_gwst()
        for t_ind, ang in enumerate(gwst):
            for ground_ind in range(num_ground):
                ground_loc = ground_ECEF[ground_ind]
                ground_ECI_all[t_ind,:,ground_ind] = access_utils.terrestial_to_inertial(ang,ground_loc) / 1000 # CONVERT TO KM 
        
        return ground_ECI_all


    def calc_obs_accesses(self):
        ''' Wrapper function for calculating observation of targets access AER and windows'''
        obs_ECEF = self._convert_geodetic_to_terrestial_list(self.obs_list)
        obs_ECI_all = self._convert_all_ECEF_to_ECI(obs_ECEF)
        if self.verbose_flag:
            print('Calculating Observation Access Windows')
        (obs_aer, obs_times) = access_utils.calc_aer_and_windows_from_ground(self.start_time,self.timesteps,self.sat_ECI_all ,obs_ECI_all, self.el_cutoff_obs, self.window_spacing_days,self.verbose_flag,ground_type ='observation')

        return (obs_aer, obs_times)

    def calc_dlnk_accesses(self):
        ''' Wrapper function for calculating downlink to ground stations access AER and windows'''
        gs_ECEF = self._convert_geodetic_to_terrestial_list(self.stations_list)
        gs_ECI_all = self._convert_all_ECEF_to_ECI(gs_ECEF)
        if self.verbose_flag:
            print('Calculating Downlink Access Windows')
        (dlnk_aer, dlnk_times) = access_utils.calc_aer_and_windows_from_ground(self.start_time,self.timesteps,self.sat_ECI_all ,gs_ECI_all, self.el_cutoff_gs, self.window_spacing_days, self.verbose_flag,ground_type ='ground station')

        return (dlnk_aer, dlnk_times)

    def calc_eclipse_times(self):
        from astropy.coordinates import get_sun

        all_times = self.start_time + self.timesteps*SEC_TO_DAY
        sun_vects = get_sun(all_times).cartesian.get_xyz().value.T
        u_from_sun = np.transpose(-sun_vects.T / np.linalg.norm(sun_vects,axis=1))
        ecl_times = []
        for sat_ind in range(self.num_sats):
            if self.verbose_flag:
                print('Calculating eclipse windows for sat %d of %d' % (sat_ind+1, self.num_sats))
            ecl_times.append([])
            eclipse_times = access_utils.find_eclipse_times(self.start_time,self.timesteps,self.sat_ECI_all[:,:,sat_ind],u_from_sun )
            ecl_times[sat_ind],_ = access_utils.change_to_windows(eclipse_times,self.window_spacing_days)

        return ecl_times

    def calc_xlnk_accesses(self):
        xlnk_times = []
        xlnk_range = []
        for sat_ind in range(self.num_sats):
            sat_ECI_t = self.sat_ECI_all[:,:,sat_ind]
            xlnk_times.append([])
            xlnk_range.append([])
            print('Calculating xlnk windows for sat %d of %d' % (sat_ind+1, self.num_sats))
            
            # add empty lists for sats that have a smaller index (including the sat itself)
            for _ in range(sat_ind+1):
                xlnk_times[sat_ind].append([])
                xlnk_range[sat_ind].append([])

            # NOTE: this inner loop can be done in parallel
            for other_sat_ind in range(sat_ind+1,self.num_sats):
                xlnk_times[sat_ind].append([])
                xlnk_range[sat_ind].append([])
                other_sat_ECI_t = self.sat_ECI_all[:,:,other_sat_ind]
                (access_times, ranges,alt_of_closest_points) = access_utils.find_crosslink_accesses(self.start_time,self.timesteps,sat_ECI_t ,other_sat_ECI_t)
                (xlnk_windows,indices) = access_utils.change_to_windows(access_times,self.window_spacing_days)

                # save range & min alt of all accesses, in a list element for each separate window
                sats_xlnks_range = []
                for idx,w_inds in enumerate(indices):
                    sats_xlnks_range.append([])
                    start_idx = w_inds[0]
                    end_idx = w_inds[1]
                    access_times_slice = access_times[start_idx:end_idx]
                    ranges_slice = ranges[start_idx:end_idx]
                    alts_slice = alt_of_closest_points[start_idx:end_idx]
                    for i in range(len(access_times_slice)):
                        mjd = access_times_slice[i].mjd
                        sats_xlnks_range[idx].append([mjd, ranges_slice[i], alts_slice[i]])

                xlnk_times[sat_ind][other_sat_ind] = xlnk_windows
                xlnk_range[sat_ind][other_sat_ind] = sats_xlnks_range

        return (xlnk_range,xlnk_times)


    def get_all_accesses_data(self):
        # TODO: implement loading from cached accesses, instead of recalculating if cached accesses fields are not empty

        
        start = time.time()
        (obs_aer, obs_times) = self.calc_obs_accesses()
        obs_accesses_time = time.time() - start

        start = time.time()
        (dlnk_aer, dlnk_times) = self.calc_dlnk_accesses()
        dlnk_accesses_time = time.time() - start

        # NOTE: xlnk windows should always be calculated even if they are note used for BDT because
        # the same windows are used for planning communications
        start = time.time()
        (xlnk_range,xlnk_times) = self.calc_xlnk_accesses()
        xlnk_accesses_time = time.time() - start


        start = time.time()
        ecl_times = self.calc_eclipse_times()
        ecl_accesses_time = time.time() - start

        if self.verbose_flag:
            print('Obs Accesses Calc Time: %f seconds'% obs_accesses_time)
            print('Dlnk Accesses Calc Time: %f seconds'% dlnk_accesses_time)
            print('Xlnk Accesses Calc Time: %f seconds'% xlnk_accesses_time)
            print('Eclipse Accesses Calc Time: %f seconds'% ecl_accesses_time)


        accesses_data = {
            'dlnk_aer': dlnk_aer,
            'dlnk_times': dlnk_times,
            'obs_aer': obs_aer,
            'obs_times': obs_times,
            'xlnk_range': xlnk_range,
            'xlnk_times': xlnk_times,
            'ecl_times': ecl_times,
            'calculation_durations': {
                'obs':obs_accesses_time,
                'dlnks': dlnk_accesses_time,
                'xlnks': xlnk_accesses_time,
                'ecl': ecl_accesses_time
            }
        }

        return accesses_data



    
        


    



        


