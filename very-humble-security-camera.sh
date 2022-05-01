#!/bin/bash

CAMERA_IP="$1"
BOT_TOKEN="$2"
CHAT_ID="$3"
MY_THRESHOLD="$4"

while true
do
    curl "http://$CAMERA_IP/jpg" -o "a.jpg" --silent
    sleep 1

    curl "http://$CAMERA_IP/jpg" -o "b.jpg" --silent

    RESULT=$(compare -metric RMSE -subimage-search -fuzz 20% a.jpg b.jpg x.jpg 2>&1)
    THRESHOLD=$(echo $RESULT | grep -o -E "[0-9]*\.?" | head -n1 | tr "." " ")

    echo $RESULT
    echo $THRESHOLD

    if [[ $THRESHOLD -gt $MY_THRESHOLD ]]
    then
        # prepare an image with 3 images (left, right and diff) and datetime.
        montage -size 800x600 -label %f -geometry +4+4 -annotate +20+20 "$(date)" a.jpg b.jpg x.jpg total.jpg
        curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendPhoto?chat_id=$CHAT_ID" -F photo=@"total.jpg"
    fi
done
