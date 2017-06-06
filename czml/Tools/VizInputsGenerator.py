# use the SublimePrettyJson package in to pretty print the output czml correctly (note that the json has to be valid for pretty print to work). Link: https://github.com/dzhibas/SublimePrettyJson/issues

# using jdcal package for dealing with modified julian dates from MATLAB code
# See https://oneau.wordpress.com/2011/08/30/jdcal/
# sudo pip install jdcal

# e.g.
# print jdcal.jd2gcal(jdcal.MJD_0,57827.5774306)  #have to pass both base date of MJD and the MJD to this function

# import CZMLtextTools as cztl
import scipy.io
import jdcal

import CZMLtextTools as cztl

import datetime
import math
import json

import collections
import datetime

def generateVizInputs(file_from_sim = './timing_output.mat',output_viz_czml_file = './viz_out.json'):

    mat = scipy.io.loadmat(file_from_sim)

    # print mat.keys()

    t_o = mat['t_o']
    t_d = mat['t_d']
    t_x = mat['t_x']
    o_locations = mat['o_locations']
    d_part = mat['d_part']
    x_part = mat['x_part']
    num_gs = mat['num_gs'][0][0]
    GS_names = mat['GS_names']
    gs_network = mat['gs_network'][0][0]
    q_o_sizes_history = mat['q_o_sizes_history']
    gs_availability_windows = mat['gs_availability_windows']
    batt_stored_history = mat['batt_stored_history']
    t_eclipse = mat['t_eclipse']
    sim_output_time = str(mat['creation_time'][0])
    dlnk_rate_history = mat['dlnk_rate_history']
    xlnk_rate_history = mat['xlnk_rate_history']
    startdatestr = str(mat['startdatestr'][0])
    enddatestr = str(mat['enddatestr'][0])
    num_sats = mat['num_satellites'][0][0]

    # print num_sats

    if 'info_string' in mat.keys():
        file_writer_info_string = str(mat['info_string'][0])
    else:
        file_writer_info_string = 'no file writer info string found'

    ########################################
    # Import data
    ########################################

    # import downlinks
    downlink_times_datetime = [[[]  for j in range(num_gs)] for k in range(num_sats)]
    for sat_indx in xrange(0,num_sats):
        if not len(t_d) > 0:
            break

        dlnk_list = t_d[sat_indx]

        for dlnk_indx, dlnk in enumerate(dlnk_list):

            # if it's not empty
            if dlnk.any():
                gs_num = d_part[sat_indx][dlnk_indx][0][0]

                # do a bunch of crap to convert to datetime. Note that jd2gcal returns year,month,day, FRACTION OF DAY (GOD WHY!?) so we have to convert.
                start_dlnk = jdcal.jd2gcal(jdcal.MJD_0,dlnk[0][0])
                end_dlnk = jdcal.jd2gcal(jdcal.MJD_0,dlnk[0][1])
                start_dlnk_hours = math.floor(start_dlnk[3]*24)
                start_dlnk_minutes = math.floor((start_dlnk[3]*24-start_dlnk_hours) * 60)
                start_dlnk_seconds = math.floor(((start_dlnk[3]*24-start_dlnk_hours) * 60 - start_dlnk_minutes) * 60)
                end_dlnk_hours = math.floor(end_dlnk[3]*24)
                end_dlnk_minutes = math.floor((end_dlnk[3]*24-end_dlnk_hours) * 60)
                end_dlnk_seconds = math.floor(((end_dlnk[3]*24-end_dlnk_hours) * 60 - end_dlnk_minutes) * 60)
                start_dlnk_datetime = datetime.datetime(start_dlnk[0],start_dlnk[1],start_dlnk[2],int(start_dlnk_hours),int(start_dlnk_minutes),int(start_dlnk_seconds))
                end_dlnk_datetime = datetime.datetime(end_dlnk[0],end_dlnk[1],end_dlnk[2],int(end_dlnk_hours),int(end_dlnk_minutes),int(end_dlnk_seconds))

                downlink_times_datetime[sat_indx][gs_num-1].append([start_dlnk_datetime,end_dlnk_datetime])

    # import crosslinks
    crosslink_times_datetime = [[[]  for j in range(num_sats)] for k in range(num_sats)]
    for sat_indx in xrange(0,num_sats):
        if not len(t_x) > 0:
            break

        xlnk_list = t_x[sat_indx]

        for xlnk_indx, xlnk in enumerate(xlnk_list):

            # if it's not empty
            if xlnk.any():
                other_sat_num = x_part[sat_indx][xlnk_indx][0][0]

                # do a bunch of crap to convert to datetime. Note that jd2gcal returns year,month,day, FRACTION OF DAY (GOD WHY!?) so we have to convert.
                start_xlnk = jdcal.jd2gcal(jdcal.MJD_0,xlnk[0][0])
                end_xlnk = jdcal.jd2gcal(jdcal.MJD_0,xlnk[0][1])
                start_xlnk_hours = math.floor(start_xlnk[3]*24)
                start_xlnk_minutes = math.floor((start_xlnk[3]*24-start_xlnk_hours) * 60)
                start_xlnk_seconds = math.floor(((start_xlnk[3]*24-start_xlnk_hours) * 60 - start_xlnk_minutes) * 60)
                end_xlnk_hours = math.floor(end_xlnk[3]*24)
                end_xlnk_minutes = math.floor((end_xlnk[3]*24-end_xlnk_hours) * 60)
                end_xlnk_seconds = math.floor(((end_xlnk[3]*24-end_xlnk_hours) * 60 - end_xlnk_minutes) * 60)
                start_xlnk_datetime = datetime.datetime(start_xlnk[0],start_xlnk[1],start_xlnk[2],int(start_xlnk_hours),int(start_xlnk_minutes),int(start_xlnk_seconds))
                end_xlnk_datetime = datetime.datetime(end_xlnk[0],end_xlnk[1],end_xlnk[2],int(end_xlnk_hours),int(end_xlnk_minutes),int(end_xlnk_seconds))

                crosslink_times_datetime[sat_indx][other_sat_num-1].append([start_xlnk_datetime,end_xlnk_datetime])

    # import observations
    observation_times_datetime = [[] for k in range(num_sats)]
    for sat_indx in xrange(0,num_sats):
        if not len(t_o) > 0:
            break

        obs_list = t_o[sat_indx]

        for obs_indx, obs in enumerate(obs_list):

            # if it's not empty
            if obs.any():

                # do a bunch of crap to convert to datetime. Note that jd2gcal returns year,month,day, FRACTION OF DAY (GOD WHY!?) so we have to convert.
                start_obs = jdcal.jd2gcal(jdcal.MJD_0,obs[0][0])
                end_obs = jdcal.jd2gcal(jdcal.MJD_0,obs[0][1])
                start_obs_hours = math.floor(start_obs[3]*24)
                start_obs_minutes = math.floor((start_obs[3]*24-start_obs_hours) * 60)
                start_obs_seconds = math.floor(((start_obs[3]*24-start_obs_hours) * 60 - start_obs_minutes) * 60)
                end_obs_hours = math.floor(end_obs[3]*24)
                end_obs_minutes = math.floor((end_obs[3]*24-end_obs_hours) * 60)
                end_obs_seconds = math.floor(((end_obs[3]*24-end_obs_hours) * 60 - end_obs_minutes) * 60)
                start_obs_datetime = datetime.datetime(start_obs[0],start_obs[1],start_obs[2],int(start_obs_hours),int(start_obs_minutes),int(start_obs_seconds))
                end_obs_datetime = datetime.datetime(end_obs[0],end_obs[1],end_obs[2],int(end_obs_hours),int(end_obs_minutes),int(end_obs_seconds))

                observation_times_datetime[sat_indx].append([start_obs_datetime,end_obs_datetime])

    # import gs availability windows
    gsavail_times_datetime = [[] for k in range(num_gs)]
    for gs_indx in xrange(0,num_gs):
        if not len(gs_availability_windows) > 0:
            break

        gs_avail_list = gs_availability_windows[gs_indx]

        for avail_wind_indx, avail_wind in enumerate(gs_avail_list):

            # if it's not empty
            if avail_wind.any():

                # do a bunch of crap to convert to datetime. Note that jd2gcal returns year,month,day, FRACTION OF DAY (GOD WHY!?) so we have to convert.
                start_gs_avail = jdcal.jd2gcal(jdcal.MJD_0,avail_wind[0][0])
                end_gs_avail = jdcal.jd2gcal(jdcal.MJD_0,avail_wind[0][1])
                start_gs_avail_hours = math.floor(start_gs_avail[3]*24)
                start_gs_avail_minutes = math.floor((start_gs_avail[3]*24-start_gs_avail_hours) * 60)
                start_gs_avail_seconds = math.floor(((start_gs_avail[3]*24-start_gs_avail_hours) * 60 - start_gs_avail_minutes) * 60)
                end_gs_avail_hours = math.floor(end_gs_avail[3]*24)
                end_gs_avail_minutes = math.floor((end_gs_avail[3]*24-end_gs_avail_hours) * 60)
                end_gs_avail_seconds = math.floor(((end_gs_avail[3]*24-end_gs_avail_hours) * 60 - end_gs_avail_minutes) * 60)
                start_gs_avail_datetime = datetime.datetime(start_gs_avail[0],start_gs_avail[1],start_gs_avail[2],int(start_gs_avail_hours),int(start_gs_avail_minutes),int(start_gs_avail_seconds))
                end_gs_avail_datetime = datetime.datetime(end_gs_avail[0],end_gs_avail[1],end_gs_avail[2],int(end_gs_avail_hours),int(end_gs_avail_minutes),int(end_gs_avail_seconds))

                gsavail_times_datetime[gs_indx].append([start_gs_avail_datetime,end_gs_avail_datetime])

    # import eclipse times
    eclipse_times_datetime = [[] for k in range(num_sats)]
    for sat_indx in xrange(0,num_sats):
        if not len(t_eclipse) > 0:
            break

        eclipse_list = t_eclipse[sat_indx]

        for eclipse_wind_indx, eclipse_wind in enumerate(eclipse_list):

            # if it's not empty
            if eclipse_wind.any():

                # do a bunch of crap to convert to datetime. Note that jd2gcal returns year,month,day, FRACTION OF DAY (GOD WHY!?) so we have to convert.
                start_eclipse = jdcal.jd2gcal(jdcal.MJD_0,eclipse_wind[0][0])
                end_eclipse = jdcal.jd2gcal(jdcal.MJD_0,eclipse_wind[0][1])
                start_eclipse_hours = math.floor(start_eclipse[3]*24)
                start_eclipse_minutes = math.floor((start_eclipse[3]*24-start_eclipse_hours) * 60)
                start_eclipse_seconds = math.floor(((start_eclipse[3]*24-start_eclipse_hours) * 60 - start_eclipse_minutes) * 60)
                end_eclipse_hours = math.floor(end_eclipse[3]*24)
                end_eclipse_minutes = math.floor((end_eclipse[3]*24-end_eclipse_hours) * 60)
                end_eclipse_seconds = math.floor(((end_eclipse[3]*24-end_eclipse_hours) * 60 - end_eclipse_minutes) * 60)
                start_eclipse_datetime = datetime.datetime(start_eclipse[0],start_eclipse[1],start_eclipse[2],int(start_eclipse_hours),int(start_eclipse_minutes),int(start_eclipse_seconds))
                end_eclipse_datetime = datetime.datetime(end_eclipse[0],end_eclipse[1],end_eclipse[2],int(end_eclipse_hours),int(end_eclipse_minutes),int(end_eclipse_seconds))

                eclipse_times_datetime[sat_indx].append([start_eclipse_datetime,end_eclipse_datetime])






    ########################################
    # File Writing
    ########################################

    czml_content = []

    all_fd = open(output_viz_czml_file, "w")

    start_avail= datetime.datetime.strptime(startdatestr,'%d %b %Y %H:%M:%S.%f')
    end_avail= datetime.datetime.strptime(enddatestr,'%d %b %Y %H:%M:%S.%f')

    history_epoch = start_avail

    GS_names_choice = GS_names[gs_network][0]

    sat_pos_ref_pre = 'Satellite/CubeSat'
    pos_ref_post = '#position'
    orient_ref_post = '#orientation'
    gs_pos_ref_pre ='Facility/'

    # create downlinks
    if len(t_d) > 0:
        dlnk_color = [0,0,255,255]
        i = 0
        for sat_indx in xrange(num_sats):
            for gs_indx in xrange(num_gs):
                name = 'downlink '+str(i)

                dlnks_datetime = downlink_times_datetime[sat_indx][gs_indx]

                # print dlnks_datetime
                ID = 'Dlnk/Sat'+str(sat_indx+1)+'-GS'+str(gs_indx+1)

                gs_name = GS_names_choice[gs_indx][0][0]
                czml_content.append(cztl.createLinkPacket(ID,name,start_avail,end_avail, polyline_show_times = dlnks_datetime, color=dlnk_color,reference1=sat_pos_ref_pre+str(sat_indx+1)+pos_ref_post,reference2=gs_pos_ref_pre+gs_name+pos_ref_post))

                i+=1

    # create crosslinks
    if len(t_x) > 0:
        xlnk_color = [255,0,0,255]
        i = 0
        for sat_indx in xrange(num_sats):
            for other_sat_indx in xrange(sat_indx+1,num_sats):
                name = 'crosslink '+str(i)

                xlnks_datetime = crosslink_times_datetime[sat_indx][other_sat_indx]

                # print dlnks_datetime
                ID = 'Xlnk/Sat'+str(sat_indx+1)+'-Sat'+str(other_sat_indx+1)

                czml_content.append(cztl.createLinkPacket(ID,name,start_avail,end_avail, polyline_show_times = xlnks_datetime, color=xlnk_color,reference1=sat_pos_ref_pre+str(sat_indx+1)+pos_ref_post,reference2=sat_pos_ref_pre+str(other_sat_indx+1)+pos_ref_post))

                i+=1

    # create observations
    if len(t_o) > 0:
        for sat_indx in xrange(num_sats):
            name = 'observation sensor 1 for satellite '+str(sat_indx+1)

            obs_datetime = observation_times_datetime[sat_indx]

            # print dlnks_datetime
            ID = 'Satellite/CubeSat'+str(sat_indx+1)+'/Sensor/Sensor1'

            parent = 'Satellite/CubeSat'+str(sat_indx+1)

            czml_content.append(cztl.createObsPacket(ID,name,parent,start_avail,end_avail, sensor_show_times = obs_datetime, lateral_color=[0,255,0,51],intersection_color=[0,255,0,255],position_ref=sat_pos_ref_pre+str(sat_indx+1)+pos_ref_post,orientation_ref=sat_pos_ref_pre+str(sat_indx+1)+orient_ref_post))

    # create q_o_sizes_history
    if len(q_o_sizes_history) > 0:
        epoch = datetime.datetime(2017, 3, 15, 10, 0, 0)
        for sat_indx in xrange(num_sats):

            name = 'q_o_sizes_history for satellite '+str(sat_indx+1)

            ID = 'Satellite/CubeSat'+str(sat_indx+1)

            czml_content.append(cztl.createSampledPropertyHistory(ID,name, 'datavol',history_epoch, q_o_sizes_history[sat_indx][0], filter_seconds_beg=0,filter_seconds_end=86400))

    # create gs_avail_windows
    if len(gs_availability_windows) > 0:
        for gs_indx in xrange(num_gs):
            name = 'gs avail windows gs num '+str(gs_indx+1)

            gsavail_datetime = gsavail_times_datetime[gs_indx]

            # print dlnks_datetime
            gs_name = GS_names_choice[gs_indx][0][0]
            ID = 'Facility/'+gs_name

            czml_content.append(cztl.createShowIntervalsPacket(ID,name,'gs_availability',show_times = gsavail_datetime))

    # create batt_stored_history
    if len(batt_stored_history) > 0:
        epoch = datetime.datetime(2017, 3, 15, 10, 0, 0)
        for sat_indx in xrange(num_sats):

            name = 'batt_stored_history for satellite '+str(sat_indx+1)

            ID = 'Satellite/CubeSat'+str(sat_indx+1)

            czml_content.append(cztl.createSampledPropertyHistory(ID,name, 'battery',history_epoch, batt_stored_history[sat_indx][0], filter_seconds_beg=0,filter_seconds_end=86400))

    # create eclipse "availability" windows
    if len(t_eclipse) > 0:
        for sat_indx in xrange(num_sats):
            name = 'eclipse times sat num '+str(sat_indx+1)

            eclipse_datetime = eclipse_times_datetime[sat_indx]

            # print dlnks_datetime
            ID = 'Satellite/CubeSat'+str(sat_indx+1)

            czml_content.append(cztl.createShowIntervalsPacket(ID,name,'eclipse',show_times = eclipse_datetime))


    # create dlnk_rate_history
    if len(dlnk_rate_history) > 0:
        epoch = datetime.datetime(2017, 3, 15, 10, 0, 0)
        i = 0
        for sat_indx in xrange(num_sats):
            for gs_indx in xrange(num_gs):

                name = 'dlnk_rate_history for downlink '+str(i)+', satellite '+str(sat_indx+1)+' and GS '+str(gs_indx+1)

                # needs to have same ID as original downlink to work
                ID = 'Dlnk/Sat'+str(sat_indx+1)+'-GS'+str(gs_indx+1)

                if dlnk_rate_history[sat_indx][gs_indx].any():
                    pkt = cztl.createSampledPropertyHistory(ID,name, 'datarate',history_epoch, dlnk_rate_history[sat_indx][gs_indx], filter_seconds_beg=0,filter_seconds_end=86400)

                    # attach a proxy position for displaying data rate text
                    gs_name = GS_names_choice[gs_indx][0][0]
                    pkt['position_proxy'] = {"reference": gs_pos_ref_pre+gs_name+pos_ref_post}

                    czml_content.append(pkt)

                i+=1


    # create xlnk_rate_history
    if len(xlnk_rate_history) > 0:
        epoch = datetime.datetime(2017, 3, 15, 10, 0, 0)
        i = 0
        for sat_indx in xrange(num_sats):
            for other_sat_indx in xrange(sat_indx+1,num_sats):

                name = 'xlnk_rate_history for crosslink '+str(i)+', satellite '+str(sat_indx+1)+' and xsat '+str(other_sat_indx+1)

                # needs to have same ID as original crosslink to work
                ID = 'Xlnk/Sat'+str(sat_indx+1)+'-Sat'+str(other_sat_indx+1)

                if xlnk_rate_history[sat_indx][other_sat_indx].any():
                    pkt = cztl.createSampledPropertyHistory(ID,name,'datarate',history_epoch, xlnk_rate_history[sat_indx][other_sat_indx], filter_seconds_beg=0,filter_seconds_end=86400)

                    # attach a proxy position for displaying data rate text
                    pkt['position_proxy'] = {"reference": sat_pos_ref_pre+str(sat_indx+1)+pos_ref_post}

                    czml_content.append(pkt)

                i+=1



    metadata = collections.OrderedDict()
    metadata['metadata_satsfile_updater'] = 'dummy_string'
    metadata['sim_output_updated'] = sim_output_time
    metadata['json_updated'] = datetime.datetime.now().strftime('%Y %m %d %H:%M:%S')
    metadata['file_writer_info_string'] = file_writer_info_string
    czml_content.append(metadata)


    # write to file
    json.dump(czml_content,all_fd,indent=2,sort_keys=False)

