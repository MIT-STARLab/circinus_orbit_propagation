@author: Kit Kennedy
Last modified: 4/10/2017

# OrbitPropagation
Contains convenient code for simple orbit propagation tasks. Can use to produce input files for visualization in CesiumJS. Intended as an alternative to being dependent on STK for all orbit prop/visualization tasks.

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