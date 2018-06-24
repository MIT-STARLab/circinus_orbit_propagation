#  routines for parsing orbit parameters passed in orbit prop inputs file

# @author: Kit Kennedy

import pkg_resources
import json
import copy
from collections import OrderedDict

from circinus_tools import io_tools

# should be 'prop_tools', the package name
package_name = __name__.split('.')[0] 

def flatten_walker(params):
    KEPLER_PROTO = pkg_resources.resource_filename(package_name, '/'.join(('prototypes','kepler_mean_anom_proto.json')))
    with open(KEPLER_PROTO,'r') as f:
        KEPLER_PROTO = json.load(f,object_pairs_hook=OrderedDict)

    propagation_method = params["propagation_method"]
    sat_ids_spec = params["sat_ids"]
    sat_ids = io_tools.parse_sat_ids(sat_ids_spec,params['sat_id_prefix'])

    num_sats = params["walker"]["num_sats"]
    num_planes = params["walker"]["num_planes"]
    i_deg = params["walker"]["i_deg"]
    a_km = params["walker"]["a_km"]
    RAAN_p1_deg = params["walker"]["RAAN_p1_deg"]
    M_p1_deg = params["walker"]["M_p1_deg"]
    M_interplane_spacing_deg = params["walker"]["f_relative_spacing"]*360/num_sats
    
    sats_per_plane = int (num_sats/num_planes)

    if len (sat_ids) != num_sats:
        raise Exception ("Range of satellite IDs should match specified number of satellites")
    if sats_per_plane != num_sats/num_planes:
        raise Exception ( "Number of satellites should be divisible by number of planes")

    M_intraplane_spacing_deg = 360.0/sats_per_plane
    RAAN_interplane_spacing_deg = 360.0/num_planes
    
    params_flat = []
    for plane_indx in range (num_planes):

        for sat_indx in range(sats_per_plane):
            kep =  copy.copy (KEPLER_PROTO)

            kep['a_km'] = a_km
            kep['e'] = 0
            kep['i_deg'] = i_deg
            kep['RAAN_deg'] = RAAN_p1_deg+RAAN_interplane_spacing_deg*plane_indx
            kep['arg_per_deg'] = 0
            kep['M_deg'] = M_p1_deg + M_interplane_spacing_deg*plane_indx + M_intraplane_spacing_deg*sat_indx

            sat_params = {}
            sat_params["kepler_meananom"]=kep
            sat_params["propagation_method"]=propagation_method
            sat_params["sat_id"]=sat_ids[plane_indx*sats_per_plane+sat_indx]

            params_flat.append(sat_params)


    return params_flat


