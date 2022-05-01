#!/bin/bash

CAMERA_IP="$1"
BOT_TOKEN="$2"
CHAT_ID="$3"
MY_THRESHOLD="$4"
MY_CELLPHONE="$5"

while true
do
    # Am I at home? If yeap, we don't need to take pictures.
    ping $MY_CELLPHONE -c 1 && sleep 1

    if [[ $? -gt 0 ]]
    then
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
            convert total.jpg -quality 70% total-final.jpg
            curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendPhoto?chat_id=$CHAT_ID" -F photo=@"total-final.jpg"
            rm -rf a.jpg b.jpg x.jpg total.jpg total-final.jpg
        fi
    fi
done
