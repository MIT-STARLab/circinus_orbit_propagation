# use the SublimePrettyJson package in to pretty print the output czml correctly (note that the json has to be valid for pretty print to work). Link: https://github.com/dzhibas/SublimePrettyJson/issues

import datetime
import collections

def getBooleanShowIntervals(show_times, start_avail, end_avail):

    # Figure out intervals for showing and not showing
    intervals = []
    intervals_show = []

    if len(show_times) > 0:
        last_time = start_avail

        for i, times  in enumerate(show_times):

            # check case where window is before start_avail
            if times[0] < last_time and times[1] < last_time:
                continue
            elif times[0] < last_time:
                start_time = last_time
            else:
                start_time = times[0]

            # check case where window is after end_avail
            if times[0] > end_avail and times[1] > end_avail:
                continue
            elif times[1] > end_avail:
                end_time = end_avail
            else:
                end_time = times[1]

            # add a "not show" up to the current window
            if not last_time == start_time:
                intervals.append([last_time,start_time])
                intervals_show.append(False)

            # add a "show" for the current window
            if not start_time == end_time:
                intervals.append([start_time,end_time])
                intervals_show.append(True)

            if end_time < start_time:
                print 'error 1'
            if start_time < last_time:
                print start_time
                print last_time
                print 'error 2'

            last_time = end_time

        # add very last "not show"
        intervals.append([last_time,end_avail])
        intervals_show.append(False)

        if end_avail < last_time:
            print 'error 3'

    # Store intervals in jsonic object
    show_intervals = []

    if intervals:
        for i, intervals in enumerate(intervals):

            interval = intervals[0].strftime('%Y-%m-%dT%H:%M:%SZ')+'/'+intervals[1].strftime('%Y-%m-%dT%H:%M:%SZ')

            show_intervals.append({'interval':interval,'boolean':intervals_show[i]})

    return show_intervals

def createGS(name,start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0),end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0),latitude=0.0,longitude=0.0):

    gs = collections.OrderedDict()

    name_without_num = ' '.join(name.split(' ')[:-1])

    gs['id'] = 'Facility/'+name
    gs['name'] = name
    gs['availability'] = start_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'/'+end_avail.strftime('%Y-%m-%dT%H:%M:%SZ')

    description = 'no description'
    gs['description'] = '<!--HTML--><p>'+description+'</p>'


    eyeOffset = {'cartesian':[0,0,0]}
    pixelOffset = {'cartesian2':[0,0]}
    img_str = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACvSURBVDhPrZDRDcMgDAU9GqN0lIzijw6SUbJJygUeNQgSqepJTyHG91LVVpwDdfxM3T9TSl1EXZvDwii471fivK73cBFFQNTT/d2KoGpfGOpSIkhUpgUMxq9DFEsWv4IXhlyCnhBFnZcFEEuYqbiUlNwWgMTdrZ3JbQFoEVG53rd8ztG9aPJMnBUQf/VFraBJeWnLS0RfjbKyLJA8FkT5seDYS1Qwyv8t0B/5C2ZmH2/eTGNNBgMmAAAAAElFTkSuQmCC'
    billboard = {'eyeOffset':eyeOffset, \
        'image':img_str,                \
        'pixelOffset':pixelOffset,      \
        'scale':2.0,                    \
        'show':True,                    \
        'verticalOrigin':'CENTER',      \
        'horizontalOrigin':'CENTER'}
    gs['billboard'] = billboard


    fillColor = {'rgba':[0, 255, 255, 255]}
    outlineColor = {'rgba':[0, 0, 0, 255]}
    pixelOffset = {'cartesian2':[12,0]}
    label = {'fillColor':fillColor,     \
        'font':'10pt Lucida Console',   \
        'outlineColor':outlineColor,    \
        'outlineWidth':2,               \
        'pixelOffset':pixelOffset,      \
        'show':True,                    \
        'style':'FILL_AND_OUTLINE',     \
        'text':name_without_num,        \
        'verticalOrigin':'CENTER',      \
        'horizontalOrigin':'LEFT'}
    gs['label'] = label

    gs['position'] = {'cartographicDegrees':[longitude,latitude,0]}

    return gs

