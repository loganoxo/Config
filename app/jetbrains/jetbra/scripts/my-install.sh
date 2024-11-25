#!/bin/bash

set -euo pipefail

OS_NAME=$(uname -s)
JB_PRODUCTS="aqua clion datagrip dataspell devecostudio gateway goland idea jetbrains_client jetbrainsclient phpstorm pycharm rider rubymine rustrover studio webide webstorm"

# 上一级目录
BASE_PATH=$(dirname $(
  cd $(dirname "$0")
  pwd
))

JAR_FILE_PATH="${BASE_PATH}/ja-netfilter.jar"

if [ ! -f "${JAR_FILE_PATH}" ]; then
  echo 'ja-netfilter.jar not found'
  exit 1
fi

KDE_ENV_DIR="${HOME}/.config/plasma-workspace/env"
LAUNCH_AGENTS_DIR="${HOME}/Library/LaunchAgents"
PLIST_PATH="${LAUNCH_AGENTS_DIR}/jetbrains.vmoptions.plist"

BASH_PROFILE_PATH="${HOME}/Data/Config/bash/bash_profile"
BASH_RC_PATH="${HOME}/Data/Config/bash/bashrc"
ZSH_PROFILE_PATH="${HOME}/Data/Config/zsh/zprofile"
ZSH_RC_PATH="${HOME}/Data/Config/zsh/zshrc"

# mkdir -p "${LAUNCH_AGENTS_DIR}"

echo '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><dict><key>Label</key><string>jetbrains.vmoptions</string><key>ProgramArguments</key><array><string>sh</string><string>-c</string><string>' >"${PLIST_PATH}"

# touch "${PROFILE_PATH}"
# touch "${BASH_PROFILE_PATH}"
# touch "${ZSH_PROFILE_PATH}"

MY_VMOPTIONS_SHELL_NAME="jetbrains.vmoptions.sh"
MY_VMOPTIONS_SHELL_FILE="${HOME}/.${MY_VMOPTIONS_SHELL_NAME}"
echo '#!/bin/sh' >"${MY_VMOPTIONS_SHELL_FILE}"

EXEC_LINE='___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi'

for PRD in $JB_PRODUCTS; do
  VM_FILE_PATH="${BASE_PATH}/vmoptions/${PRD}.vmoptions"
  if [ ! -f "${VM_FILE_PATH}" ]; then
    continue
  fi
  sed -i '' '/^\-javaagent:.*[\/\\]ja\-netfilter\.jar.*/d' "${VM_FILE_PATH}"
  echo "-javaagent:${JAR_FILE_PATH}=jetbrains" >>"${VM_FILE_PATH}"

  ENV_NAME=$(echo $PRD | tr '[a-z]' '[A-Z]')"_VM_OPTIONS"
  echo "export ${ENV_NAME}=\"${VM_FILE_PATH}\"" >>"${MY_VMOPTIONS_SHELL_FILE}"
  launchctl setenv "${ENV_NAME}" "${VM_FILE_PATH}"
  echo "launchctl setenv \"${ENV_NAME}\" \"${VM_FILE_PATH}\"" >>"${PLIST_PATH}"
done

echo "echo \$(date \"+%Y-%m-%d %H:%M:%S\")\"   RUNS\"" >>"${PLIST_PATH}"
echo '</string></array><key>RunAtLoad</key><true/>' >>"${PLIST_PATH}"
echo '<key>StandardOutPath</key><string>/Users/logan/Logs/jetbra/out.log</string>' >>"${PLIST_PATH}"
echo '<key>StandardErrorPath</key><string>/Users/logan/Logs/jetbra/error.log</string>' >>"${PLIST_PATH}"
echo '</dict></plist>' >>"${PLIST_PATH}"

sed -i '' '/___MY_VMOPTIONS_SHELL_FILE="${HOME}\/\.jetbrains\.vmoptions\.sh"; if /d' "${BASH_PROFILE_PATH}"
sed -i '' '/___MY_VMOPTIONS_SHELL_FILE="${HOME}\/\.jetbrains\.vmoptions\.sh"; if /d' "${BASH_RC_PATH}"
sed -i '' '/___MY_VMOPTIONS_SHELL_FILE="${HOME}\/\.jetbrains\.vmoptions\.sh"; if /d' "${ZSH_PROFILE_PATH}"
sed -i '' '/___MY_VMOPTIONS_SHELL_FILE="${HOME}\/\.jetbrains\.vmoptions\.sh"; if /d' "${ZSH_RC_PATH}"

echo "${EXEC_LINE}" >>"${BASH_PROFILE_PATH}"
echo "${EXEC_LINE}" >>"${BASH_RC_PATH}"
echo "${EXEC_LINE}" >>"${ZSH_PROFILE_PATH}"
echo "${EXEC_LINE}" >>"${ZSH_RC_PATH}"



echo 'done. the "kill Dock" command can fix the crash issue.'
