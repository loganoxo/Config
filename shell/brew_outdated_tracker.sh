#!/bin/zsh

# brew_outdated_tracker.sh
# https://github.com/cicciocanestro/brew-update-tracker

# Color definitions
GREEN="\033[0;32m"
BRIGHT_GREEN="\033[1;32m"
RED="\033[0;31m"
CYAN="\033[0;36m"
YELLOW="\033[0;33m"
RESET="\033[0m"

# Exit on error
set -e

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
    echo -e "${RED}Error: Homebrew is not installed${RESET}" >&2
    exit 1
fi

# Check if jq is installed
if ! command -v jq &>/dev/null; then
    echo -e "${RED}Error: jq is not installed${RESET}"
    echo -e "${CYAN}Please install it with: brew install jq${RESET}"
    exit 1
fi

# Create temporary directory
TEMP_DIR=$(mktemp -d /tmp/brew-outdated-tracker.XXXXXX)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo -e "${BRIGHT_GREEN}🍺 Brew Outdated Tracker${RESET}"
echo -e "${BRIGHT_GREEN}=======================${RESET}"

# Find outdated packages
echo -e "\n${CYAN}🔍 Finding outdated packages...${RESET}"
brew outdated --formula >"$TEMP_DIR/outdated_formulae.txt"
brew outdated --cask >"$TEMP_DIR/outdated_casks.txt"

# Step 6: Process formulae
echo -e "\n${CYAN}📊 Processing outdated formulae...${RESET}"
if [[ -s "$TEMP_DIR/outdated_formulae.txt" ]]; then
    echo -e "\n${BRIGHT_GREEN}📦 Outdated Formulae:${RESET}"
    while read -r formula; do
        info=$(brew info --json=v2 "$formula")
        homepage=$(echo "$info" | jq -r '.formulae[0].homepage')
        desc=$(echo "$info" | jq -r '.formulae[0].desc')
        echo "  - $formula:"
        echo "      Homepage: $homepage"
        echo "      Description: $desc"
    done <"$TEMP_DIR/outdated_formulae.txt"
else
    echo -e "  ${GREEN}No formula outdated available.${RESET}"
fi

# Step 7: Process casks
echo -e "\n${CYAN}📊 Processing outdated casks...${RESET}"
if [[ -s "$TEMP_DIR/outdated_casks.txt" ]]; then
    echo -e "\n${BRIGHT_GREEN}📦 Outdated Casks:${RESET}"
    while read -r cask; do
        info=$(brew info --json=v2 "$cask")
        homepage=$(echo "$info" | jq -r '.casks[0].homepage')
        desc=$(echo "$info" | jq -r '.casks[0].desc')
        echo "  - $cask:"
        echo "      Homepage: $homepage"
        echo "      Description: $desc"
    done <"$TEMP_DIR/outdated_casks.txt"
else
    echo -e "  ${GREEN}No cask outdated available.${RESET}"
fi

# Step 10: Check if there are any updates available
total_outdated=$(cat "$TEMP_DIR/outdated_formulae.txt" "$TEMP_DIR/outdated_casks.txt" | wc -l | tr -d ' ')

if [[ $total_outdated -gt 0 ]]; then
    # Step 11: Ask if user wants to upgrade
    echo -e "\n${BRIGHT_GREEN}🚀 Found $total_outdated package(s) that can be upgraded.${RESET}"
else
    echo -e "\n${GREEN}✅ No packages to upgrade!${RESET}"
fi

echo -e "\n${BRIGHT_GREEN}🍺 Brew Outdated Tracker completed!${RESET}"
exit 0
