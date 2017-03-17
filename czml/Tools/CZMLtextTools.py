# use the SublimePrettyJson package in to pretty print the output czml correctly (note that the json has to be valid for pretty print to work). Link: https://github.com/dzhibas/SublimePrettyJson/issues

import datetime


def writeGStext(fd,name,start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0),end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0),latitude=0.0,longitude=0.0):

    id_string = '\t"id":"Facility/'+name+'",\n'
    name_string = '"name":"'+name+'",\n'
    availability_string = '"availability":"'+start_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'/'+end_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'",\n'


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

def writeObsText(fd,name,start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0),end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0),latitude=0.0,longitude=0.0,include_billboard = True):

    target_pic = 'target.jpg'

    id_string = '\t"id":"Target/'+name+'",\n'
    name_string = '"name":"'+name+'",\n'
    availability_string = '"availability":"'+start_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'/'+end_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'",\n'


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
    if include_billboard:
        fd.write( billboard_string);
    fd.write( label_string);
    fd.write( pos_string);
    fd.write( '},\n');

def writeObsTextRect(fd,name,start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0),end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0),color_str='0,0,255,255',lower_lat=0.0,upper_lat=10.0,left_long=5.0,right_long=10.0):


    id_string = '\t"id":"Rectangle/'+name+'",\n'
    name_string = '"name":"'+name+'",\n'
    availability_string = '"availability":"'+start_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'/'+end_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'",\n'


    description = 'no description'
    description_string = '"description":"<!--HTML-->\\r\\n<p>\\r\\n'+description+'\\r\\n</p>",\n'


    rec_string_1 = '"rectangle": {\n"show": true,\n"height": 0,\n"coordinates": {\n"wsenDegrees": ['+str(left_long)+','+str(lower_lat)+','+str(right_long)+','+str(upper_lat)+']\n},'

    rec_string_2 = '"fill": true,\n"material": {\n"solidColor": {\n"color": {\n"rgba": ['+color_str+']\n}\n}\n}\n}'

    fd.write( '{\n');
    fd.write( id_string);
    fd.write( name_string);
    fd.write( availability_string);
    fd.write( description_string);
    fd.write( rec_string_1);
    fd.write( rec_string_2);
    fd.write( '},\n');

def writeSatTextHeader(fd,name='CubeSat',start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0),end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0),img_file='CubeSat1.png',scale=0.2,label_text='CubeSat'):

    id_string = '\t"id":"Satellite/'+name+'",\n'
    name_string = '"name":"'+name+'",\n'
    availability_string = '"availability":"'+start_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'/'+end_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'",\n'


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

def writeLinkPacket(fd,ID='Xlnk/SatN-to-SatM',name='a link',start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0),end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0), polyline_show_times = [[datetime.datetime(2017, 3, 15, 12, 0, 0),datetime.datetime(2017, 3, 16, 1, 0, 0)],[datetime.datetime(2017, 3, 16, 5, 0, 0),datetime.datetime(2017, 3, 16, 9, 0, 0)]], color_str='0,0,255,255',reference1='Satellite/CubeSatN#position',reference2='Satellite/CubeSatM#position'):

    id_string = '\t"id":"'+ID+'",\n'
    name_string = '"name":"'+name+'",\n'

    availability_string = '"availability":"'+start_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'/'+end_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'",\n'


    polyline_intervals = []
    polyline_intervals_show = []

    if len(polyline_show_times) > 0:
        last_time = start_avail

        for i, times  in enumerate(polyline_show_times):
            polyline_intervals.append([last_time,times[0]])
            polyline_intervals_show.append(False)

            polyline_intervals.append([times[0],times[1]])
            polyline_intervals_show.append(True)

            if times[1] < times[0]:
                print 'error 1'
            if times[0] < last_time:
                print 'error 2'

            last_time = times[1]

        polyline_intervals.append([last_time,end_avail])
        polyline_intervals_show.append(False)

        if end_avail < last_time:
            print 'error 3'

    polyline_string_1 = '"polyline":{\n"show":'
    polyline_string_2 = ''
    polyline_body_strings = []

    if not polyline_intervals:
        polyline_string_1 += 'false,\n'
    else:
        polyline_string_1 += '[\n'

        for i, intervals  in enumerate(polyline_intervals):

            string = ''
            if not i == 0: string+=','

            string+= '{\n'
            string+= '"interval":"'+intervals[0].strftime('%Y-%m-%dT%H:%M:%SZ')+'/'+intervals[1].strftime('%Y-%m-%dT%H:%M:%SZ')+'",\n'
            string+='"boolean":'+str(polyline_intervals_show[i]).lower()+'\n'
            string+= '}\n'

            polyline_body_strings.append(string)

        polyline_string_2 += '],\n'

    polyline_string_2 += '"width":6,\n'
    polyline_string_3 = '"material":{\n"solidColor":{\n"color":{\n"rgba":[\n'+color_str+'\n]\n}\n}\n},\n'

    polyline_string_4 = '"followSurface":false,\n"positions":{\n"references":[\n"'+reference1+'","'+reference2+'"\n]\n}\n}\n'


    fd.write( '{\n')
    fd.write( id_string)
    fd.write( name_string)
    fd.write( availability_string)
    fd.write( polyline_string_1)

    for string in polyline_body_strings:
        fd.write( string)

    fd.write( polyline_string_2)
    fd.write( polyline_string_3)
    fd.write( polyline_string_4)
    fd.write( '},\n')

