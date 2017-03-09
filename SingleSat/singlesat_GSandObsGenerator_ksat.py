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

cztl.writeGStext(all_fd,'Inuvik 1',start_avail,end_avail,latitude=68.3607,longitude=-133.723)
cztl.writeGStext(all_fd,'Fairbanks 2',start_avail,end_avail,latitude=64.8378,longitude=-147.7164)
cztl.writeGStext(all_fd,'San Luis Obispo 3',start_avail,end_avail,latitude=35.2725611,longitude=-120.7054055)
cztl.writeGStext(all_fd,'Hawaii 4',start_avail,end_avail,latitude=20.72,longitude=-156.26)
cztl.writeGStext(all_fd,'Panama 5',start_avail,end_avail,latitude=8.538,longitude=-80.7821)
cztl.writeGStext(all_fd,'Cordoba 6',start_avail,end_avail,latitude=-31.4201,longitude=-64.1888)
cztl.writeGStext(all_fd,'Argentina 7',start_avail,end_avail,latitude=-53.7790629,longitude=-67.7735569)
cztl.writeGStext(all_fd,'Svalbard 8',start_avail,end_avail,latitude=77.875,longitude=20.9752)
cztl.writeGStext(all_fd,'Vardo 9',start_avail,end_avail,latitude=70.3706,longitude=31.1094)
cztl.writeGStext(all_fd,'Tromso 10',start_avail,end_avail,latitude=69.6492,longitude=18.9553)
cztl.writeGStext(all_fd,'Grimstad 11',start_avail,end_avail,latitude=58.3447,longitude=8.5949)
cztl.writeGStext(all_fd,'Spain 12',start_avail,end_avail,latitude=40.4637,longitude=-3.7492)
cztl.writeGStext(all_fd,'Azores 13',start_avail,end_avail,latitude=37.7412,longitude=-25.6756)
cztl.writeGStext(all_fd,'Central Africa 14',start_avail,end_avail,latitude=4.520619,longitude=9.749752)
cztl.writeGStext(all_fd,'Hartebeesthoek 15',start_avail,end_avail,latitude=-25.64,longitude=28.08)
cztl.writeGStext(all_fd,'Dubai 16',start_avail,end_avail,latitude=25.1,longitude=55.27)
cztl.writeGStext(all_fd,'Mauritius 17',start_avail,end_avail,latitude=-20.3484,longitude=57.5522)
cztl.writeGStext(all_fd,'Bangelore 18',start_avail,end_avail,latitude=12.9716,longitude=77.5946)
cztl.writeGStext(all_fd,'Singapore 19',start_avail,end_avail,latitude=1.3521,longitude=103.8198)
cztl.writeGStext(all_fd,'Tokyo 20',start_avail,end_avail,latitude=35.6895,longitude=139.6917)
cztl.writeGStext(all_fd,'New Zealand 21',start_avail,end_avail,latitude=-40.9006,longitude=174.886)

cztl.writeObsText(all_fd,'Taiwan 1',start_avail,end_avail,latitude=23.6978,longitude=120.9605)
cztl.writeObsText(all_fd,'Dominican Rep. 2',start_avail,end_avail,latitude=18.7357,longitude=-70.1627)
cztl.writeObsText(all_fd,'Jamaica 3',start_avail,end_avail,latitude=18.1096,longitude=-77.2975)
cztl.writeObsText(all_fd,'El Salvador 4',start_avail,end_avail,latitude=13.7942,longitude=-88.8965)
cztl.writeObsText(all_fd,'Guatemala 5',start_avail,end_avail,latitude=14.6349,longitude=-90.5069)
cztl.writeObsText(all_fd,'Antigua and Barbuda 6',start_avail,end_avail,latitude=17.0608,longitude=-61.7964)
cztl.writeObsText(all_fd,'Japan 7',start_avail,end_avail,latitude=36.2048,longitude=138.2529)
cztl.writeObsText(all_fd,'Costa Rica 8',start_avail,end_avail,latitude=9.7489,longitude=-83.7534)
cztl.writeObsText(all_fd,'Philippines 9',start_avail,end_avail,latitude=12.8797,longitude=121.774)
cztl.writeObsText(all_fd,'Colombia 10',start_avail,end_avail,latitude=4.5709,longitude=-74.2973)
cztl.writeObsText(all_fd,'Bangladesh 11',start_avail,end_avail,latitude=23.685,longitude=90.3563)
cztl.writeObsText(all_fd,'Chile 12',start_avail,end_avail,latitude=-35.6751,longitude=-71.543)
cztl.writeObsText(all_fd,'Korea 13',start_avail,end_avail,latitude=35.9078,longitude=127.7669)
cztl.writeObsText(all_fd,'Turkey 14',start_avail,end_avail,latitude=38.9637,longitude=35.2433)
cztl.writeObsText(all_fd,'Barbados 15',start_avail,end_avail,latitude=13.1939,longitude=-59.5432)
cztl.writeObsText(all_fd,'Guam 16',start_avail,end_avail,latitude=13.4443,longitude=144.7937)
cztl.writeObsText(all_fd,'Uzbekistan 17',start_avail,end_avail,latitude=41.3775,longitude=64.5853)
cztl.writeObsText(all_fd,'Ecuador 18',start_avail,end_avail,latitude=-1.8312,longitude=-78.1834)
cztl.writeObsText(all_fd,'Venezuela 19',start_avail,end_avail,latitude=6.4238,longitude=-66.5897)
cztl.writeObsText(all_fd,'Peru 20',start_avail,end_avail,latitude=-9.19,longitude=-75.0152)
cztl.writeObsText(all_fd,'St. Kitts and Nevis 21',start_avail,end_avail,latitude=17.3578,longitude=-62.783)
cztl.writeObsText(all_fd,'Iran 22',start_avail,end_avail,latitude=32.4279,longitude=53.688)
cztl.writeObsText(all_fd,'Indonesia 23',start_avail,end_avail,latitude=-0.7893,longitude=113.9213)
cztl.writeObsText(all_fd,'Honduras 24',start_avail,end_avail,latitude=15.2,longitude=-86.2419)
cztl.writeObsText(all_fd,'Greece 25',start_avail,end_avail,latitude=39.0742,longitude=21.8243)
cztl.writeObsText(all_fd,'Albania 26',start_avail,end_avail,latitude=41.1533,longitude=20.1683)
cztl.writeObsText(all_fd,'Mexico 27',start_avail,end_avail,latitude=23.6345,longitude=-102.5528)
cztl.writeObsText(all_fd,'Hong Kong 28',start_avail,end_avail,latitude=22.3964,longitude=114.1095)
cztl.writeObsText(all_fd,'Tajikistan 29',start_avail,end_avail,latitude=38.861,longitude=71.2761)
cztl.writeObsText(all_fd,'Mozambique 30',start_avail,end_avail,latitude=-18.6657,longitude=35.5296)
cztl.writeObsText(all_fd,'Syria 31',start_avail,end_avail,latitude=34.8021,longitude=38.9968)
cztl.writeObsText(all_fd,'Bolivia 32',start_avail,end_avail,latitude=-16.2902,longitude=-63.5887)
cztl.writeObsText(all_fd,'United States 33',start_avail,end_avail,latitude=37.0902,longitude=-95.7129)

all_fd.write( ']\n');

all_fd.close()