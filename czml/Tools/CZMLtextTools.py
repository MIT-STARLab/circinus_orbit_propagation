# use the SublimePrettyJson package in to pretty print the output czml correctly (note that the json has to be valid for pretty print to work). Link: https://github.com/dzhibas/SublimePrettyJson/issues


def writeGStext(fd,name,start_avail='2017-03-15T10:00:00Z',end_avail='2017-03-16T10:00:00Z',latitude=0.0,longitude=0.0):

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


def writeObsText(fd,name,start_avail='2017-03-15T10:00:00Z',end_avail='2017-03-16T10:00:00Z',latitude=0.0,longitude=0.0):

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

def writeSatTextHeader(fd,name='CubeSat',start_avail='2017-03-15T10:00:00Z',end_avail='2017-03-16T10:00:00Z',img_file='CubeSat1.png',scale=0.2,label_text='CubeSat'):

    id_string = '\t"id":"Satellite/'+name+'",\n'
    name_string = '"name":"'+name+'",\n'
    availability_string = '"availability":"'+start_avail+'/'+end_avail+'",\n'


    description = 'my very first cubesat'
    description_string = '"description":"<!--HTML-->\\r\\n<p>\\r\\n'+description+'\\r\\n</p>",\n'


    billboard_string = '"billboard":{\n"eyeOffset":{\n"cartesian":[\n0,0,0\n]\n},\n"horizontalOrigin":"CENTER",\n"image":{"uri": "'+img_file+'"},\n"pixelOffset":{\n"cartesian2":[\n0,0\n]\n},\n"scale":'+str(scale)+',\n"show":true,\n"verticalOrigin":"CENTER"\n},\n'


    label_string = '"label":{\n"fillColor":{\n"rgba":[\n0,255,255,255\n]\n},\n"font":"11pt Lucida Console",\n"horizontalOrigin":"LEFT",\n"outlineColor":{\n"rgba":[\n0,0,0,255\n]\n},\n"outlineWidth":2,\n"pixelOffset":{\n"cartesian2":[\n12,0\n]\n},\n"show":true,\n"style":"FILL_AND_OUTLINE",\n"text":"'+name+'",\n"verticalOrigin":"CENTER"\n},'


    path_string = '"path":{\n"show":[\n{\n"interval":"2017-03-15T10:00:00Z/2017-03-16T10:00:00Z",\n"boolean":true\n}\n],\n"width":1,\n"material":{\n"solidColor":{\n"color":{\n"rgba":[\n255,255,0,255\n]\n}\n}\n},\n"resolution":120,\n"leadTime":5400,\n"trailTime":5400\n},'

    pos_string_begin = '"position":{\n"interpolationAlgorithm":"LAGRANGE",\n"interpolationDegree":5,\n"referenceFrame":"INERTIAL",\n"epoch":"2017-03-15T10:00:00Z",\n"cartesian":['


    fd.write( '{\n');
    fd.write( id_string);
    fd.write( name_string);
    fd.write( availability_string);
    fd.write( description_string);
    fd.write( billboard_string);
    fd.write( label_string);
    fd.write( path_string);
    fd.write( pos_string_begin);

    # NOTE! the entry in the czml file for this satellite is not yet complete! Still need to write the position lines to the sat, and then close the entry with:
    #        ]
    #     }
    # },

    # Example position section:
    # 0,-3476951.305000,868565.839000,5987404.264000,
    # 50,-3750666.263000,1039483.230000,5791768.643000,
    # 100,-4013414.877000,1207355.084000,5579193.628000,
    # 150,-4264428.610000,1371690.645000,5350300.947000,
    # 200,-4502973.238000,1532009.514000,5105760.049000,
    # ....
    # 86300,4250684.092000,-1275243.364000,-5384983.373000,
    # 86350,4493825.425000,-1432048.016000,-5142701.463000,
    # 86400,4723826.578000,-1584659.610000,-4885378.511000