#!/bin/bash
set -e
typora_dir="$HOME/Library/Application Support/abnerworks.Typora"

echo "$(date "+%Y-%m-%d %H:%M:%S")   crack typora runs"

if [ -e "$typora_dir" ]; then
    delete_file=$(find "$typora_dir" -maxdepth 1 -type f -regex "^$typora_dir/\.[0-9A-Za-z]*$" -delete -print)
    if [ -n "$delete_file" ]; then
        echo "$(date "+%Y-%m-%d %H:%M:%S")   these files has deleted: "
        echo "$delete_file"
    else
        echo "$(date "+%Y-%m-%d %H:%M:%S")   the delete_file is empty, nothing to delete!"
    fi
else
    echo "$(date "+%Y-%m-%d %H:%M:%S")   typora not exist"
fi



