#! /usr/bin/env python

##
# Python runner for MATLAB orbit prop pipeline
# @author Kit Kennedy
# 

import time
import os.path
import matlab
from matlab_if import MatlabIF


from run_tools import istring2dt

REPO_BASE = os.path.abspath(os.pardir)  # os.pardir aka '..'
MATLAB_PIPELINE_ENTRY = os.path.join(REPO_BASE,'matlab_pipeline','pipeline_entry')

OUTPUT_JSON_VER = '0.1'

class PipelineRunner:

	def __init__(self):
		self.matlabif = None

	def propagate_orbit(self,orb_params,end_time_s,timestep_s):

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
				orb_elems['M']
			]

		else:
			raise NotImplementedError

		# matlab-ify the args
		orb_elems_flat_ml =  matlab.double(orb_elems_flat)
		end_time_s_ml =  matlab.double([end_time_s])
		timestep_s_ml =  matlab.double([timestep_s])

		if orb_params['propagation_method'] == 'matlab_delkep':
			(t_r) = self.matlabif.call_mfunc(
				'orbit_prop_wrapper',
				orb_elems_flat_ml,
				end_time_s_ml,
				timestep_s_ml,
				nargout=1)

			#  convert matlab output types to python types

			time_pos = MatlabIF.mlarray_to_list(t_r)

			# can add other key value pairs to this dict, to put in final out file
			other_kwout = {}

			return time_pos,other_kwout

		else:
			raise NotImplementedError

	def grok_orbit_params(self,sat_orbit_params,version):
		"""
		Here's where you can take orbit meta params like '60:30/3/1 Walker constellation' and turn it into a list of flattened elements, e.g. a list of keplerian elements of epoch at scenaria start for every satellite

		:param sat_orbit_params: section of input json related to sat orbit params, possibly containing orbit meta params
		:return: flattened orbit params, i.e. a list of orbit params for each individual satellite
		"""

		# TODO: add handling for meta orbit params, e.g. set of satellites in orbit planes, or even whole constellations

		if version == "0.1":
			sat_orbit_params_flat = sat_orbit_params

			return sat_orbit_params_flat

	def process_orbits(self,data):
		"""
		Handles the production of orbit propagation result data from the parameters provided in json

		:param data: highest-level input json object
		:return: output json with raw orbit prop data
		"""

		if not self.matlabif:
			self.matlabif = MatlabIF(paths=[MATLAB_PIPELINE_ENTRY])

		if data['version'] == "0.1":
			sat_orbit_data = []
			scenario_params = data['scenario_params']
			end_time_s = ( istring2dt(scenario_params['end_utc']) -
						  istring2dt(scenario_params['start_utc']) ).total_seconds()
			timestep_s = scenario_params['timestep_s']

			sat_orbit_params_flat = self.grok_orbit_params(data['sat_orbit_params'],data['version'])
			for orb_params in sat_orbit_params_flat:
				orbit_data, other_kwout  = self.propagate_orbit(orb_params, end_time_s, timestep_s)

				single_orbit_data = {}
				single_orbit_data['sat_indx'] = orb_params['sat_indx']
				single_orbit_data['time_s_pos_km'] = orbit_data
				single_orbit_data.update(other_kwout)  # add any additional keyword fields to this dict

				sat_orbit_data.append(single_orbit_data)

			return sat_orbit_data

	def process_accesses(self,data,sat_orbit_data):
		"""

		:param data: highest-level input json object
		:return: output json with raw orbit prop data
		"""

		# matlab-ify the args
		params_ml = {}
		if data['version'] == "0.1":
			params_ml['scenario_start_utc'] = data['scenario_params']['start_utc']
			params_ml['num_sats'] = matlab.double([data['num_satellites']])
			params_ml['use_crosslinks'] = matlab.logical([data['scenario_params']['use_crosslinks']])
			params_ml['all_sats_same_time_system'] = matlab.logical([data['scenario_params']['all_sats_same_time_system']])
			params_ml['verbose'] = matlab.logical([data['scenario_params']['matlab_verbose']])

			obs_params = data['obs_params']
			params_ml['el_cutuff_obs_deg'] = matlab.double([obs_params['elevation_cutoff_deg']])
			lat_lon_deg = matlab.double([[o['latitude_deg'],o['longitude_deg']] for o in obs_params['targets']])
			params_ml['obs_lat_lon_deg'] = matlab.double(lat_lon_deg)
			params_ml['num_obs_targets'] = matlab.double([len(lat_lon_deg)])

			gs_params = data['gs_params']
			params_ml['el_cutuff_gs_deg'] = matlab.double([gs_params['elevation_cutoff_deg']])
			lat_lon_deg = matlab.double([[g['latitude_deg'],g['longitude_deg']] for g in gs_params['stations']])
			params_ml['gs_lat_lon_deg'] = matlab.double(lat_lon_deg)
			params_ml['num_gs'] = matlab.double([len(lat_lon_deg)])

		time_s_pos_km_flat_ml = []
		if OUTPUT_JSON_VER == "0.1":
			for elem in sat_orbit_data:
				time_s_pos_km_flat_ml.append(matlab.double(elem['time_s_pos_km']))

		if not self.matlabif:
			self.matlabif = MatlabIF(paths=[MATLAB_PIPELINE_ENTRY])

		(obs,obsaer,gslink,gsaer,sunecl,xlink,xrange) = self.matlabif.call_mfunc(
				'accesses_wrapper',
				time_s_pos_km_flat_ml,
				params_ml,
				nargout=7)

		# TODO: do stuff with outputs

		print(obs)

		return 12





	def run(self,data):
		"""
		Run orbit propagation pipeline element using the inputs supplied per input.json schema. Formats the high level output json and calls various subcomponents for processing

		:param data: input json per input.json schema
		:return: output json per output.json schema
		"""

		if data['version'] == "0.1":

			# define orbit prop outputs json
			output_json = {}
			output_json['version'] = OUTPUT_JSON_VER
			output_json['num_satellites'] = data['num_satellites']
			output_json['scenario_params'] = data['scenario_params']
			output_json['sat_orbit_data'] = []

			output_json['sat_orbit_data'] = self.process_orbits(data)

			output_json['accesses_data'] = self.process_accesses(data,output_json['sat_orbit_data'])

			return output_json

		else:
			raise NotImplementedError


if __name__ == "__main__":

	pr = PipelineRunner()

	import json

	with open(os.path.join(REPO_BASE,'crux/config/examples/orbit_prop_inputs_ex.json'),'r') as f:
		thejson = json.load(f)

	a = time.time()
	output = pr.run(thejson)
	b = time.time()

	with open('out.txt','w') as f:
		json.dump(output,f)

	print('run time: %f'%(b-a))
