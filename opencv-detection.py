import cv2
import numpy as np

# initialize the HOG descriptor/person detector
hog = cv2.HOGDescriptor()
hog.setSVMDetector(cv2.HOGDescriptor_getDefaultPeopleDetector())

from datetime import datetime
video = cv2.VideoCapture('http://XXXXX:5000/video_feed')
cv2.namedWindow('Camera', cv2.WINDOW_AUTOSIZE)

while(video.isOpened()):
    ret, img = video.read()

    if ret == True:

        # begin people detection
        frame = cv2.resize(img, (640, 480))
        gray = cv2.cvtColor(frame, cv2.COLOR_RGB2GRAY)
        boxes, weights = hog.detectMultiScale(frame, winStride=(8,8), padding=(10, 10), scale=1.02)
        boxes = np.array([[x, y, x + w, y + h] for (x, y, w, h) in boxes])

        # display the detected boxes in the colour picture
        for (xA, yA, xB, yB) in boxes:
            cv2.rectangle(frame, (xA, yA), (xB, yB), (0, 255, 0), 2)
        cv2.imshow('Camera', frame)
        # end people detection

        # begin normal flow
        #font = cv2.FONT_HERSHEY_PLAIN
        #cv2.putText(img, str(datetime.now()), (20, 40), font, 2, (255, 255, 255), 2, cv2.LINE_AA)
        #cv2.imshow('Camera', img)
        # end normal flow

        if cv2.waitKey(25) & 0xFF == ord('q'):
            video.release()
            break

cv2.destroyAllWindows()
