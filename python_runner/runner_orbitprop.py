#! /usr/bin/env python

##
# Python runner for MATLAB orbit prop pipeline
# @author Kit Kennedy
#

import sys
import time
import os.path

import argparse
import json
import copy
from run_tools import istring2dt

#  local repo includes. todo:  make this less hackey
sys.path.append ('..')
#from  prop_tools  import orbits
try: # First try will work if subrepo circinus_tools is populated, or if prior module imported from elsewhere
    from circinus_tools import io_tools
except ImportError: # Covered by importing orbits above, but don't want to break if that's dropped.
    print("Importing circinus_tools from parent repo...")
    try:
        import sys
        sys.path.insert(0, "../../")
        from circinus_tools import io_tools
    except ImportError:
        print("Neither local nor parent-level circinus_tools found.")

try:
    import matlab
    try: # First try will work if subrepo circinus_tools is populated, or if prior module imported from elsewhere
        from circinus_tools.matlab_if.MatlabIF import MatlabIF
    except ImportError: # Covered by importing orbits above, but don't want to break if that's dropped.
        print("Importing circinus_tools from parent repo...")
        try:
            import sys
            sys.path.insert(0, "../../")
            from circinus_tools.matlab_if.MatlabIF import MatlabIF
        except ImportError:
            print("Neither local nor parent-level circinus_tools found.")
except ImportError:
    print("Matlab module not installed.")

REPO_BASE = os.path.abspath(os.pardir)  # os.pardir aka '..'
MATLAB_PIPELINE_ENTRY = os.path.join(
    REPO_BASE, 'matlab_pipeline', 'pipeline_entry')
OUTPUT_JSON_VER = '0.3'


