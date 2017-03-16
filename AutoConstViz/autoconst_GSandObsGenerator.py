# use the SublimePrettyJson package in to pretty print the output czml correctly (note that the json has to be valid for pretty print to work). Link: https://github.com/dzhibas/SublimePrettyJson/issues

import sys
sys.path
sys.path.append('../czml/Tools')

import CZMLtextTools as cztl

import datetime

all_fd = open("out.json", "w")

all_fd.write( '[\n');

# GS and targets based on parameters_descope_2 from MDO work

start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0)
end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0)


cztl.writeGStext(all_fd,'Prudhoe Bay 1',start_avail,end_avail,latitude=70.37,longitude=  -148.75)
cztl.writeGStext(all_fd,'Fairbanks 2',start_avail,end_avail,latitude=64.84 ,longitude=  -147.65)
cztl.writeGStext(all_fd,'Seattle 3',start_avail,end_avail,latitude=47.61,longitude=   -122.33)
cztl.writeGStext(all_fd,'New Mexico 4',start_avail,end_avail,latitude=32.79,longitude=   -106.33)
cztl.writeGStext(all_fd,'New England 5',start_avail,end_avail,latitude=42.94,longitude=-71.64)
cztl.writeGStext(all_fd,'Hawaii 6',start_avail,end_avail,latitude=19.90 ,longitude=-155.58)
cztl.writeGStext(all_fd,'Florida 7',start_avail,end_avail,latitude=26.75,longitude=   -80.93)
cztl.writeGStext(all_fd,'Argentina 8',start_avail,end_avail,latitude=-53.16,longitude=  -70.92)
cztl.writeGStext(all_fd,'Brazil 9',start_avail,end_avail,latitude=-18.42,longitude=  -45.63)
cztl.writeGStext(all_fd,'Munich 10',start_avail,end_avail,latitude=48.14,longitude=   11.58)
cztl.writeGStext(all_fd,'Norway 11',start_avail,end_avail,latitude=67.32 ,longitude=  14.78)
cztl.writeGStext(all_fd,'South Africa 12',start_avail,end_avail,latitude=-25.89,longitude=  27.69)
cztl.writeGStext(all_fd,'Dubai 13',start_avail,end_avail,latitude=25.20 ,longitude= 55.27)
cztl.writeGStext(all_fd,'Singapore 14',start_avail,end_avail,latitude=1.35 ,longitude=   103.82)
cztl.writeGStext(all_fd,'Guam 15',start_avail,end_avail,latitude=13.44 ,longitude= 144.79)
cztl.writeGStext(all_fd,'Japan 16',start_avail,end_avail,latitude=37.52  ,longitude= 139.67)
cztl.writeGStext(all_fd,'New Zealand 17',start_avail,end_avail,latitude=-46.51 ,longitude= 168.38)

cztl.writeObsText(all_fd,'New York 1',start_avail,end_avail,latitude=40.705565,longitude=-74.1180866)
cztl.writeObsText(all_fd,'Chicago 2',start_avail,end_avail,latitude=41.8336478,longitude=-87.8722384)
cztl.writeObsText(all_fd,'S. California 3',start_avail,end_avail,latitude=33.833765,longitude=-117.372769)
cztl.writeObsText(all_fd,'Central Valley 4',start_avail,end_avail,latitude=36.125231,longitude=-119.603913)
cztl.writeObsText(all_fd,'San Francisco 5',start_avail,end_avail,latitude=37.783587,longitude=-122.420643)
cztl.writeObsText(all_fd,'Colorado 6',start_avail,end_avail,latitude=39.358974,longitude=-106.789534)
cztl.writeObsText(all_fd,'Mount Rainier 7',start_avail,end_avail,latitude=46.865919,longitude=-121.75011)
cztl.writeObsText(all_fd,'Havana 8',start_avail,end_avail,latitude=23.0907,longitude=-82.31092)
cztl.writeObsText(all_fd,'Amazon 9',start_avail,end_avail,latitude=-3.113053,longitude=-60.010668)
cztl.writeObsText(all_fd,'Sao Paulo 10',start_avail,end_avail,latitude=-23.404804,longitude=-46.858481)
cztl.writeObsText(all_fd,'Buenos Aires 11',start_avail,end_avail,latitude=-34.85161,longitude=-58.620841)
cztl.writeObsText(all_fd,'Panama Canal 12',start_avail,end_avail,latitude=9.174024,longitude=-79.670526)
cztl.writeObsText(all_fd,'Paris 13',start_avail,end_avail,latitude=48.625623,longitude=2.300722)
cztl.writeObsText(all_fd,'Berlin 14',start_avail,end_avail,latitude=52.546047,longitude=13.321765)
cztl.writeObsText(all_fd,'Vienna 15',start_avail,end_avail,latitude=48.15443,longitude=16.375964)
cztl.writeObsText(all_fd,'Moscow 16',start_avail,end_avail,latitude=55.700184,longitude=37.686186)
cztl.writeObsText(all_fd,'North Sea 17',start_avail,end_avail,latitude=59.242012,longitude=3.505061)
cztl.writeObsText(all_fd,'Suez Canal 18',start_avail,end_avail,latitude=30.705666,longitude=32.381991)
cztl.writeObsText(all_fd,'Kuwait 19',start_avail,end_avail,latitude=29.588284,longitude=49.081795)
cztl.writeObsText(all_fd,'Dubai 20',start_avail,end_avail,latitude=25.250257,longitude=55.339891)
cztl.writeObsText(all_fd,'Lagos 21',start_avail,end_avail,latitude=6.520423,longitude=3.379779)
cztl.writeObsText(all_fd,'DRC 22',start_avail,end_avail,latitude=-2.024093,longitude=22.173712)
cztl.writeObsText(all_fd,'Cape Town 23',start_avail,end_avail,latitude=-33.872026,longitude=18.526935)
cztl.writeObsText(all_fd,'Mumbai 24',start_avail,end_avail,latitude=19.004886,longitude=72.863436)
cztl.writeObsText(all_fd,'New Delhi 25',start_avail,end_avail,latitude=28.585252,longitude=77.195693)
cztl.writeObsText(all_fd,'Dhaka 26',start_avail,end_avail,latitude=23.625859,longitude=90.447047)
cztl.writeObsText(all_fd,'Bangkok 27',start_avail,end_avail,latitude=13.673364,longitude=100.950904)
cztl.writeObsText(all_fd,'Singapore 28',start_avail,end_avail,latitude=1.37434,longitude=103.851294)
cztl.writeObsText(all_fd,'Hong Kong 29',start_avail,end_avail,latitude=22.440325,longitude=114.155498)
cztl.writeObsText(all_fd,'Shanghai 30',start_avail,end_avail,latitude=31.240996,longitude=121.198994)
cztl.writeObsText(all_fd,'Beijing 31',start_avail,end_avail,latitude=39.757344,longitude=116.369419)
cztl.writeObsText(all_fd,'Tokyo 32',start_avail,end_avail,latitude=35.664099,longitude=139.504185)
cztl.writeObsText(all_fd,'Omsk 33',start_avail,end_avail,latitude=54.922771,longitude=73.898349)
cztl.writeObsText(all_fd,'Sydney 34',start_avail,end_avail,latitude=-33.955051,longitude=150.866372)
cztl.writeObsText(all_fd,'Perth 35',start_avail,end_avail,latitude=-31.91244,longitude=116.738662)

all_fd.write( ']\n');

all_fd.close()