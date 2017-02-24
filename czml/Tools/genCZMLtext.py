# use the SublimePrettyJson package in to pretty print the output czml correctly (note that the json has to be valid for pretty print to work). Link: https://github.com/dzhibas/SublimePrettyJson/issues


def writeGStext(fd,name,start_avail,end_avail,latitude,longitude):

    id_string = '\t"id":"Facility/'+name+'",\n'
    name_string = '"name":"'+name+'",\n'
    availability_string = '"availability":"'+start_avail+'/'+end_avail+'",\n'


    description = 'no description'
    description_string = '"description":"<!--HTML-->\\r\\n<p>\\r\\n'+description+'\\r\\n</p>",\n'


    billboard_string = '"billboard":{\n"eyeOffset":{\n"cartesian":[\n0,0,0\n]\n},\n"horizontalOrigin":"CENTER",\n"image":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACvSURBVDhPrZDRDcMgDAU9GqN0lIzijw6SUbJJygUeNQgSqepJTyHG91LVVpwDdfxM3T9TSl1EXZvDwii471fivK73cBFFQNTT/d2KoGpfGOpSIkhUpgUMxq9DFEsWv4IXhlyCnhBFnZcFEEuYqbiUlNwWgMTdrZ3JbQFoEVG53rd8ztG9aPJMnBUQf/VFraBJeWnLS0RfjbKyLJA8FkT5seDYS1Qwyv8t0B/5C2ZmH2/eTGNNBgMmAAAAAElFTkSuQmCC",\n"pixelOffset":{\n"cartesian2":[\n0,0\n]\n},\n"scale":2.0,\n"show":true,\n"verticalOrigin":"CENTER"\n},\n'


    label_string = '"label":{\n"fillColor":{\n"rgba":[\n0,255,255,255\n]\n},\n"font":"11pt Lucida Console",\n"horizontalOrigin":"LEFT",\n"outlineColor":{\n"rgba":[\n0,0,0,255\n]\n},\n"outlineWidth":2,\n"pixelOffset":{\n"cartesian2":[\n12,0\n]\n},\n"show":true,\n"style":"FILL_AND_OUTLINE",\n"text":"'+name+'",\n"verticalOrigin":"CENTER"\n},'


    pos_string = '"position":{\n"cartographicDegrees": [ '+str(longitude)+', '+str(latitude)+', 0 ]\n}\n'


    fd.write( '{\n');
    fd.write( id_string);
    fd.write( name_string);
    fd.write( availability_string);
    fd.write( description_string);
    fd.write( billboard_string);
    fd.write( label_string);
    fd.write( pos_string);
    fd.write( '},\n');


def writeObsText(fd,name,start_avail,end_avail,latitude,longitude):

    target_pic = 'target.jpg'

    id_string = '\t"id":"Target/'+name+'",\n'
    name_string = '"name":"'+name+'",\n'
    availability_string = '"availability":"'+start_avail+'/'+end_avail+'",\n'


    description = 'no description'
    description_string = '"description":"<!--HTML-->\\r\\n<p>\\r\\n'+description+'\\r\\n</p>",\n'


    billboard_string = '"billboard":{\n"eyeOffset":{\n"cartesian":[\n0,0,0\n]\n},\n"horizontalOrigin":"CENTER",\n"image": {\n"uri": "'+target_pic+'"\n},\n"pixelOffset":{\n"cartesian2":[\n0,0\n]\n},\n"scale":0.1,\n"show":true,\n"verticalOrigin":"CENTER"\n},\n'


    label_string = '"label":{\n"fillColor":{\n"rgba":[\n0,255,255,255\n]\n},\n"font":"11pt Lucida Console",\n"horizontalOrigin":"LEFT",\n"outlineColor":{\n"rgba":[\n0,0,0,255\n]\n},\n"outlineWidth":2,\n"pixelOffset":{\n"cartesian2":[\n12,0\n]\n},\n"show":true,\n"style":"FILL_AND_OUTLINE",\n"text":"'+name+'",\n"verticalOrigin":"CENTER"\n},'


    pos_string = '"position":{\n"cartographicDegrees": [ '+str(longitude)+', '+str(latitude)+', 0 ]\n}\n'


    fd.write( '{\n');
    fd.write( id_string);
    fd.write( name_string);
    fd.write( availability_string);
    fd.write( description_string);
    fd.write( billboard_string);
    fd.write( label_string);
    fd.write( pos_string);
    fd.write( '},\n');



