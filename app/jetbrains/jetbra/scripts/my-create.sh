#!/usr/bin/env bash

set -euo pipefail

OS_NAME=$(uname -s)
JB_PRODUCTS="aqua clion datagrip dataspell devecostudio gateway goland idea jetbrains_client jetbrainsclient phpstorm pycharm rider rubymine rustrover studio webide webstorm"
# 上一级目录
BASE_PATH=$(dirname $(
  cd $(dirname "$0")
  pwd
))

PLIST_PATH="./jetbrains.vmoptions.plist"
echo '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><dict><key>Label</key><string>jetbrains.vmoptions</string><key>ProgramArguments</key><array><string>sh</string><string>-c</string><string>' >"${PLIST_PATH}"

MY_VMOPTIONS_SHELL_FILE="./jetbrains.vmoptions.sh"
echo '#!/bin/sh' >"${MY_VMOPTIONS_SHELL_FILE}"

for PRD in $JB_PRODUCTS; do
  VM_FILE_PATH="${BASE_PATH}/vmoptions/${PRD}.vmoptions"
  if [ ! -f "${VM_FILE_PATH}" ]; then
    continue
  fi
  ENV_NAME=$(echo $PRD | tr '[a-z]' '[A-Z]')"_VM_OPTIONS"
  echo "export ${ENV_NAME}=\"${VM_FILE_PATH}\"" >>"${MY_VMOPTIONS_SHELL_FILE}"
  echo "launchctl setenv \"${ENV_NAME}\" \"${VM_FILE_PATH}\"" >>"${PLIST_PATH}"
done

echo "echo \$(date \"+%Y-%m-%d %H:%M:%S\")\"   RUNS\"" >>"${PLIST_PATH}"
echo '</string></array><key>RunAtLoad</key><true/>' >>"${PLIST_PATH}"
echo '<key>StandardOutPath</key><string>/Users/logan/Logs/jetbra/out.log</string>' >>"${PLIST_PATH}"
echo '<key>StandardErrorPath</key><string>/Users/logan/Logs/jetbra/error.log</string>' >>"${PLIST_PATH}"
echo '</dict></plist>' >>"${PLIST_PATH}"


echo 'done. the "kill Dock" command can fix the crash issue.'
