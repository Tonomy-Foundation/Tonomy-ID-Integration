cd /home/node
./dockerize -wait tcp://android-emulator:5555
./platform-tools/adb connect android-emulator:5555

echo "Waiting 60 second for Android to startup"
echo "Open your browser to http://localhost:6080 to open emulator"
sleep 60
echo "Waiting... done"

cd /var/repo/Tonomy-ID
#npm run start &
#sleep 5
npm run android