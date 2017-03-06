# use the SublimePrettyJson package in to pretty print the output czml correctly (note that the json has to be valid for pretty print to work). Link: https://github.com/dzhibas/SublimePrettyJson/issues

import CZMLtextTools as cztl

for sat_num in xrange(1,67):

    sat_name = "Iridium"+str(sat_num)

    sat_fd = open(sat_name+"_pos_stub.czml.part.txt", "w")

    cztl.writeSatTextHeader(sat_fd,name=sat_name,start_avail='2017-03-15T10:00:00Z',end_avail='2017-03-16T10:00:00Z',img_file='CubeSat1.png',scale=0.2,label_text=sat_name)

    # all_fd.write( ']\n');

    sat_fd.close()
