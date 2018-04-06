#! /usr/bin/env python

##
# Python runner for MATLAB orbit prop pipeline
# @author Kit Kennedy
#

import sys
import time
import os.path
import matlab
import argparse

from run_tools import istring2dt

#  local repo includes. todo:  make this less hackey
sys.path.append ('..')
from  prop_tools  import orbits
from circinus_tools import io_tools
from circinus_tools.matlab_if import MatlabIF

REPO_BASE = os.path.abspath(os.pardir)  # os.pardir aka '..'
MATLAB_PIPELINE_ENTRY = os.path.join(
    REPO_BASE, 'matlab_pipeline', 'pipeline_entry')

OUTPUT_JSON_VER = '0.2'


class PipelineRunner:

    def __init__(self):
        self.matlabif = None

    def propagate_orbit(self, orb_params, end_time_s, timestep_s):

        if not self.matlabif:
            self.matlabif = MatlabIF(paths=[MATLAB_PIPELINE_ENTRY])

        orb_elems_flat = []
        if 'kepler_meananom' in orb_params:

            # create inputs as needed by matlab
            orb_elems = orb_params['kepler_meananom']
            orb_elems_flat = [
                orb_elems['a_km'],
                orb_elems['e'],
                orb_elems['i_deg'],
                orb_elems['RAAN_deg'],
                orb_elems['arg_per_deg'],
                orb_elems['M_deg']
            ]

        else:
            raise NotImplementedError

        # matlab-ify the args
        orb_elems_flat_ml = matlab.double(orb_elems_flat)
        end_time_s_ml = matlab.double([end_time_s])
        timestep_s_ml = matlab.double([timestep_s])

        if orb_params['propagation_method'] == 'matlab_delkep':
            (t_r) = self.matlabif.call_mfunc(
                'orbit_prop_wrapper',
                orb_elems_flat_ml,
                end_time_s_ml,
                timestep_s_ml,
                nargout=1)

            #  convert matlab output types to python types

            time_pos = MatlabIF.mlarray_to_list(t_r)

            # can add other key value pairs to this dict, to put in
            # final out file
            other_kwout = {}

            return time_pos, other_kwout

        else:
            raise NotImplementedError

    def grok_orbit_params(self, sat_orbit_params, version):
        """
        Here's where you can take orbit meta params like '60:30/3/1 
        Walker constellation' and turn it into a list of flattened 
        elements, e.g. a list of keplerian elements of epoch at scenaria 
        start for every satellite

        :param sat_orbit_params: section of input json related to sat 
        orbit params, possibly containing orbit meta params
        :return: flattened orbit params, i.e. a list of orbit params for
         each individual satellite
        """

        # TODO: add handling for meta orbit params, e.g. set of
        # satellites in orbit planes, or even whole constellations

        if version == "0.3":
            sat_orbit_params_flat = []
            # sat_id_order_default = []

            for params in sat_orbit_params:
                if "walker" in  params:
                    if not "synthesize" in params["sat_ids"]:
                        raise Exception(" when forming orbit parameters from a Walker constellation, need a synthesize token in the sat_ids field")

                    flat_params = orbits.flatten_walker(params)
                    sat_orbit_params_flat  += flat_params
                    # sat_id_order_default  += sat_ids_str

                if "kepler_meananom" in params:
                    sat_orbit_params_flat.append(params)
                    # sat_id_order_default.append (params['sat_id'])

            # print(json.dumps (sat_orbit_params_flat))
            return sat_orbit_params_flat

        else:
            raise NotImplementedError

    def process_orbits(self, orbit_prop_inputs):
        """
        Handles the production of orbit propagation result data from the 
        parameters provided in json

        :param orbit_prop_inputs: highest-level input json object
        :return: output json with raw orbit prop data
        """

        if not self.matlabif:
            self.matlabif = MatlabIF(paths=[MATLAB_PIPELINE_ENTRY])

        if orbit_prop_inputs['version'] == "0.3":
            sat_orbit_data = []
            scenario_params = orbit_prop_inputs['scenario_params']
            end_time_s = (istring2dt(scenario_params['end_utc']) -
                          istring2dt(scenario_params['start_utc']))\
                .total_seconds()
            timestep_s = scenario_params['timestep_s']

            sat_orbit_params_flat = self.grok_orbit_params(
                orbit_prop_inputs['sat_orbit_params'], orbit_prop_inputs['version'])

            if len(sat_orbit_params_flat) !=  orbit_prop_inputs['sat_params']['num_satellites']:
                raise Exception ('Number of satellites is not equal to the length of satellite parameters list')

            for orb_params in sat_orbit_params_flat:
                orbit_data, other_kwout = self.propagate_orbit(
                    orb_params, end_time_s, timestep_s)

                single_orbit_data = {}
                single_orbit_data['sat_id'] = str(orb_params['sat_id'])
                single_orbit_data['time_s_pos_km'] = orbit_data
                # add any additional keyword fields to this dict
                single_orbit_data.update(other_kwout)

                sat_orbit_data.append(single_orbit_data)

            return sat_orbit_data

        else:
            raise NotImplementedError

    def process_accesses(self, orbit_prop_inputs, sat_orbit_data, cached_accesses_data):
        """

        :param orbit_prop_inputs: highest-level input json object
        :return: output json with raw orbit prop data
        """

        accesses_data = {}

        # matlab-ify the args
        params_ml = {}
        if orbit_prop_inputs['version'] == "0.3":
            params_ml['scenario_start_utc'] = \
                orbit_prop_inputs['scenario_params']['start_utc']
            params_ml['num_sats'] = matlab.double(
                [orbit_prop_inputs['sat_params']['num_satellites']])
            params_ml['use_crosslinks'] = matlab.logical(
                [orbit_prop_inputs['scenario_params']['use_crosslinks']])
            params_ml['all_sats_same_time_system'] = matlab.logical(
                [orbit_prop_inputs['scenario_params']['all_sats_same_time_system']])
            params_ml['verbose'] = matlab.logical(
                [orbit_prop_inputs['scenario_params']['matlab_verbose']])

            obs_params = orbit_prop_inputs['obs_params']
            params_ml['el_cutuff_obs_deg'] = matlab.double(
                [obs_params['elevation_cutoff_deg']])
            lat_lon_deg = matlab.double(
                [[o['latitude_deg'], o['longitude_deg']] for o in
                 obs_params['targets']])
            params_ml['obs_lat_lon_deg'] = matlab.double(lat_lon_deg)
            params_ml['num_obs_targets'] = matlab.double([len(lat_lon_deg)])

            if len(lat_lon_deg) != obs_params['num_targets']:
                raise Exception ('Number of observation targets is not equal to the length of observation target parameters list')

            gs_params = orbit_prop_inputs['gs_params']
            params_ml['el_cutuff_gs_deg'] = matlab.double(
                [gs_params['elevation_cutoff_deg']])
            lat_lon_deg = matlab.double(
                [[g['latitude_deg'], g['longitude_deg']] for g in
                 gs_params['stations']])
            params_ml['gs_lat_lon_deg'] = matlab.double(lat_lon_deg)
            params_ml['num_gs'] = matlab.double([len(lat_lon_deg)])

            if len(lat_lon_deg) != gs_params['num_stations']:
                raise Exception ('Number of ground stations is not equal to the length of ground station parameters list')

            num_satellites = orbit_prop_inputs['sat_params']['num_satellites']

            sat_id_order= orbit_prop_inputs['sat_params']['sat_id_order']
            # in the case that this is default, then we need to grab a list of all the satellite IDs. We'll take this from all of the satellite IDs found in the orbit parameters
            if sat_id_order == 'default':
                dummy, all_sat_ids = io_tools.unpack_sat_entry_list(  orbit_prop_inputs['sat_orbit_params'],force_duplicate =  True)
            #  make the satellite ID order. if the input ID order is default, then will assume that the order is the same as all of the IDs passed as argument
            sat_id_order = io_tools.make_and_validate_sat_id_order(sat_id_order,num_satellites,all_sat_ids)


        sat_orbit_data_sorted = io_tools.sort_input_params_by_sat_IDs(sat_orbit_data,sat_id_order)

        params_ml['use_cached_accesses'] = True if cached_accesses_data else False

        time_s_pos_km_flat_ml = []
        if OUTPUT_JSON_VER == "0.2":
            for elem in sat_orbit_data_sorted:
                time_s_pos_km_flat_ml.append(
                    matlab.double(elem['time_s_pos_km']))
        else:
            raise NotImplementedError

        if not self.matlabif:
            self.matlabif = MatlabIF(paths=[MATLAB_PIPELINE_ENTRY])

        (obs, obsaer, gslink, gsaer, sunecl, xlink, x_range) = \
            self.matlabif.call_mfunc(
            'accesses_wrapper',
            time_s_pos_km_flat_ml,
            params_ml,
            nargout=7)

        accesses_data['obs_times'] = MatlabIF.deep_convert_matlab_to_python (obs)
        accesses_data['obs_aer'] = MatlabIF.deep_convert_matlab_to_python (obsaer)
        accesses_data['dlnk_times'] = MatlabIF.deep_convert_matlab_to_python (gslink)
        accesses_data['dlnk_aer'] = MatlabIF.deep_convert_matlab_to_python (gsaer)

        if cached_accesses_data:
            accesses_data['ecl_times'] = cached_accesses_data['ecl_times']
            accesses_data['xlnk_times'] = cached_accesses_data['xlnk_times']
            accesses_data['xlnk_range'] = cached_accesses_data['xlnk_range']
        else:
            #  eclipse times came out with an inadvertent extra nesting layer.  get rid of that.
            accesses_data['ecl_times'] = MatlabIF.deep_convert_matlab_to_python (sunecl)[0]
            accesses_data['xlnk_times'] = MatlabIF.deep_convert_matlab_to_python (xlink)
            accesses_data['xlnk_range'] = MatlabIF.deep_convert_matlab_to_python (x_range)

        return accesses_data

    def run(self, data):
        """
        Run orbit propagation pipeline element using the inputs supplied per input.json schema. Formats the high level output json and calls various subcomponents for processing

        :param data: input json per input.json schema
        :return: output json per output.json schema
        """

        orbit_prop_inputs = data['orbit_prop_inputs']
        cached_accesses_data = data['cached_accesses_data']
        cached_accesses = None

        if cached_accesses_data:
            if not cached_accesses_data['version'] == '0.2':
                raise NotImplementedError

            cached_accesses = cached_accesses_data['accesses_data']

        if orbit_prop_inputs['version'] == "0.3":

            # define orbit prop outputs json
            output_json = {}
            output_json['version'] = OUTPUT_JSON_VER
            output_json['scenario_params'] = orbit_prop_inputs['scenario_params']
            output_json['sat_orbit_data'] = []

            output_json['sat_orbit_data'] = self.process_orbits(orbit_prop_inputs)

            output_json['accesses_data'] = self.process_accesses(
                orbit_prop_inputs, output_json['sat_orbit_data'], cached_accesses)

            return output_json

        else:
            raise NotImplementedError


if __name__ == "__main__":

    ap = argparse.ArgumentParser(description='orbit propagation')
    ap.add_argument('--prop_inputs_file',
                    type=str,
                    default='orbit_prop_inputs.json',
                    help='specify orbit propagation inputs file')

    ap.add_argument('--cached_accesses_file',
                    type=str,
                    default=None,
                    help='file containing cached access data to use instead of recalculating it')

    args = ap.parse_args()

    pr = PipelineRunner()

    import json

    with open(os.path.join(REPO_BASE,args.prop_inputs_file), 'r') as f:
        orbit_prop_inputs = json.load(f)
        
    if args.cached_accesses_file:
        with open(os.path.join(REPO_BASE,args.cached_accesses_file), 'r') as f:
            cached_accesses_data = json.load(f)
    else:
        cached_accesses_data = None

    data = {
        "orbit_prop_inputs": orbit_prop_inputs,
        "cached_accesses_data": cached_accesses_data,
    }

    a = time.time()
    output = pr.run(data)
    # output = pr. process_accesses(thejson_data, thejson_sat_data["sat_orbit_data"])
    b = time.time()

    with open('orbit_prop_data.json', 'w') as f:
        json.dump(output, f)

    print('run time: %f' % (b - a))
