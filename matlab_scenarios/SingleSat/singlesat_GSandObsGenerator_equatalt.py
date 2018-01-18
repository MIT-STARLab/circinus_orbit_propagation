# use the SublimePrettyJson package in to pretty print the output czml correctly (note that the json has to be valid for pretty print to work). Link: https://github.com/dzhibas/SublimePrettyJson/issues

import sys
sys.path
sys.path.append('../../czml/Tools')

import CZMLtextTools as cztl
import datetime
import json

czml_content = []

all_fd = open("out.json", "w")

# GS and targets based on parameters_descope_2 from MDO work

start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0)
end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0)

czml_content.append(cztl.createGS('Singapore 1',start_avail,end_avail,latitude=1.3309905,longitude=103.8024025))
czml_content.append(cztl.createGS('Fortaleza 2',start_avail,end_avail,latitude=-3.7912,longitude=-38.5893))
czml_content.append(cztl.createGS('Nairobi 3',start_avail,end_avail,latitude=-1.2942734,longitude=36.8151043))
czml_content.append(cztl.createGS('Fairbanks 4',start_avail,end_avail,latitude=64.8378,longitude=-147.7164))

json.dump(czml_content,all_fd,indent=2,sort_keys=False)