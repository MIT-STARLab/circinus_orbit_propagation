#! /usr/bin/env python

##
# Python runner for MATLAB orbit prop pipeline
# @author Kit Kennedy
# 

import time
import os.path
from matlab_if import MatlabIF


from run_tools import istring2dt

REPO_BASE = os.path.abspath(os.pardir)  # os.pardir aka '..'
MATLAB_PIPELINE_ENTRY = os.path.join(REPO_BASE,'matlab_pipeline','pipeline_entry')

OUTPUT_JSON_VER = '0.1'

class OrbitPropWrapper:

	def __init__(self):
		self.matlabif = MatlabIF(paths=[MATLAB_PIPELINE_ENTRY])

	def propagate_orbit(self,orb_params,end_time_s,timestep_s):

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

		if orb_params['propagation_method'] == 'matlab_delkep':
			(t_r) = self.matlabif.call_mfunc(
				'orbit_prop_wrapper',
				orb_elems_flat,
				end_time_s,
				timestep_s,
				nargout=1)

			#  convert matlab output types to python types

			time_pos = MatlabIF.mlarray_to_list(t_r)

			return time_pos

		else:
			raise NotImplementedError



class PipelineRunner:

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

		opw = OrbitPropWrapper()

		if data['version'] == "0.1":
			sat_orbit_data = []
			time_params = data['scenario_time_params']
			end_time_s = ( istring2dt(time_params['end_utc']) -
						  istring2dt(time_params['start_utc']) ).total_seconds()
			timestep_s = time_params['timestep_s']

			sat_orbit_params_flat = self.grok_orbit_params(data['sat_orbit_params'],data['version'])
			for orb_params in sat_orbit_params_flat:
				orbit_data = opw.propagate_orbit(orb_params, end_time_s, timestep_s)

				single_orbit_data = {}
				single_orbit_data['sat_indx'] = orb_params['sat_indx']
				single_orbit_data['position'] = orbit_data
				sat_orbit_data.append(single_orbit_data)

			return sat_orbit_data

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
			output_json['scenario_time_params'] = data['scenario_time_params']
			output_json['sat_orbit_data'] = []

			output_json['sat_orbit_data'] = self.process_orbits(data)

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
