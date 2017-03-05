# use the SublimePrettyJson package in to pretty print the output czml correctly (note that the json has to be valid for pretty print to work). Link: https://github.com/dzhibas/SublimePrettyJson/issues

import CZMLtextTools as cztl


all_fd = open("out.txt", "w")

all_fd.write( '[\n');

# GS and targets based on parameters_descope_2 from MDO work

# writeGStext(all_fd,'Haleakala 1','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=20.72,longitude=-156.26)
# writeGStext(all_fd,'Table Mountain 2','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=37.19,longitude=-118.58)
# writeGStext(all_fd,'Teide 3','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=28.27,longitude=-16.64)
# writeGStext(all_fd,'Hartebeesthoek 4','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-25.64,longitude=28.08)

cztl.writeGStext(all_fd,'Haleakala 1','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=20.72,longitude=-156.26)
cztl.writeGStext(all_fd,'Piura 2','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-5.193,longitude=-80.702)
cztl.writeGStext(all_fd,'Dadaab 3','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=0.0998,longitude=40.263)
cztl.writeGStext(all_fd,'Darwin 4','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-12.426,longitude=130.863)

# writeObsText(all_fd,'Taiwan 1','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=23.6978,longitude=120.9605)
# writeObsText(all_fd,'Dominican Rep. 2','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=18.7357,longitude=-70.1627)
# writeObsText(all_fd,'Jamaica 3','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=18.1096,longitude=-77.2975)
# writeObsText(all_fd,'El Salvador 4','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=13.7942,longitude=-88.8965)
# writeObsText(all_fd,'Guatemala 5','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=14.6349,longitude=-90.5069)
# writeObsText(all_fd,'Antigua and Barbuda 6','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=17.0608,longitude=-61.7964)
# writeObsText(all_fd,'Japan 7','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=36.2048,longitude=138.2529)
# writeObsText(all_fd,'Costa Rica 8','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=9.7489,longitude=-83.7534)
# writeObsText(all_fd,'Philippines 9','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=12.8797,longitude=121.774)
# writeObsText(all_fd,'Colombia 10','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=4.5709,longitude=-74.2973)
# writeObsText(all_fd,'Bangladesh 11','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=23.685,longitude=90.3563)
# writeObsText(all_fd,'Chile 12','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-35.6751,longitude=-71.543)
# writeObsText(all_fd,'Korea 13','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=35.9078,longitude=127.7669)
# writeObsText(all_fd,'Turkey 14','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=38.9637,longitude=35.2433)
# writeObsText(all_fd,'Barbados 15','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=13.1939,longitude=-59.5432)
# writeObsText(all_fd,'Guam 16','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=13.4443,longitude=144.7937)
# writeObsText(all_fd,'Uzbekistan 17','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=41.3775,longitude=64.5853)
# writeObsText(all_fd,'Ecuador 18','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-1.8312,longitude=-78.1834)
# writeObsText(all_fd,'Venezuela 19','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=6.4238,longitude=-66.5897)
# writeObsText(all_fd,'Peru 20','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-9.19,longitude=-75.0152)
# writeObsText(all_fd,'St. Kitts and Nevis 21','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=17.3578,longitude=-62.783)
# writeObsText(all_fd,'Iran 22','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=32.4279,longitude=53.688)
# writeObsText(all_fd,'Indonesia 23','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-0.7893,longitude=113.9213)
# writeObsText(all_fd,'Honduras 24','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=15.2,longitude=-86.2419)
# writeObsText(all_fd,'Greece 25','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=39.0742,longitude=21.8243)
# writeObsText(all_fd,'Albania 26','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=41.1533,longitude=20.1683)
# writeObsText(all_fd,'Mexico 27','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=23.6345,longitude=-102.5528)
# writeObsText(all_fd,'Hong Kong 28','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=22.3964,longitude=114.1095)
# writeObsText(all_fd,'Tajikistan 29','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=38.861,longitude=71.2761)
# writeObsText(all_fd,'Mozambique 30','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-18.6657,longitude=35.5296)
# writeObsText(all_fd,'Syria 31','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=34.8021,longitude=38.9968)
# writeObsText(all_fd,'Bolivia 32','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-16.2902,longitude=-63.5887)
# writeObsText(all_fd,'United States 33','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=37.0902,longitude=-95.7129)

all_fd.write( ']\n');

all_fd.close()