def writeRendererDescription(file_from_sim = './timing_output.mat',renderer_description_file = '../renderers/description.json', renderers_list = ['/Apps/MATLAB_SatViz/renderers/test.js'], renderer_mapping = {'Satellite':['Test'],'Facility':['Test']}):

    mat = scipy.io.loadmat(file_from_sim)

    # print mat
    GS_names = mat['GS_names']
    gs_network = mat['gs_network'][0][0]
    GS_names_choice = GS_names[gs_network][0]
    t_o = mat['t_o']
    num_sats = mat['num_satellites'][0][0]
    sim_output_time = str(mat['creation_time'][0])
    num_gs = mat['num_gs'][0][0]
    dlnk_rate_history = mat['dlnk_rate_history']
    xlnk_rate_history = mat['xlnk_rate_history']

    if 'info_string' in mat.keys():
        file_writer_info_string = str(mat['info_string'][0])
    else:
        file_writer_info_string = 'no file writer info string found'


    json_content = collections.OrderedDict()

    json_content['renderers'] = renderers_list

    renderMapping = collections.OrderedDict()

    if 'Satellite' in renderer_mapping.keys():
        for i in xrange(num_sats):
            renderMapping['Satellite/CubeSat'+str(i+1)] = renderer_mapping['Satellite']

    if 'Facility' in renderer_mapping.keys():
        for name in GS_names_choice:
            gs_name = name[0][0]
            renderMapping['Facility/'+str(gs_name)] = renderer_mapping['Facility']

    if 'Dlnk' in renderer_mapping.keys() and len(dlnk_rate_history)>0:
        for i in xrange(num_sats):
            for j in xrange(num_gs):
                if dlnk_rate_history[i][j].any():
                    renderMapping['Dlnk/Sat'+str(i+1)+'-GS'+str(j+1)] = renderer_mapping['Dlnk']

    if 'Xlnk' in renderer_mapping.keys() and len(xlnk_rate_history)>0:
        for i in xrange(num_sats):
            for j in xrange(i+1,num_sats):
                if xlnk_rate_history[i][j].any():
                    renderMapping['Xlnk/Sat'+str(i+1)+'-Sat'+str(j+1)] = renderer_mapping['Xlnk']

    json_content['renderMapping'] = renderMapping

    metadata = collections.OrderedDict()
    metadata['sim_output_updated'] = sim_output_time
    metadata['json_updated'] = datetime.datetime.now().strftime('%Y %m %d %H:%M:%S')
    metadata['file_writer_info_string'] = file_writer_info_string
    json_content['metadata_satsfile_updater'] = metadata

    fd = open(renderer_description_file, "w")
    json.dump(json_content,fd,indent=2,sort_keys=False)

