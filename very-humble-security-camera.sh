#!/bin/bash

CAMERA_IP="$1"
BOT_TOKEN="$2"

while true
do
    curl "http://$CAMERA_IP/cam-hi.jpg" -o "a.jpg" --silent
    sleep 1

    curl "http://$CAMERA_IP/cam-hi.jpg" -o "b.jpg" --silent

    RESULT=$(compare -metric RMSE -subimage-search -fuzz 20% a.jpg b.jpg x.jpg 2>&1)
    THRESHOLD=$(echo $RESULT | grep -o -E "[0-9]*\.?" | head -n1 | tr "." " ")

    echo $RESULT
    echo $THRESHOLD

    if [[ $THRESHOLD -gt 3000 ]]
    then
        curl "https://api.telegram.org/$BOT_TOKEN/sendMessage?chat_id=-CHAT_ID_GOES_HERE&text=Motion%20detected!";
        curl -X POST "https://api.telegram.org/$BOT_TOKEN/sendPhoto?chat_id=-CHAT_ID_GOES_HERE" -F photo=@"a.jpg"
        curl -X POST "https://api.telegram.org/$BOT_TOKEN/sendPhoto?chat_id=-CHAT_ID_GOES_HERE" -F photo=@"b.jpg"
        curl -X POST "https://api.telegram.org/$BOT_TOKEN/sendPhoto?chat_id=-CHAT_ID_GOES_HERE" -F photo=@"x.jpg"
    fi
done
