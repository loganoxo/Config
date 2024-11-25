#!/bin/sh

set -e

OS_NAME=$(uname -s)
JB_PRODUCTS="aqua clion datagrip dataspell devecostudio gateway goland idea jetbrains_client jetbrainsclient phpstorm pycharm rider rubymine rustrover studio webide webstorm"

KDE_ENV_DIR="${HOME}/.config/plasma-workspace/env"

PROFILE_PATH="${HOME}/.profile"
ZSH_PROFILE_PATH="${HOME}/Data/Config/zsh/zshrc"
PLIST_PATH="${HOME}/Library/LaunchAgents/jetbrains.vmoptions.plist"
BASH_PROFILE_PATH="${HOME}/Data/Config/bash/bash_profile"


MY_VMOPTIONS_SHELL_NAME="jetbrains.vmoptions.sh"
MY_VMOPTIONS_SHELL_FILE="${HOME}/.${MY_VMOPTIONS_SHELL_NAME}"

rm -rf "${MY_VMOPTIONS_SHELL_FILE}"

for PRD in $JB_PRODUCTS; do
    ENV_NAME=$(echo $PRD | tr '[a-z]' '[A-Z]')"_VM_OPTIONS"
    launchctl unsetenv "${ENV_NAME}"
done

rm -rf "${PLIST_PATH}"

sed -i '' '/___MY_VMOPTIONS_SHELL_FILE="${HOME}\/\.jetbrains\.vmoptions\.sh"; if /d' "${PROFILE_PATH}"
sed -i '' '/___MY_VMOPTIONS_SHELL_FILE="${HOME}\/\.jetbrains\.vmoptions\.sh"; if /d' "${BASH_PROFILE_PATH}"
sed -i '' '/___MY_VMOPTIONS_SHELL_FILE="${HOME}\/\.jetbrains\.vmoptions\.sh"; if /d' "${ZSH_PROFILE_PATH}"

echo 'done.'
