#!/bin/bash

#- Count “image” length
#- Print an image name in the image list if the resolution is square

filejson='{
    "widget":{
        "debug": "on",
        "windows": {
            "title": "SKW",
            "name": "main_window",
            "width": 500,
            "height": 500
        }
    },
    "Image":[
        {
            "src": "Images/Sun.png",
            "name": "sun1",
            "hoffset": 250,
            "woffset": 250
        },
        {
            "src": "Images/Sun2.png",
            "name": "sun2",
            "hoffset": 250,
            "woffset": 240
        }

    ]
}'
length_Image=$(echo $filejson | jq ".widget/Image")
echo $length_Image
