import os
from urllib.request import urlopen

import cv2
import cvlib as cv
import numpy as np
import requests
from cvlib.object_detection import draw_bbox

CHAT_ID = os.getenv('CHAT_ID')
BOT_TOKEN = os.getenv('BOT_TOKEN')
CAMERA_IP = os.getenv('CAMERA_IP')
TELEGRAM_URL = "https://api.telegram.org/bot" + \
    BOT_TOKEN + "/sendPhoto?chat_id=" + CHAT_ID

while(True):
    img_resp = urlopen("http://" + CAMERA_IP + "/jpg")
    imgnp = np.asarray(bytearray(img_resp.read()), dtype="uint8")
    img = cv2.imdecode(imgnp, -1)
    bbox, label, conf = cv.detect_common_objects(img)
    print(label)
    im = draw_bbox(img, bbox, label, conf)

    if 'person' in label:
        cv2.imwrite("photo.jpg", im)
        with open("photo.jpg", 'rb') as image:
            ret = requests.post(TELEGRAM_URL, files={"photo": image})

    cv2.imshow("live", im)
    if cv2.waitKey(1) == 113:
        break

cv2.destroyAllWindows()