class PipelineRunner:

    def __init__(self):
        self.matlabif = None
        self.MATLAB_VERSION = 'MATLAB_R2017a'  # default, modified by config file

    def propagate_orbit(self, orb_params, end_time_s, timestep_s,include_ecef,scenario_start_utc):

        if not self.matlabif:
            self.matlabif = MatlabIF(matlab_ver=self.MATLAB_VERSION,paths=[MATLAB_PIPELINE_ENTRY])

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
        params_ml = {}
        params_ml['scenario_start_utc'] = scenario_start_utc
        params_ml['calc_ecef'] = matlab.logical([include_ecef])

        if orb_params['propagation_method'] == 'matlab_delkep':
            (t_r_eci,t_r_ecef) = self.matlabif.call_mfunc(
                'orbit_prop_wrapper',
                orb_elems_flat_ml,
                end_time_s_ml,
                timestep_s_ml,
                params_ml,
                nargout=2)

            #  convert matlab output types to python types

            time_pos_eci = MatlabIF.mlarray_to_list(t_r_eci)
            time_pos_ecef = MatlabIF.mlarray_to_list(t_r_ecef)

            # can add other key value pairs to this dict, to put in
            # final out file
            other_kwout = {}

            return time_pos_eci, time_pos_ecef, other_kwout

        else:
            raise NotImplementedError

    def grok_orbit_params(self, sat_orbital_elems, version):
        """
        Here's where you can take orbit meta params like '60:30/3/1 
        Walker constellation' and turn it into a list of flattened 
        elements, e.g. a list of keplerian elements of epoch at scenaria 
        start for every satellite

        :param sat_orbital_elems: section of input json related to sat 
        orbit elems, possibly containing orbit meta elems
        :return: flattened orbit elems, i.e. a list of orbit elems for
         each individual satellite
        """

        sat_orbital_elems_flat = []

        for elems in sat_orbital_elems:
            if "walker" in  elems:
                if not "synthesize" in elems["sat_ids"]:
                    raise Exception(" when forming orbit parameters from a Walker constellation, need a synthesize token in the sat_ids field")

                flat_elems = orbits.flatten_walker(elems)
                sat_orbital_elems_flat  += flat_elems

            if "kepler_meananom" in elems:
                sat_orbital_elems_flat.append(elems)

        return sat_orbital_elems_flat


    def process_orbits(self, process_orbits_input):
        """
        Handles the production of orbit propagation result data from the 
        parameters provided in json

        :param orbit_prop_inputs: highest-level input json object
        :return: output json with raw orbit prop data
        """

        if not self.matlabif:
            self.matlabif = MatlabIF(matlab_ver=self.MATLAB_VERSION,paths=[MATLAB_PIPELINE_ENTRY])

        sat_orbit_data = []
        end_time_s = (istring2dt(process_orbits_input['end_utc']) -
                      istring2dt(process_orbits_input['start_utc']))\
            .total_seconds()
        timestep_s = process_orbits_input['timestep_s']

        sat_orbital_elems_flat = self.grok_orbit_params(
            process_orbits_input['sat_orbital_elems'], None)

        if len(sat_orbital_elems_flat) !=  process_orbits_input['num_satellites']:
            raise Exception ('Number of satellites is not equal to the length of satellite parameters list')

        include_ecef = process_orbits_input.get("include_ecef_output",False) 
        for orb_params in sat_orbital_elems_flat:
            orbit_data_eci, orbit_data_ecef, other_kwout = self.propagate_orbit(
                orb_params, end_time_s, timestep_s, include_ecef,process_orbits_input['start_utc'])

            single_orbit_data = {}
            single_orbit_data['sat_id'] = str(orb_params['sat_id'])
            single_orbit_data['time_s_pos_eci_km'] = orbit_data_eci
            if include_ecef:
                single_orbit_data['time_s_pos_ecef_km'] = orbit_data_ecef

            # add any additional keyword fields to this dict
            single_orbit_data.update(other_kwout)

            sat_orbit_data.append(single_orbit_data)

        return sat_orbit_data


    def process_accesses(self, process_accesses_input, sat_orbit_data, cached_accesses_data):
        """

        :param orbit_prop_inputs: highest-level input json object
        :return: output json with raw orbit prop data
        """

        accesses_data = {}

        # matlab-ify the args
        params_ml = {}
        params_ml['scenario_start_utc'] = process_accesses_input['start_utc'] 
        params_ml['num_sats'] = matlab.double([process_accesses_input['num_satellites']]) 
        params_ml['use_crosslinks'] = matlab.logical([process_accesses_input['use_crosslinks']])
        params_ml['all_sats_same_time_system'] = matlab.logical([process_accesses_input['all_sats_same_time_system']])
        params_ml['verbose'] = matlab.logical([process_accesses_input['matlab_verbose']])

        obs_params = process_accesses_input['obs_params']
        params_ml['el_cutuff_obs_deg'] = matlab.double(
            [obs_params['elevation_cutoff_deg']])
        lat_lon_deg = matlab.double(
            [[o['latitude_deg'], o['longitude_deg']] for o in
             obs_params['targets']])
        params_ml['obs_lat_lon_deg'] = matlab.double(lat_lon_deg)
        params_ml['num_obs_targets'] = matlab.double([len(lat_lon_deg)])

        if len(lat_lon_deg) != obs_params['num_targets']:
            raise Exception ('Number of observation targets is not equal to the length of observation target parameters list')

        gs_params = process_accesses_input['gs_params']
        params_ml['el_cutuff_gs_deg'] = matlab.double(
            [gs_params['elevation_cutoff_deg']])
        lat_lon_deg = matlab.double(
            [[g['latitude_deg'], g['longitude_deg']] for g in
             gs_params['stations']])
        params_ml['gs_lat_lon_deg'] = matlab.double(lat_lon_deg)
        params_ml['num_gs'] = matlab.double([len(lat_lon_deg)])

        if len(lat_lon_deg) != gs_params['num_stations']:
            raise Exception ('Number of ground stations is not equal to the length of ground station parameters list')

        num_satellites = process_accesses_input['num_satellites']
        sat_id_prefix = process_accesses_input['sat_id_prefix']

        sat_id_order= process_accesses_input['sat_id_order']
        # in the case that this is default, then we need to grab a list of all the satellite IDs. We'll take this from all of the satellite IDs found in the orbit parameters
        if sat_id_order == 'default':
            dummy, all_sat_ids = io_tools.unpack_sat_entry_list(  process_accesses_input['sat_orbital_elems'],force_duplicate =  True)
        #  make the satellite ID order. if the input ID order is default, then will assume that the order is the same as all of the IDs passed as argument
        sat_id_order = io_tools.make_and_validate_sat_id_order(sat_id_order,sat_id_prefix,num_satellites,all_sat_ids)
        io_tools.validate_ids(validator=sat_id_order,validatee=all_sat_ids)


        sat_orbit_data_sorted = io_tools.sort_input_params_by_sat_IDs(sat_orbit_data,sat_id_order)

        params_ml['use_cached_accesses'] = True if cached_accesses_data else False

        time_s_pos_km_flat_ml = []
        if OUTPUT_JSON_VER == "0.3":
            for elem in sat_orbit_data_sorted:
                time_s_pos_km_flat_ml.append(
                    matlab.double(elem['time_s_pos_eci_km']))
        else:
            raise NotImplementedError

        if not self.matlabif:
            self.matlabif = MatlabIF(matlab_ver=self.MATLAB_VERSION,paths=[MATLAB_PIPELINE_ENTRY])

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
            #  TODO - eclipse times came out with an inadvertent extra nesting layer.  get rid of that.
            accesses_data['ecl_times'] = MatlabIF.deep_convert_matlab_to_python (sunecl)[0]
            accesses_data['xlnk_times'] = MatlabIF.deep_convert_matlab_to_python (xlink)
            accesses_data['xlnk_range'] = MatlabIF.deep_convert_matlab_to_python (x_range)

        return accesses_data

    def run(self, process_orbits_input, process_accesses_input, cached_accesses_inputs,sim_general_config, scenario_params):
        """
        Run orbit propagation pipeline element using the inputs supplied per input.json schema. Formats the high level output json and calls various subcomponents for processing

        :param data: input json per input.json schema
        :return: output json per output.json schema
        """

        output_json = {}
        output_json['version'] = OUTPUT_JSON_VER

        cached_accesses = None
        output_json['scenario_params'] = scenario_params

        self.MATLAB_VERSION = sim_general_config["general_sim_params"]["matlab_version"]

        output_json['sat_orbit_data'] = self.process_orbits(process_orbits_input) 

        cached_accesses = None
        if cached_accesses_inputs:
            if not cached_accesses_inputs['version'] == '0.4':
                raise NotImplementedError

            cached_accesses = {
                "xlnk_range": cached_accesses_inputs['accesses_data']['xlnk_range'],
                "xlnk_times": cached_accesses_inputs['accesses_data']['xlnk_times'],
                "ecl_times": cached_accesses_inputs['accesses_data']['ecl_times'],
            }

        output_json['accesses_data'] = self.process_accesses(
            process_accesses_input, output_json['sat_orbit_data'], cached_accesses_inputs)

        return output_json

