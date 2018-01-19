#! /usr/bin/env python

##
# Python runner for MATLAB orbit prop pipeline
# @author Kit Kennedy
# 

import time
import os.path


from run_tools import istring2dt,mlarray_to_list

REPO_BASE = os.path.abspath(os.pardir)  # os.pardir aka '..'
MATLAB_PIPELINE_ENTRY = os.path.join(REPO_BASE,'matlab_pipeline','pipeline_entry')


class PipelineRunner:

	def run(self,data):
		"""
		Run orbit propagation pipeline element using the inputs supplied per input.json schema

		:param data: input json defined per input.json schema
		:return: output json per output.json schema
		"""

		if data['version'] == "0.1":

			# define orbit prop outputs json
			orbit_prop_output = {}
			orbit_prop_output['version'] = data['version']
			orbit_prop_output['num_satellites'] = data['num_satellites']
			orbit_prop_output['scenario_time_params'] = data['scenario_time_params']
			orbit_prop_output['sat_orbit_data'] = []

			time_params = data['scenario_time_params']
			end_time_s = (istring2dt(time_params['end_utc'])-istring2dt(time_params['start_utc'])).total_seconds()
			timestep_s = time_params['timestep_s']

			sat_orbit_params = data['sat_orbit_params']
			for sat_indx, orb_params in enumerate(sat_orbit_params):

				sat_indx = orb_params['sat_indx']

				# get orbital elements
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
					kep_elem = matlab.double(orb_elems_flat)
					end_time_s = matlab.double([end_time_s])
					del_t_s = matlab.double([timestep_s])

					eng = self.get_matlab_engine()
					(t_r) = eng.orbit_prop_wrapper(kep_elem, end_time_s, del_t_s, nargout=1)

					orbit_data = {}
					orbit_data['sat_indx'] = sat_indx
					orbit_data['position'] = mlarray_to_list(t_r)
					orbit_prop_output['sat_orbit_data'].append(orbit_data)

				else:
					raise NotImplementedError

			return orbit_prop_output

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

	print('b-a: %f'%(b-a))
