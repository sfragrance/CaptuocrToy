#!/bin/sh
cd $(dirname $0)
echo "\033[34;1m=== START TO BUILD CAPTUOCR ===\033[0m"
xcodebuild -workspace ../Captuocr.xcworkspace  -scheme Captuocr -configuration Release -derivedDataPath build
now=`date +%Y%m%d_%H%M%S`
mv -f build/Build/Products/Release/Captuocr.app ~/Documents/Captuocr_$now.app
if [ $? -eq 0 ];then
./success.sh
echo "\033[34;1mCaptuocr has been released into ~/Documents/Captuocr_$now\033[0m"
else
./failed.sh
exit 1
fi