##### WARNING: Old Matlab stuff above ####


def parse_inputs_into_old_format(data):
    '''temporary helper function to parse new refactored form into old format to check backwards compatability
    '''
    sim_case_config = data['sim_case_config']
    sim_general_config = data['sim_general_config']
    constellation_config = data['constellation_config']
    gs_network_config = data['gs_network_config']
    ops_profile_config = data['ops_profile_config']

    

    process_orbits_input = {
        "sat_orbital_elems":constellation_config["constellation_definition"]["constellation_params"]['orbit_params']['sat_orbital_elems'],
        "num_satellites":constellation_config["constellation_definition"]["constellation_params"]['num_satellites'],
        "start_utc":sim_case_config['scenario_params']["start_utc"],
        "end_utc":sim_case_config['scenario_params']["end_utc"],
        "include_ecef_output":sim_general_config["general_sim_params"]["include_ecef_output"],
        "timestep_s":sim_general_config["general_sim_params"]["timestep_s"]
    }

    prev_accesses_input = copy.deepcopy(process_orbits_input)
    new_accesses_input = {
        "use_crosslinks":sim_case_config['scenario_params']['use_crosslinks'],
        "all_sats_same_time_system":sim_case_config['scenario_params']['all_sats_same_time_system'],
        "matlab_verbose":sim_general_config["general_sim_params"]["matlab_verbose"],
        "sat_id_prefix":constellation_config["constellation_definition"]["constellation_params"]["sat_id_prefix"],
        "sat_id_order":constellation_config["constellation_definition"]["constellation_params"]["sat_id_order"],
        "gs_params":gs_network_config["network_definition"]["gs_net_params"],
        "obs_params":ops_profile_config["ops_profile_params"]["obs_params"]
    }
    process_accesses_input = {**prev_accesses_input, **new_accesses_input}

    """process_accesses_input = {
        **process_orbits_input, # This makes a deep copy (changing this one doesn't change this) of the other dict and appends new fields as this new dict; 
        "use_crosslinks":sim_case_config['scenario_params']['use_crosslinks'],
        "all_sats_same_time_system":sim_case_config['scenario_params']['all_sats_same_time_system'],
        "matlab_verbose":sim_general_config["general_sim_params"]["matlab_verbose"],
        "sat_id_prefix":constellation_config["constellation_definition"]["constellation_params"]["sat_id_prefix"],
        "sat_id_order":constellation_config["constellation_definition"]["constellation_params"]["sat_id_order"],
        "gs_params":gs_network_config["network_definition"]["gs_net_params"],
        "obs_params":ops_profile_config["ops_profile_params"]["obs_params"]
    } """



    scenario_params = { 
        # From case-specific scenario info
        "start_utc":sim_case_config['scenario_params']["start_utc"],
        "end_utc": sim_case_config['scenario_params']["end_utc"],
        "use_crosslinks":sim_case_config['scenario_params']["use_crosslinks"],
        "all_sats_same_time_system":sim_case_config['scenario_params']["all_sats_same_time_system"],
        # From general parameters
        "timestep_s":sim_general_config["general_sim_params"]["timestep_s"],
        "matlab_verbose":sim_general_config["general_sim_params"]["matlab_verbose"]
    }

    cached_accesses_inputs = data['cached_accesses_inputs']
    sim_general_config = data['sim_general_config']

    return (process_orbits_input, process_accesses_input, cached_accesses_inputs,sim_general_config, scenario_params)

