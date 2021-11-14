# low-profile-security-camera
A very humble security camera, using bash and ImageMagick that sends alert to Telegram!

![image](https://user-images.githubusercontent.com/5191469/141652848-32494da5-412c-4cc9-9dc5-af5383eb7a7c.png)

## Hardware
- In my case I've used the ESP32CAM, but you can use any IP camera that you have, considering that you can save an image from it.

## Software
- This [code](https://github.com/thiagosanches/iot-testing/blob/master/kmera-2/kmera-2.ino) was deployed into an ESP32CAM to serve as a camera, you can take a look on the guide [here](https://github.com/thiagosanches/iot-testing/blob/master/kmera-2/README.md).
- ImageMagick installed on an Ubuntu 18.04 machine, you just need to run: `sudo apt-get install -y imagemagick`.

## Installation
```
git clone https://github.com/thiagosanches/low-profile-security-camera.git
cd low-profile-security-camera
chmod +x very-humble-security-camera.sh
./very-humble-security-camera.sh
```


## Feedback
If you have any feedback, please reach out to us at tsigwt@gmail.com
