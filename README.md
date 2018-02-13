# OrbitPropagation
Contains convenient code for simple orbit propagation tasks. Can use to produce input files for visualization in CesiumJS. Intended as an alternative to being dependent on STK for all orbit prop/visualization tasks.

Most of the numbercrunching is done in Matlab, and there is a Python wrapper to facilitate calling Matlab and keeping instances of Matlab running.

Please feel free to update this code! The more tools are here, the more useful it'll be for the whole lab. I want this to be the GOTO solution for any easy orbit propagation / analysis stuff. Try to respect the current organization though - if you have questions about changing things, please drop me a note: akennedy@mit.edu

## Setup

### Python

This code has been tested with Python 3.5.  I recommend running this in a Python virtual environment.

### Install Matlab Engine Api For Python

Follow the instructions here: http://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html?refresh=true . Hgjkhk . Kljjkl

Note that this Matlab engine setup has only been tested by the author on an OS X system.

## Execution

From `OrbitPropagation/python_runner`, execute:

```
python runner_orbitprop.py
```

For the time being feel free to make changes in the `if __name__ == "__main__":` block at the bottom of this Python script. Specifically change the json input file if you're testing a different case.

Note that this is only really a temporary method for running the code. In future there will be a more crux-canonical executable.

## Crux Component

This code is meant to be run as a component within a Crux pipeline. That means inputs and outputs are specified in the config files stored in `./crux/config/`, with input and output schemas defined in `./crux/config/schema`. The Crux backend uses the schemas to verify the correctness of input and output files. Input and output can be JSON, CSV, or some other file types.

## Directories

1. `python_runner`

   Entry point for Python code to run orbit propagation. `runner_orbitprop.py` is what you should call from the command line for quick execution.

2. `matlab_pipeline`

   This contains the essential orbit propagation code, written in Matlab.

3. `crux`

   This contains the config files for using this repo as a Crux component.

   * `crux/config/schema`
      Directory containing the schema is used to validate inputs and outputs. Generally good to look here for explanations of the data found in the input and output files

   * `crux/config/examples/orbit_prop_inputs_ex_small.json`
      Example of a configuration file that contains all the inputs used for orbit propagation. Duplicate this file and make changes for different scenarios

   * `crux/config/examples/orbit_prop_data_ex_small.json`
      Example of an output file with the data produced from orbit propagation. This is used in turn for running a simulation and/or for visualization


4. `matlab_scenarios`

   This directory contains some old code that was used for previous iteration of propagation. Keeping here for the time being.

5. `misc_tools`

   A place to store other tools for convenience

## Work In Progress

There's still some development that needs be done on this code, of course.

Currently the daemon that runs Matlab is `screen`, and has only been tested on a Darwin platform (OS X). For Windows, a different daemon tool will probably be needed. see the code in `matlab_if/interface.py`, `clean_up_persistent_engines()` and `_start_persistent_shared_matlab()`.

Also currently only Kepler elements are implemented for orbit inputs. See `crux/config/examples/orbit_prop_inputs_ex.json` to see what these look like. It would be good to also have the capability to specify a full set of similar orbits as a single input in the array `sat_orbit_params`. For example it would be nice to specify an entire orbit with a set of cubesats separated at a regular spacing in true anomaly. Also would be good to have TLE inputs here. `grok_orbit_params()` in runner_orbitprop.py is where the necessary changes can be made.