def runOrbitProp(data, method='python'):
    # Need to pull out the input refactor elements into a seperate function
    # since we need to use it for the python propagator for now too
    (process_orbits_input, process_accesses_input, cached_accesses_inputs,sim_general_config, scenario_params) = parse_inputs_into_old_format(data)

    process_orbits_input['sat_orbital_elems'] = io_tools.expand_planewise_sat_defs(process_orbits_input['sat_orbital_elems'])


    if process_accesses_input['matlab_verbose']:
        print('Use Case Info:')
        duration_h = ( istring2dt(scenario_params['end_utc']) -
                       istring2dt(scenario_params['start_utc'])  ).total_seconds()/3600
        print('Scenario Timing: %d-hour sim duration, %d-second time resolution ' % (duration_h,scenario_params['timestep_s']))
        print('Ground Station Network: %s, with %d ground stations'% (process_accesses_input['gs_params']['gs_network_name'],len(process_accesses_input['gs_params']['stations'])))
        print('Observation Targets: %s, with %d targets'% (process_accesses_input['obs_params']['target_set_name'],len(process_accesses_input['obs_params']['targets'])))
        print('Constellation: %d sats'% process_accesses_input['num_satellites'])
        print()

    a = time.time()
    if method == 'matlab':
        pr = PipelineRunner()
        output = pr.run(process_orbits_input, process_accesses_input, cached_accesses_inputs,sim_general_config, scenario_params)
    elif method == 'python':
        from OrbitPropagator import OrbitPropagator
        from AccessesCalculator import AccessesCalculator

        orb_prop = OrbitPropagator(process_orbits_input,prop_method = 'kepler')
        orbit_prop_output_dict = orb_prop.get_orbit_prop_output()

        access_calc = AccessesCalculator(process_accesses_input,orbit_prop_output_dict['sat_orbit_data'])

        accesses_data = access_calc.get_all_accesses_data()

        # formulate outputs
        output = {}
        output['scenario_params'] = scenario_params
        output['sat_orbit_data'] = orbit_prop_output_dict['sat_orbit_data']
        output['accesses_data'] = accesses_data
        print('accesses complete')
        # TODO: make sure to update prop-Method in ['sat_orbital_elems']['propagation_method'] for each sat
    else:
        raise NotImplementedError('only python and matlab are available language options')

    return output

