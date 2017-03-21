import json

fd = open("/Users/ktikennedy/Dropbox (MIT)/Cesium/Cesium-1.27/Apps/AutomatedConstViz/movie_rev3/app_data_files/autoconst_sats.czml", "r")

czml = json.load(fd)

for pkt in czml:
    # print pkt

    if 'label' in pkt.keys():
        # print pkt['label']


        pkt['label']['show'] = False
    # for field in pkt:
        # print field


fd2 = open("/Users/ktikennedy/Dropbox (MIT)/Cesium/Cesium-1.27/Apps/AutomatedConstViz/movie_rev3/app_data_files/autoconst_sats2.czml", "w")

json.dump(czml,fd2,indent=4)