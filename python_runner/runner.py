#! /usr/bin/env python

##
# Python runner for MATLAB orbit prop pipeline
# @author Kit Kennedy
# 

import time
import os.path

# For matlab setup, see http://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html?refresh=true
import matlab
from matlab import engine


REPO_BASE = os.path.abspath(os.pardir)  # os.pardir aka '..'
MATLAB_PIPELINE_ENTRY = os.path.join(REPO_BASE,'matlab_pipeline','pipeline_entry')

class PipelineRunner:
    pass

if __name__ == "__main__":
	
	eng = engine.start_matlab()
	eng.addpath(MATLAB_PIPELINE_ENTRY)


	kep_elem = matlab.double([6970,0,45,45,0,0])
	end_time_s = matlab.double([86400])
	del_t_s = matlab.double([1])

	a = time.time()
	(t,r,v) = eng.orbit_prop_wrapper(kep_elem,end_time_s,del_t_s,nargout=3)
	b = time.time()

	print(t)
	print(r)
	print(v)

	print('b-a: %f'%(b-a))
