# Class definition file for python orbit propagator class

import sys
import numpy as np
from astropy import units as u
from astropy.time import Time, TimeDelta

from poliastro.bodies import Earth
from poliastro.twobody import Orbit, classical, propagation
from poliastro.twobody import angles as twobody_angles
from poliastro.core.perturbations import J2_perturbation, J3_perturbation

from datetime import datetime

import time as py_time

def J23_perturbation(t0, state, k, J2, J3, R):
    '''wrapper function that adds effects of J2 and J3 perturbations'''
    a2 = J2_perturbation(t0,state,k,J2,R)
    a3 = J3_perturbation(t0,state,k,J3,R)

    return a2 + a3

class OrbitPropagator:
    def __init__(self,orbit_prop_inputs,prop_method,use_new_input_format = True):
        """
        orbit_prop_inputs: dict, built from inputs json file
        prop_method: the method used to propagate orbits, accepts 'cowell' or 'kepler'
        """

        if not prop_method == 'cowell' and not prop_method == 'kepler':
            raise NotImplementedError('Only cowell and kepler implemented for poliAstro propagation')

        self.prop_method = prop_method
    
        self.propagation_complete = False
        self.output_dict_made = False
        self.orbit_prop_output_dict = {}

        if use_new_input_format:
            self.start_utc_str = orbit_prop_inputs['start_utc']
            self.end_utc_str = orbit_prop_inputs['end_utc']
            self.timestep_s = orbit_prop_inputs['timestep_s']
            self.num_sats =  orbit_prop_inputs['num_satellites']
            datetime_diff = datetime.strptime(self.end_utc_str,"%Y-%m-%dT%H:%M:%S.%fZ") - datetime.strptime(self.start_utc_str,"%Y-%m-%dT%H:%M:%S.%fZ") 
            end_time_s = datetime_diff.total_seconds()  
            timesteps = np.linspace(0,end_time_s,num=int(end_time_s/self.timestep_s)+1)
            self.timesteps_arr = np.reshape(timesteps,(len(timesteps),1))

            constellation_params = orbit_prop_inputs['sat_orbital_elems'][0]
            if 'walker' in constellation_params.keys():
                self.constellation_type = 'walker'
                self.walker_params = constellation_params['walker']
            elif 'kepler_meananom' in constellation_params.keys():
                self.constellation_type = 'kepler_meananom'
                self.all_orbit_params = orbit_prop_inputs['sat_orbital_elems']
            else:
                raise NotImplementedError('Only Walker constellation and Kelper Mean Anomoly specifications implemented')
        else:
            # input parsing for old input format
            self.scenario_params = orbit_prop_inputs['scenario_params']
            self.timestep_s = orbit_prop_inputs['scenario_params']['timestep_s']
            self.start_utc_str = orbit_prop_inputs['scenario_params']['start_utc']
            self.end_utc_str = orbit_prop_inputs['scenario_params']['end_utc']

            datetime_diff = datetime.strptime(orbit_prop_inputs['scenario_params']['end_utc'],"%Y-%m-%dT%H:%M:%S.%fZ") - datetime.strptime(orbit_prop_inputs['scenario_params']['start_utc'],"%Y-%m-%dT%H:%M:%S.%fZ") 
            end_time_s = datetime_diff.total_seconds()  
            timesteps = np.linspace(0,end_time_s,num=int(end_time_s/self.timestep_s)+1)
            
            self.timesteps_arr = np.reshape(timesteps,(len(timesteps),1))

            constellation_params = orbit_prop_inputs['orbit_params']['sat_orbital_elems'][0]
            if 'walker' in constellation_params.keys():
                self.constellation_type = 'walker'
                self.num_sats = constellation_params['walker']['num_sats']
                self.walker_params = constellation_params['walker']
            elif 'kepler_meananom' in constellation_params.keys():
                self.constellation_type = 'kepler_meananom'
                self.num_sats =  len(orbit_prop_inputs['orbit_params']['sat_orbital_elems'])
                self.all_orbit_params = orbit_prop_inputs['orbit_params']['sat_orbital_elems']
            else:
                raise NotImplementedError('Only Walker constellation and Kelper Mean Anomoly specifications implemented')
        
        self.time_s_pos_eci_km = np.zeros((self.num_sats ,len(timesteps),4))
        self.time_s_vel_eci_km = np.zeros((self.num_sats ,len(timesteps),4))

    def _propagate(self):
        ''' Propagate orbits of all satellites for each timestep in self.timesteps_arr'''
        if self.constellation_type == 'walker':
            sats_per_plane = self.walker_params['num_sats'] / self.walker_params['num_planes']
            a = self.walker_params['a_km'] * u.km
            ecc = 0 * u.one # walks are all circular
            inc = self.walker_params['i_deg'] * u.deg
            argp = 0 * u.deg

            # raan increment
            raan_inc = 360 /self. walker_params['num_planes'] * u.deg
            # nu increment
            nu_inc = 360 / sats_per_plane *u.deg

            raan = 0  * u.deg # use this to space out based on num_planes
            sat_id = 0
            for _ in range(0,self.walker_params['num_planes']):
                nu = 0  * u.deg # use this to space out based on num_sats/num_planes 
                for _ in range(0,int(sats_per_plane)):
                    # create baseline orbit
                    curOrb = Orbit.from_classical(Earth,a,ecc,inc,raan,argp,nu)

                    print('Propagating sat number %d of %d over %d timesteps' % (sat_id+1, self.num_sats,len(self.timesteps_arr)))
                    (r_list,v_list) = self._propagate_curOrb(curOrb)

                    self.time_s_pos_eci_km[sat_id,:,:] = np.hstack((self.timesteps_arr,np.array(r_list)))
                    self.time_s_vel_eci_km[sat_id,:,:] = np.hstack((self.timesteps_arr,np.array(v_list)))
                    
                    sat_id += 1
                    nu += nu_inc
                
                raan += raan_inc
        elif self.constellation_type == 'kepler_meananom':
            # since each satellite has it's own orbit specified, we propagate one satellite at a time
            for sat_id in range(self.num_sats):
                orbit_params = self.all_orbit_params[sat_id][self.constellation_type]
                a = orbit_params['a_km'] * u.km
                ecc = orbit_params['e'] * u.one
                inc = orbit_params['i_deg'] * u.deg
                raan = orbit_params['RAAN_deg'] * u.deg
                # ASSUMES ARGUMENT OF PERIGEE IS ZERO
                argp  = 0 * u.deg
                # convert mean anomaly to true anomaly
                M = orbit_params['M_deg'] * u.deg
                E = twobody_angles.M_to_E(M,ecc) # eccentric anomaly
                nu = twobody_angles.E_to_nu(E,ecc) # true anomaly
                curOrb = Orbit.from_classical(Earth,a,ecc,inc,raan,argp,nu)  
                print('Propagating Sat %d of %d over %d timesteps' % (sat_id+1, self.num_sats,len(self.timesteps_arr)))
                (r_list,v_list) = self._propagate_curOrb(curOrb)

                self.time_s_pos_eci_km[sat_id,:,:] = np.hstack((self.timesteps_arr,np.array(r_list)))
                self.time_s_vel_eci_km[sat_id,:,:] = np.hstack((self.timesteps_arr,np.array(v_list)))
        else:
            raise NotImplementedError('Only Walker constellation  and Kelper Mean Anomoly specifications implemented')

        self.propagation_complete = True

    def _propagate_curOrb(self,curOrb):
        # propagate to get an ECI vector at each timestep
        # by default, this produces a list of numpy arrays where the 
        if self.prop_method == 'cowell':
            (r_list,v_list) = propagation.cowell(curOrb,self.timesteps_arr,ad=J23_perturbation,J2=Earth.J2.value,J3 = Earth.J3.value)
        elif self.prop_method == 'kepler':  
            r_list = [curOrb.state.r.value]
            v_list = [curOrb.state.v.value]
            for _ in range(1,len(self.timesteps_arr)):

                # propagate assumes input is angular, unless explicity a time object
                curOrb = curOrb.propagate(TimeDelta(self.timestep_s,format='sec'))
                r_list.append(curOrb.state.r.value)
                v_list.append(curOrb.state.v.value)
                # reset back to base epoch
                curOrb = Orbit.from_vectors(Earth,curOrb.state.r.value*u.km,curOrb.state.v.value*u.km / u.s)
        else:
            raise NotImplementedError('Only cowell and singleStep implemented for poliAstro propagation')
        
        return (r_list,v_list)

    def _make_output_dict(self,prop_duration_s ):
        key_params = {'timestep_s': self.timestep_s,\
            'start_utc': self.start_utc_str,\
            'end_utc': self.end_utc_str ,\
            'constellation_type': self.constellation_type,\
            'propagation_method': 'python_poliastro'}
        sat_orbit_data_list = []
        for sat_id in range(self.num_sats):
            sat_orbit_data_id = {}
            sat_orbit_data_id['sat_id'] = 'sat' + str(sat_id)
            sat_orbit_data_id['time_s_pos_eci_km'] = self.time_s_pos_eci_km[sat_id,:,:].tolist()
            sat_orbit_data_list.append(sat_orbit_data_id)
        self.orbit_prop_output_dict =  {'scenario_params':key_params,'sat_orbit_data':sat_orbit_data_list,'calculation_duration_s': prop_duration_s}
        self.output_dict_made = True

    def get_eci_vects(self):
        if self.propagation_complete:
            return (self.time_s_pos_eci_km, self.time_s_vel_eci_km)
        else:
            print('Propagation not completed yet, propagating now')
            self._propagate()
            return (self.time_s_pos_eci_km, self.time_s_vel_eci_km)
    
    def get_orbit_prop_output(self):
        if self.propagation_complete:
            if self.output_dict_made:
                return self.orbit_prop_output_dict
            else:
                self._make_output_dict()
                return self.orbit_prop_output_dict
        else:
            print('Propagation not completed yet, propagating now')
            print('Use Case Info:')
            print('Scenario Timing: %d-hour time horizon , %d-second time resolution ' % (self.timesteps_arr[-1]/3600 ,self.timestep_s))
            print('Constellation: has %d sats'% self.num_sats)
            start = py_time.time()
            self._propagate()
            end = py_time.time()
            prop_duration_s = end-start
            self._make_output_dict(prop_duration_s )
            return self.orbit_prop_output_dict
