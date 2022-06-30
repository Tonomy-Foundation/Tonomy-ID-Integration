#!/bin/bash

set -u ## exit if you try to use an uninitialised variable
set -e ## exit if any statement fails

# Make sure the android emulator is running and connect to it
cd /home/node
./dockerize -wait tcp://emulator:5555
sleep 5
adb connect emulator:5555

echo "Open your browser to http://localhost:6080 to open emulator"

cd /var/repo/Tonomy-ID
npm run start &
sleep 2
npm run android

echo "Finished installing app"
echo "Bundler (Metro) is still running in background"

# Keep the container running after the android app is built, for the Metro server (npm run start)
tail -f /dev/null