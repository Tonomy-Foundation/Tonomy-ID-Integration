#!/bin/bash

# Make sure the android emulator is running and connect to it
cd /home/node
./dockerize -wait tcp://android-emulator:5555
sleep 2
adb connect android-emulator:5555

echo "Open your browser to http://localhost:6080 to open emulator"

cd /var/repo/Tonomy-ID
npm run start &
sleep 2
npm run android