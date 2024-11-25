#!/bin/bash
set -e
bcompare_registry="$HOME/Library/Application Support/Beyond Compare 5/registry.dat"
echo "$(date "+%Y-%m-%d %H:%M:%S")   crack bcompare runs"
if [ -f "$bcompare_registry" ]; then
    rm -f "$bcompare_registry"
    echo "$(date "+%Y-%m-%d %H:%M:%S")   registry.dat has been deleted"
else
    echo "$(date "+%Y-%m-%d %H:%M:%S")   nothing to delete"
fi