def writeVizObjectsFile(file_from_sim = './timing_output.mat',vizobj_file = '../app_data_files/viz_objects.json', callbacks_mapping = {'Satellite':["orientation","drawNadirRF"]}):

    mat = scipy.io.loadmat(file_from_sim)

    t_o = mat['t_o']
    num_sats = mat['num_satellites'][0][0]
    sim_output_time = str(mat['creation_time'][0])

    if 'info_string' in mat.keys():
        file_writer_info_string = str(mat['info_string'][0])
    else:
        file_writer_info_string = 'no file writer info string found'


    json_content = collections.OrderedDict()

    callbacks = collections.OrderedDict()

    if 'Satellite' in callbacks_mapping.keys():
        sat_cllbks = callbacks_mapping['Satellite']

        for cllbk in sat_cllbks:
            cllbk_items = []

            for i in xrange(num_sats):
                cllbk_items.append('Satellite/CubeSat'+str(i+1))

            callbacks[cllbk] = cllbk_items

    json_content['callbacks'] = callbacks

    metadata = collections.OrderedDict()
    metadata['sim_output_updated'] = sim_output_time
    metadata['json_updated'] = datetime.datetime.now().strftime('%Y %m %d %H:%M:%S')
    metadata['file_writer_info_string'] = file_writer_info_string
    json_content['metadata_satsfile_updater'] = metadata

    fd = open(vizobj_file, "w")
    json.dump(json_content,fd,indent=2,sort_keys=False)

if __name__ == '__main__':
    generateVizInputs()