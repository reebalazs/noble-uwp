#! /bin/bash

uwp_modules=( "windows.foundation" "windows.devices.bluetooth" "windows.devices.bluetooth.advertisement" "windows.devices.bluetooth.genericattributeprofile" "windows.devices.enumeration" "windows.devices.radios" "windows.storage.streams" )
for module in "${uwp_modules[@]}"; do
  path=./uwp/$module
  cd $path
  echo "============================== start building $module =============================="
  npm install --build-from-source 2>&1
  if [[ $? != 0 ]]; then echo "Failed building $module"; exit 1; fi
  ./node_modules/.bin/node-pre-gyp package 2>&1
  if [[ $? != 0 ]]; then echo "Failed packaging $module"; exit 1; fi
  node-pre-gyp-github publish 2>&1
  if [[ $? != 0 ]]; then echo "Failed publishing"; exit 1; fi
  cd ../..
done
echo "done."
