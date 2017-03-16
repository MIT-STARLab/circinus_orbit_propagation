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

# mat = scipy.io.loadmat('../../../Comm_constellation_MDO/landing_pad/timing_output.mat')

mat = scipy.io.loadmat('timing_output.mat')

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


# print t_o
# print o_locations
num_sats = len(t_o)


########################################
# Import data
########################################


# import downlinks

downlink_times_datetime = [[[]  for j in range(num_gs)] for k in range(num_sats)]

for sat_indx in xrange(0,num_sats):
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







########################################
# File Writing
########################################

all_fd = open("out.json", "w")

start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0)
end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0)

GS_names_choice = GS_names[gs_network][0]

sat_pos_ref_pre = 'Satellite/CubeSat'
pos_ref_post = '#position'
sat_pos_ref_pre = 'Satellite/CubeSat'
pos_ref_post = '#position'
gs_pos_ref_pre ='Facility/'


# write downlinks
dlnk_color_str = '0,0,255,255'

i = 0
for sat_indx in xrange(num_sats):
    for gs_indx in xrange(num_gs):
        name = 'downlink '+str(i)

        dlnks_datetime = downlink_times_datetime[sat_indx][gs_indx]

        # print dlnks_datetime
        ID = 'Dlnk/Sat'+str(sat_indx+1)+'-GS'+str(gs_indx+1)

        gs_name = GS_names_choice[gs_indx][0][0]
        cztl.writeLinkPacket(all_fd,ID,name,start_avail,end_avail, polyline_show_times = dlnks_datetime, color_str=dlnk_color_str,reference1=sat_pos_ref_pre+str(sat_indx+1)+pos_ref_post,reference2=gs_pos_ref_pre+gs_name+pos_ref_post)

        i+=1


# write crosslinks
xlnk_color_str = '255,0,0,255'

i = 0
for sat_indx in xrange(num_sats):
    for other_sat_indx in xrange(sat_indx+1,num_sats):
        name = 'crosslink '+str(i)

        xlnks_datetime = crosslink_times_datetime[sat_indx][other_sat_indx]

        # print dlnks_datetime
        ID = 'Xlnk/Sat'+str(sat_indx+1)+'-Sat'+str(other_sat_indx+1)

        cztl.writeLinkPacket(all_fd,ID,name,start_avail,end_avail, polyline_show_times = xlnks_datetime, color_str=xlnk_color_str,reference1=sat_pos_ref_pre+str(sat_indx+1)+pos_ref_post,reference2=sat_pos_ref_pre+str(other_sat_indx+1)+pos_ref_post)

        i+=1



# write observations
obscone_color_str = '255,0,0,150'

for sat_indx in xrange(num_sats):
    name = 'obs sat '+str(sat_indx+1)

    obs_datetime = observation_times_datetime[sat_indx]

    # print dlnks_datetime
    ID = 'Obs/Sat'+str(sat_indx+1)

    cztl.writeObsPacket(all_fd,ID,name,start_avail,end_avail, cylinder_show_times = obs_datetime, color_str=obscone_color_str,position_ref=sat_pos_ref_pre+str(sat_indx+1)+pos_ref_post)


# print t_o[0]
# print not t_o[0][20]
# print t_o[0][0][0]
# print t_o[0][0][0][0]



# cztl.writeLinkPacket(all_fd)

# cztl.writeLinkPacket(all_fd,ID='Xlnk/Sat4-to-Sat3',name='a link',start_avail,end_avail, polyline_show_times = [[datetime.datetime(2017, 3, 15, 12, 0, 0),datetime.datetime(2017, 3, 16, 01, 0, 0)],[datetime.datetime(2017, 3, 16, 5, 0, 0),datetime.datetime(2017, 3, 16, 9, 0, 0)]], color_str='0,0,255,255',reference1='Satellite/CubeSatN#position',reference2='Satellite/CubeSatM#position')

all_fd.close()