def writeObsPacket(fd,ID='Obs/SatN',name='observation cone for satellite',start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0),end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0), cylinder_show_times = [[datetime.datetime(2017, 3, 15, 12, 0, 0),datetime.datetime(2017, 3, 16, 1, 0, 0)],[datetime.datetime(2017, 3, 16, 5, 0, 0),datetime.datetime(2017, 3, 16, 9, 0, 0)]], color_str='255,0,0,150',position_ref='Satellite/CubeSatN#position'):

    id_string = '\t"id":"'+ID+'",\n'
    name_string = '"name":"'+name+'",\n'

    availability_string = '"availability":"'+start_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'/'+end_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'",\n'


    cylinder_intervals = []
    cylinder_intervals_show = []

    if len(cylinder_show_times) > 0:
        last_time = start_avail

        for i, times  in enumerate(cylinder_show_times):
            cylinder_intervals.append([last_time,times[0]])
            cylinder_intervals_show.append(False)

            cylinder_intervals.append([times[0],times[1]])
            cylinder_intervals_show.append(True)

            if times[1] < times[0]:
                print 'error 4'
            if times[0] < last_time:
                print 'error 5'

            last_time = times[1]

        cylinder_intervals.append([last_time,end_avail])
        cylinder_intervals_show.append(False)

        if end_avail < last_time:
            print 'error 6'

    cylinder_string_1 = '"cylinder" : {\n"length" : 530000.0,\n"topRadius" : 0.0,\n"bottomRadius" : 400000.0,\n'
    cylinder_string_2 = '"material":{\n"solidColor":{\n"color":{\n"rgba":[\n'+color_str+'\n]\n}\n}\n},\n'
    cylinder_string_3 = '"fill" : true,\n'

    cylinder_string_4 = '"show":'
    cylinder_string_5 = ''
    cylinder_body_strings = []

    if not cylinder_intervals:
        cylinder_string_4 += 'false,\n'
    else:
        cylinder_string_4 += '[\n'

        for i, intervals  in enumerate(cylinder_intervals):

            string = ''
            if not i == 0: string+=','

            string+= '{\n'
            string+= '"interval":"'+intervals[0].strftime('%Y-%m-%dT%H:%M:%SZ')+'/'+intervals[1].strftime('%Y-%m-%dT%H:%M:%SZ')+'",\n'
            string+='"boolean":'+str(cylinder_intervals_show[i]).lower()+'\n'
            string+= '}\n'

            cylinder_body_strings.append(string)

        cylinder_string_5 += ']\n},\n'


    cylinder_string_5 += '"position":{\n"reference":"'+position_ref+'"\n}'


    fd.write( '{\n')
    fd.write( id_string)
    fd.write( name_string)
    fd.write( availability_string)
    fd.write( cylinder_string_1)
    fd.write( cylinder_string_2)
    fd.write( cylinder_string_3)
    fd.write( cylinder_string_4)

    for string in cylinder_body_strings:
        fd.write( string)

    fd.write( cylinder_string_5)
    fd.write( '},\n')