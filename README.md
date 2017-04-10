Author: Kit Kennedy
Last modified: 4/10/2017

# OrbitPropagation
Contains convenient code for simple orbit propagation tasks. Can use to produce input files for visualization in CesiumJS. Intended as an alternative to being dependent on STK for all orbit prop/visualization tasks.

Please feel free to update this code! The more tools are here, the more useful it'll be for the whole lab. I want this to be the GOTO solution for any easy orbit propagation / analysis stuff. Try to respect the current organization though - if you have questions about changing things, please drop me a note: akennedy@mit.edu

## Directories

1. Scenarios

   Contains subdirectories with scripts for generating output files for both satellite position and CZML input to the CesiumJS visualization tool (see below)

2. AccessUtils

   Contains various Matlab utilities for calculating times of various events: dowlinks, crosslinks, eclipses

3. czml

   Contains stock czml header files for various constellation scenarios, as well as czml stubs for satellites with names sat1 to sat 40 (currently).

   Also contains the "Tools" subdirectory, which has all kinds of good python tools for generating CZML files for CesiumJS

4. Libraries

   Contains libraies used for simple orbit propagation (PROPAT) and solar ephemeris generation (Solar_Ephemeris). Grabbed from the web, principally the MATLAB forums.

5. SatPosFileIO

   Basically MATLAB utilies for writing and reading position files for satellites. These files were intended to LOOK like the files produced by STK, for ease of reading by humans.

## Scenarios

These are various constellation scenarios that have already been set up for easy generation of files. Most of them allow parametric selection of the number of satellites in each orbit, e.g. SSO, equatorial, and ISS.

The scenario directories are currently structured so that there's a single top-level file that can be run to produce files for the given scenario. For "SingleSat", this file is "single_sat_generator_wrapper.m". It would be HIGHLY PREFERED to abide by this structure for future scenario directories created.

There's also a bunch of other files in each scenario directory. These include the _file_writer.m file, which actually writes the files of interest, some python tools, a czml header file, and various other rifraf.

Specifically for SingleSat, I added "sat1_delkep_pos.txt" and "sats_file_single_sfn_0_0_1.czml" as an example of the produced position output file and czml file. The _pos.txt file contains the satellite's position as a function of time, and is self-explanatory. The .czml file is, again, an input file for CesiumJS. It's a subset of the JSON standard, and specifies properties of the visualization. For more info about how to use this file, see Kit's other repo, MATLAB_sat_viz (it's currently not in the STAR Lab github, but Kit may add it there. He's not sure why he didn't put it there. Dumb.)

So to run a scenario, simply:

1. Open a _generator_wrapper.m file.
2. At the top of the file, modify the number of sats in each orbit (and czml file names if desired)
3. In the lower half of the file, modify any of the choices for ground station network, use of crosslinks, etc that you want. Note that you don't have to run this code if you're not looking for anything beyond the sat's orbit