def main():

    ap = argparse.ArgumentParser(description='orbit propagation')

    # ap.add_argument('--cached_accesses_file',
    #                 type=str,
    #                 default=None,
    #                 help='file containing cached access data to use instead of recalculating it')

    # Using default arguments for providing the default location that would be used if not w/in larger CIRCINUS repo.
    # TODO - When we settle on our nominal models, will make this example directory.
    ap.add_argument('--inputs_location',
                    type=str,
                    default=os.path.join(REPO_BASE,'example_input'),
                    help='specify directory in which to find input and config files')

    ap.add_argument('--case_name',
                    type=str,
                    default=os.path.join(REPO_BASE,'nom_case'),
                    help='specify name of case to be used for calculations')


    ap.add_argument('--prop_and_accesses_language',
                    type=str,
                    default='python',
                    help='specify language to use, either: matlab or python available')
    

    args = ap.parse_args()

    # ------- Filenames ------ #
    sim_case_config_FILENAME = args.inputs_location+'/cases/'+args.case_name+'/sim_case_config.json'
    sim_general_config_FILENAME = args.inputs_location+'/general_config/sim_general_config.json'
    constellation_config_FILENAME = args.inputs_location+'/cases/'+args.case_name+'/constellation_config.json'
    gs_network_config_FILENAME = args.inputs_location+'/cases/'+args.case_name+'/ground_station_network_config.json'
    ops_profile_config_FILENAME = args.inputs_location+'/cases/'+args.case_name+'/operational_profile_config.json'

    # Winsows users check 
    import sys

    if sys.platform == 'win32':
        sim_case_config_FILENAME.replace('/','\\')
        sim_general_config_FILENAME.replace('/','\\')
        constellation_config_FILENAME.replace('/','\\')
        gs_network_config_FILENAME.replace('/','\\')
        ops_profile_config_FILENAME.replace('/','\\')
       
        

    # ------- Check for file validity ------ #``
    sim_case_config_EXISTS = os.path.isfile(sim_case_config_FILENAME)
    constellation_config_EXISTS = os.path.isfile(constellation_config_FILENAME)
    gs_network_config_EXISTS = os.path.isfile(gs_network_config_FILENAME)
    ops_profile_config_EXISTS = os.path.isfile(ops_profile_config_FILENAME)
    sim_general_config_EXISTS = os.path.isfile(sim_general_config_FILENAME)

    if(not sim_case_config_EXISTS 
        or not constellation_config_EXISTS 
        or not gs_network_config_EXISTS 
        or not ops_profile_config_EXISTS 
        or not sim_general_config_EXISTS):
        
        print("Some required configuration files may not provided:")
        print("  in inputs/cases/{}:".format(args.case_name))
        print("\tconstellation_config.json              {}".format(("[missing]" if not constellation_config_EXISTS else ""))) 
        print("\tground_station_network_config.json     {}".format(("[missing]" if not gs_network_config_EXISTS else "")))
        print("\toperational_profile_config.json        {}".format(("[missing]" if not ops_profile_config_EXISTS else "")))
        print("\tsim_case_config.json                   {}".format(("[missing]" if not sim_case_config_EXISTS else "")))

        print("  in inputs/general_config:")
        print("\tsim_general_config.json                {}".format(("[missing]" if not sim_general_config_EXISTS else "")))

        print("Provide any missing input files. Terminating.\n")
        exit(1)

    
    


    # -------- CASE SPECIFIC CONFIGURATION INPUTS -------- #
    with open(sim_case_config_FILENAME,'r') as f:
        sim_case_config = json.load(f)
    with open(constellation_config_FILENAME,'r') as f:
        constellation_config = json.load(f)
    with open(gs_network_config_FILENAME,'r') as f:
        gs_network_config = json.load(f)
    with open(ops_profile_config_FILENAME,'r') as f:
        ops_profile_config = json.load(f)

    # -------- GENERAL CONFIGURATION INPUTS -------- #
    with open(sim_general_config_FILENAME,'r') as f:
        sim_general_config = json.load(f)


        
    # if args.cached_accesses_file:
    #     with open(os.path.join(REPO_BASE,args.cached_accesses_file), 'r') as f:
    #         cached_accesses_inputs = json.load(f)
    # else:
    #     cached_accesses_inputs = None
    cached_accesses_inputs = None


    data = {

        "sim_case_config":sim_case_config,
        "sim_general_config":sim_general_config,
        "constellation_config":constellation_config,
        "gs_network_config":gs_network_config,
        "ops_profile_config":ops_profile_config,

        # Old: 
        "cached_accesses_inputs": cached_accesses_inputs
    }

    output = runOrbitProp(data, method=args.prop_and_accesses_language)

    b = time.time()

    json_filename = args.inputs_location+'/cases/'+args.case_name+'/autogen_files/orbit_prop_data.json'
    if sys.platform == 'win32':
        json_filename.replace('/','\\')

    with open(json_filename, 'w') as f:
        json.dump(output, f, indent=4, separators=(',', ': '))

    print('run time: %f' % (b - a))

if __name__ == "__main__":
    main()