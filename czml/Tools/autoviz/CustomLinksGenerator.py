# use the SublimePrettyJson package in to pretty print the output czml correctly (note that the json has to be valid for pretty print to work). Link: https://github.com/dzhibas/SublimePrettyJson/issues

# using jdcal package for dealing with modified julian dates from MATLAB code
# See https://oneau.wordpress.com/2011/08/30/jdcal/
# sudo pip install jdcal

# e.g.
# print jdcal.jd2gcal(jdcal.MJD_0,57827.5774306)  #have to pass both base date of MJD and the MJD to this function

# import CZMLtextTools as cztl
import jdcal

import CZMLtextTools as cztl

import datetime

import json

num_sats = 40



# import crosslinks

# crosslink_times_datetime = [[[]  for j in range(num_sats)] for k in range(num_sats)]

# for sat_indx in xrange(0,10):
#     other_sat_indx = (sat_indx + 1) % 10

#     time1 = datetime.datetime(2017, 03, 15, 20, 29,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
#     time2 = datetime.datetime(2017, 03, 15, 20, 30,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
#     crosslink_times_datetime[sat_indx][other_sat_indx] = [time1,time2]


# for sat_indx in xrange(10,20):
#     other_sat_indx = (sat_indx + 1) % 10 + 10

#     time1 = datetime.datetime(2017, 03, 15, 20, 31,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
#     time2 = datetime.datetime(2017, 03, 15, 20, 32,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
#     crosslink_times_datetime[sat_indx][other_sat_indx] = [time1,time2]

# for sat_indx in xrange(20,30):
#     other_sat_indx = (sat_indx + 1) % 10 + 20

#     time1 = datetime.datetime(2017, 03, 15, 20, 32,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
#     time2 = datetime.datetime(2017, 03, 15, 20, 33,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
#     crosslink_times_datetime[sat_indx][other_sat_indx] = [time1,time2]


# for sat_indx in xrange(30,40):
#     other_sat_indx = (sat_indx + 1) % 10 + 30

#     time1 = datetime.datetime(2017, 03, 15, 20, 29,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
#     time2 = datetime.datetime(2017, 03, 15, 20, 30,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
#     crosslink_times_datetime[sat_indx][other_sat_indx] = [time1,time2]




# sat_indx = 0
# other_sat_indx = 38
# time1 = datetime.datetime(2017, 03, 15, 20, 29,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# time2 = datetime.datetime(2017, 03, 15, 20, 30,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# crosslink_times_datetime[sat_indx][other_sat_indx] = [time1,time2]

# sat_indx = 8
# other_sat_indx = 18
# time1 = datetime.datetime(2017, 03, 15, 20, 31,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# time2 = datetime.datetime(2017, 03, 15, 20, 32,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# crosslink_times_datetime[sat_indx][other_sat_indx] = [time1,time2]

# sat_indx = 8
# other_sat_indx = 27
# time1 = datetime.datetime(2017, 03, 15, 20, 31,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# time2 = datetime.datetime(2017, 03, 15, 20, 32,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# crosslink_times_datetime[sat_indx][other_sat_indx] = [time1,time2]

# sat_indx = 7
# other_sat_indx = 28
# time1 = datetime.datetime(2017, 03, 15, 20, 32,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# time2 = datetime.datetime(2017, 03, 15, 20, 33,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# crosslink_times_datetime[sat_indx][other_sat_indx] = [time1,time2]

# sat_indx = 7
# other_sat_indx = 17
# time1 = datetime.datetime(2017, 03, 15, 20, 32,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# time2 = datetime.datetime(2017, 03, 15, 20, 33,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# crosslink_times_datetime[sat_indx][other_sat_indx] = [time1,time2]

# sat_indx = 37
# other_sat_indx = 25
# time1 = datetime.datetime(2017, 03, 15, 20, 31,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# time2 = datetime.datetime(2017, 03, 15, 20, 32,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# crosslink_times_datetime[sat_indx][other_sat_indx] = [time1,time2]

# sat_indx = 39
# other_sat_indx = 10
# time1 = datetime.datetime(2017, 03, 15, 20, 30,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# time2 = datetime.datetime(2017, 03, 15, 20, 31,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# crosslink_times_datetime[sat_indx][other_sat_indx] = [time1,time2]

# sat_indx = 39
# other_sat_indx = 10
# time1 = datetime.datetime(2017, 03, 15, 20, 30,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# time2 = datetime.datetime(2017, 03, 15, 20, 31,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# crosslink_times_datetime[sat_indx][other_sat_indx] = [time1,time2]

# sat_indx = 2
# other_sat_indx = 23
# time1 = datetime.datetime(2017, 03, 15, 20, 31,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# time2 = datetime.datetime(2017, 03, 15, 20, 32,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# crosslink_times_datetime[sat_indx][other_sat_indx] = [time1,time2]

# sat_indx = 2
# other_sat_indx = 12
# time1 = datetime.datetime(2017, 03, 15, 20, 31,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# time2 = datetime.datetime(2017, 03, 15, 20, 32,00 ).strftime('%Y-%m-%dT%H:%M:%SZ')
# crosslink_times_datetime[sat_indx][other_sat_indx] = [time1,time2]



# fd = open("misc/autoviz_stuff.json", "w")

# json.dump(crosslink_times_datetime,fd,indent=4)

# fd.close()






########################################
# File Writing
########################################

fd2 = open("misc/autoviz_stuff.json", "r")

crosslink_times_datetime = json.load(fd2)

fd2.close()

for sat_indx in xrange(num_sats):
    for other_sat_indx in xrange(num_sats):
        temp_times_str = crosslink_times_datetime[sat_indx][other_sat_indx]

        if len(temp_times_str) > 1:
            time1_datetime = datetime.datetime.strptime(temp_times_str[0],'%Y-%m-%dT%H:%M:%SZ')
            time2_datetime = datetime.datetime.strptime(temp_times_str[1],'%Y-%m-%dT%H:%M:%SZ')

            crosslink_times_datetime[sat_indx][other_sat_indx] = [[time1_datetime, time2_datetime]]

        else:
            crosslink_times_datetime[sat_indx][other_sat_indx] = []




all_fd = open("out2.json", "w")
all_fd.write( '[\n')

start_avail=datetime.datetime(2017, 3, 15, 11, 0, 0)
end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0)

data_hist_epoch = datetime.datetime(2017, 3, 15, 10, 0, 0)



sat_pos_ref_pre = 'Satellite/CubeSat'
pos_ref_post = '#position'
sat_pos_ref_pre = 'Satellite/CubeSat'
pos_ref_post = '#position'
gs_pos_ref_pre ='Facility/'



# write crosslinks
xlnk_color_str = '255,165,0,255'

i = 0
for sat_indx in xrange(num_sats):
    for other_sat_indx in xrange(num_sats):
        name = 'crosslink '+str(i)

        xlnks_datetime = crosslink_times_datetime[sat_indx][other_sat_indx]

        if xlnks_datetime:
            # print dlnks_datetime
            ID = 'Xlnk/postetna/Sat'+str(sat_indx+1)+'-Sat'+str(other_sat_indx+1)

            cztl.writeLinkPacket(all_fd,ID,name,start_avail,end_avail, polyline_show_times = xlnks_datetime, color_str=xlnk_color_str,reference1=sat_pos_ref_pre+str(sat_indx+1)+pos_ref_post,reference2=sat_pos_ref_pre+str(other_sat_indx+1)+pos_ref_post)

            i+=1




all_fd.write( ']')



all_fd.close()