all_fd = open("out.txt", "w")

all_fd.write( '[\n');

# GS and targets based on parameters_descope_2 from MDO work

writeGStext(all_fd,'Haleakala','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=20.72,longitude=-156.26)
writeGStext(all_fd,'Table Mountain','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=37.19,longitude=-118.58)
writeGStext(all_fd,'Teide','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=28.27,longitude=-16.64)
writeGStext(all_fd,'Hartebeesthoek','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-25.64,longitude=28.08)

writeObsText(all_fd,'Taiwan','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=23.6978,longitude=120.9605)
writeObsText(all_fd,'Dominican Rep.','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=18.7357,longitude=-70.1627)
writeObsText(all_fd,'Jamaica','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=18.1096,longitude=-77.2975)
writeObsText(all_fd,'El Salvador','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=13.7942,longitude=-88.8965)
writeObsText(all_fd,'Guatemala','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=14.6349,longitude=-90.5069)
writeObsText(all_fd,'Antigua and Barbuda','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=17.0608,longitude=-61.7964)
writeObsText(all_fd,'Japan','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=36.2048,longitude=138.2529)
writeObsText(all_fd,'Costa Rica','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=9.7489,longitude=-83.7534)
writeObsText(all_fd,'Philippines','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=12.8797,longitude=121.774)
writeObsText(all_fd,'Colombia','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=4.5709,longitude=-74.2973)
writeObsText(all_fd,'Bangladesh','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=23.685,longitude=90.3563)
writeObsText(all_fd,'Chile','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-35.6751,longitude=-71.543)
writeObsText(all_fd,'Korea','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=35.9078,longitude=127.7669)
writeObsText(all_fd,'Turkey','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=38.9637,longitude=35.2433)
writeObsText(all_fd,'Barbados','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=13.1939,longitude=-59.5432)
writeObsText(all_fd,'Guam','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=13.4443,longitude=144.7937)
writeObsText(all_fd,'Uzbekistan','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=41.3775,longitude=64.5853)
writeObsText(all_fd,'Ecuador','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-1.8312,longitude=-78.1834)
writeObsText(all_fd,'Venezuela','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=6.4238,longitude=-66.5897)
writeObsText(all_fd,'Peru','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-9.19,longitude=-75.0152)
writeObsText(all_fd,'St. Kitts and Nevis','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=17.3578,longitude=-62.783)
writeObsText(all_fd,'Iran','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=32.4279,longitude=53.688)
writeObsText(all_fd,'Indonesia','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-0.7893,longitude=113.9213)
writeObsText(all_fd,'Honduras','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=15.2,longitude=-86.2419)
writeObsText(all_fd,'Greece','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=39.0742,longitude=21.8243)
writeObsText(all_fd,'Albania','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=41.1533,longitude=20.1683)
writeObsText(all_fd,'Mexico','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=23.6345,longitude=-102.5528)
writeObsText(all_fd,'Hong Kong','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=22.3964,longitude=114.1095)
writeObsText(all_fd,'Tajikistan','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=38.861,longitude=71.2761)
writeObsText(all_fd,'Mozambique','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-18.6657,longitude=35.5296)
writeObsText(all_fd,'Syria','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=34.8021,longitude=38.9968)
writeObsText(all_fd,'Bolivia','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=-16.2902,longitude=-63.5887)
writeObsText(all_fd,'United States','2017-03-15T10:00:00Z','2017-03-16T10:00:00Z',latitude=37.0902,longitude=-95.7129)

all_fd.write( ']\n');

all_fd.close()