def createObsTarget(name,start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0),end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0),latitude=0.0,longitude=0.0,include_billboard = True, target_pic = 'target.jpg'):

    obs_targ = collections.OrderedDict()

    name_without_num = ' '.join(name.split(' ')[:-1])

    obs_targ['id'] = 'Target/'+name
    obs_targ['name'] = name
    obs_targ['availability'] = start_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'/'+end_avail.strftime('%Y-%m-%dT%H:%M:%SZ')

    description = 'no description'
    obs_targ['description'] = '<!--HTML--><p>'+description+'</p>'

    if include_billboard:
        eyeOffset = {'cartesian':[0,0,0]}
        pixelOffset = {'cartesian2':[0,0]}
        image = {'uri':target_pic}
        billboard = {'eyeOffset':eyeOffset, \
            'image':image,                  \
            'pixelOffset':pixelOffset,      \
            'scale':0.1,                    \
            'show':True,                    \
            'verticalOrigin':'CENTER',      \
            'horizontalOrigin':'CENTER'}
        obs_targ['billboard'] = billboard

    fillColor = {'rgba':[0, 255, 255, 255]}
    outlineColor = {'rgba':[0, 0, 0, 255]}
    pixelOffset = {'cartesian2':[12,0]}
    label = {'fillColor':fillColor,     \
        'font':'10pt Lucida Console',   \
        'outlineColor':outlineColor,    \
        'outlineWidth':2,               \
        'pixelOffset':pixelOffset,      \
        'show':True,                    \
        'style':'FILL_AND_OUTLINE',     \
        'text':name_without_num,        \
        'verticalOrigin':'CENTER',      \
        'horizontalOrigin':'LEFT'}
    obs_targ['label'] = label

    obs_targ['position'] = {'cartographicDegrees':[longitude,latitude,0]}

    return obs_targ

def createObsRectangle(name,start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0),end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0),color=[0,0,255,255],lower_lat=0.0,upper_lat=10.0,left_long=5.0,right_long=10.0):

    obs_rect = collections.OrderedDict()

    name_without_num = ' '.join(name.split(' ')[:-1])

    obs_rect['id'] = 'Rectangle/'+name
    obs_rect['name'] = name
    obs_rect['availability'] = start_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'/'+end_avail.strftime('%Y-%m-%dT%H:%M:%SZ')

    description = 'no description'
    obs_rect['description'] = '<!--HTML--><p>'+description+'</p>'


    rec_string_1 = '"rectangle": {\n"show": true,\n"height": 0,\n"coordinates": {\n"wsenDegrees": ['+str(left_long)+','+str(lower_lat)+','+str(right_long)+','+str(upper_lat)+']\n},'

    coordinates = {'wsenDegrees':[left_long,lower_lat,right_long,upper_lat]}
    material = {'solidColor':{'color':{'rgba':color}}}
    rectangle = {'show':True,       \
        'height':0,                 \
        'coordinates':coordinates,  \
        'fill':True,                \
        'material':material}
    obs_rect['rectangle'] = rectangle

    return obs_rect

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

