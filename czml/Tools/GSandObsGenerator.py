# use the SublimePrettyJson package in to pretty print the output czml correctly (note that the json has to be valid for pretty print to work). Link: https://github.com/dzhibas/SublimePrettyJson/issues

import CZMLtextTools as cztl


all_fd = open("out.txt", "w")

all_fd.write( '[\n');

# GS and targets based on parameters_descope_2 from MDO work

start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0)
end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0)

# writeGStext(all_fd,'Haleakala 1','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=20.72,longitude=-156.26)
# writeGStext(all_fd,'Table Mountain 2','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=37.19,longitude=-118.58)
# writeGStext(all_fd,'Teide 3','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=28.27,longitude=-16.64)
# writeGStext(all_fd,'Hartebeesthoek 4','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-25.64,longitude=28.08)

cztl.writeGStext(all_fd,'Haleakala 1',start_avail,end_avail,latitude=20.72,longitude=-156.26)
cztl.writeGStext(all_fd,'Piura 2',start_avail,end_avail,latitude=-5.193,longitude=-80.702)
cztl.writeGStext(all_fd,'Dadaab 3',start_avail,end_avail,latitude=0.0998,longitude=40.263)
cztl.writeGStext(all_fd,'Darwin 4',start_avail,end_avail,latitude=-12.426,longitude=130.863)

# cztl.writeObsText(all_fd,'Taiwan 1',start_avail,end_avail,latitude=23.6978,longitude=120.9605)
# cztl.writeObsText(all_fd,'Dominican Rep. 2',start_avail,end_avail,latitude=18.7357,longitude=-70.1627)
# cztl.writeObsText(all_fd,'Jamaica 3',start_avail,end_avail,latitude=18.1096,longitude=-77.2975)
# cztl.writeObsText(all_fd,'El Salvador 4',start_avail,end_avail,latitude=13.7942,longitude=-88.8965)
# cztl.writeObsText(all_fd,'Guatemala 5',start_avail,end_avail,latitude=14.6349,longitude=-90.5069)
# cztl.writeObsText(all_fd,'Antigua and Barbuda 6',start_avail,end_avail,latitude=17.0608,longitude=-61.7964)
# cztl.writeObsText(all_fd,'Japan 7',start_avail,end_avail,latitude=36.2048,longitude=138.2529)
# cztl.writeObsText(all_fd,'Costa Rica 8',start_avail,end_avail,latitude=9.7489,longitude=-83.7534)
# cztl.writeObsText(all_fd,'Philippines 9',start_avail,end_avail,latitude=12.8797,longitude=121.774)
# cztl.writeObsText(all_fd,'Colombia 10',start_avail,end_avail,latitude=4.5709,longitude=-74.2973)
# cztl.writeObsText(all_fd,'Bangladesh 11',start_avail,end_avail,latitude=23.685,longitude=90.3563)
# cztl.writeObsText(all_fd,'Chile 12',start_avail,end_avail,latitude=-35.6751,longitude=-71.543)
# cztl.writeObsText(all_fd,'Korea 13',start_avail,end_avail,latitude=35.9078,longitude=127.7669)
# cztl.writeObsText(all_fd,'Turkey 14',start_avail,end_avail,latitude=38.9637,longitude=35.2433)
# cztl.writeObsText(all_fd,'Barbados 15',start_avail,end_avail,latitude=13.1939,longitude=-59.5432)
# cztl.writeObsText(all_fd,'Guam 16',start_avail,end_avail,latitude=13.4443,longitude=144.7937)
# cztl.writeObsText(all_fd,'Uzbekistan 17',start_avail,end_avail,latitude=41.3775,longitude=64.5853)
# cztl.writeObsText(all_fd,'Ecuador 18',start_avail,end_avail,latitude=-1.8312,longitude=-78.1834)
# cztl.writeObsText(all_fd,'Venezuela 19',start_avail,end_avail,latitude=6.4238,longitude=-66.5897)
# cztl.writeObsText(all_fd,'Peru 20',start_avail,end_avail,latitude=-9.19,longitude=-75.0152)
# cztl.writeObsText(all_fd,'St. Kitts and Nevis 21',start_avail,end_avail,latitude=17.3578,longitude=-62.783)
# cztl.writeObsText(all_fd,'Iran 22',start_avail,end_avail,latitude=32.4279,longitude=53.688)
# cztl.writeObsText(all_fd,'Indonesia 23',start_avail,end_avail,latitude=-0.7893,longitude=113.9213)
# cztl.writeObsText(all_fd,'Honduras 24',start_avail,end_avail,latitude=15.2,longitude=-86.2419)
# cztl.writeObsText(all_fd,'Greece 25',start_avail,end_avail,latitude=39.0742,longitude=21.8243)
# cztl.writeObsText(all_fd,'Albania 26',start_avail,end_avail,latitude=41.1533,longitude=20.1683)
# cztl.writeObsText(all_fd,'Mexico 27',start_avail,end_avail,latitude=23.6345,longitude=-102.5528)
# cztl.writeObsText(all_fd,'Hong Kong 28',start_avail,end_avail,latitude=22.3964,longitude=114.1095)
# cztl.writeObsText(all_fd,'Tajikistan 29',start_avail,end_avail,latitude=38.861,longitude=71.2761)
# cztl.writeObsText(all_fd,'Mozambique 30',start_avail,end_avail,latitude=-18.6657,longitude=35.5296)
# cztl.writeObsText(all_fd,'Syria 31',start_avail,end_avail,latitude=34.8021,longitude=38.9968)
# cztl.writeObsText(all_fd,'Bolivia 32',start_avail,end_avail,latitude=-16.2902,longitude=-63.5887)
# cztl.writeObsText(all_fd,'United States 33',start_avail,end_avail,latitude=37.0902,longitude=-95.7129)

all_fd.write( ']\n');

all_fd.close()