def createLinkPacket(ID='Xlnk/SatN-to-SatM',name='a link',start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0),end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0), polyline_show_times = [[datetime.datetime(2017, 3, 15, 12, 0, 0),datetime.datetime(2017, 3, 16, 1, 0, 0)],[datetime.datetime(2017, 3, 16, 5, 0, 0),datetime.datetime(2017, 3, 16, 9, 0, 0)]], color=[0,0,255,255],reference1='Satellite/CubeSatN#position',reference2='Satellite/CubeSatM#position'):

    link = collections.OrderedDict()

    link['id'] = ID
    link['name'] = name
    link['availability'] = start_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'/'+end_avail.strftime('%Y-%m-%dT%H:%M:%SZ')

    # Figure out intervals for showing and not showing
    show_intervals = getBooleanShowIntervals(polyline_show_times, start_avail, end_avail)
    show_intervals = show_intervals if show_intervals else False

    material = {'solidColor':{'color':{'rgba':color}}}
    positions = {'references':[reference1,reference2]}
    polyline = {'width':6,          \
        'followSurface':False,      \
        'positions':positions,      \
        'show': show_intervals,      \
        'material':material}
    link['polyline'] = polyline

    return link

def createObsPacket(ID='Obs/SatN',name='observation cone for satellite',start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0),end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0), cylinder_show_times = [[datetime.datetime(2017, 3, 15, 12, 0, 0),datetime.datetime(2017, 3, 16, 1, 0, 0)],[datetime.datetime(2017, 3, 16, 5, 0, 0),datetime.datetime(2017, 3, 16, 9, 0, 0)]], color=[255,0,0,150],position_ref='Satellite/CubeSatN#position'):

    obs_cyl = collections.OrderedDict()

    obs_cyl['id'] = ID
    obs_cyl['name'] = name
    obs_cyl['availability'] = start_avail.strftime('%Y-%m-%dT%H:%M:%SZ')+'/'+end_avail.strftime('%Y-%m-%dT%H:%M:%SZ')

    # Figure out intervals for showing and not showing
    show_intervals = getBooleanShowIntervals(cylinder_show_times, start_avail, end_avail)
    show_intervals = show_intervals if show_intervals else False

    material = {'solidColor':{'color':{'rgba':color}}}
    cylinder = {'length':530000.0,      \
        'topRadius':0.0,                \
        'bottomRadius':400000.0,        \
        'fill':True,                    \
        'show': show_intervals,          \
        'material':material}
    obs_cyl['cylinder'] = cylinder

    obs_cyl['position'] = {'reference':position_ref}

    return obs_cyl

def createDataStorageHistory(ID='Obs/SatN',name='q_o_sizes_history for satellite', epoch = datetime.datetime(2017, 3, 15, 10, 0, 0) , data_history = [[0,0],[86400,0]],filter_seconds_beg=0,filter_seconds_end=86400):

    datavol = collections.OrderedDict()
    datavol['id'] = ID
    datavol['name'] = name

    interleaved_time_datavol_list = []
    for i, sample in enumerate(data_history):
        if sample[0] < filter_seconds_beg or sample[1] > filter_seconds_end:
            continue

        interleaved_time_datavol_list.append(sample[0])
        interleaved_time_datavol_list.append(sample[1])

    datavol_stuff = {'interpolationAlgorithm':'LINEAR',   \
        'interpolationDegree':1,                        \
        'epoch':epoch.strftime('%Y-%m-%dT%H:%M:%SZ'),   \
        'number':interleaved_time_datavol_list}
    datavol['datavol'] = datavol_stuff

    return datavol

def createGSavailabilityPacket(ID='Facility/GS Name',name='gs avail windows gs num N', start_avail=datetime.datetime(2017, 3, 15, 10, 0, 0), end_avail=datetime.datetime(2017, 3, 16, 10, 0, 0), availability_times = [[datetime.datetime(2017, 3, 15, 12, 0, 0),datetime.datetime(2017, 3, 16, 1, 0, 0)],[datetime.datetime(2017, 3, 16, 5, 0, 0),datetime.datetime(2017, 3, 16, 9, 0, 0)]]):

    gs_avail = collections.OrderedDict()

    gs_avail['id'] = ID
    gs_avail['name'] = name

    # Figure out intervals for showing and not showing
    show_intervals = getBooleanShowIntervals(availability_times, start_avail, end_avail)
    show_intervals = show_intervals if show_intervals else False

    gs_avail['gs_availability'] = show_intervals

    return gs_avail