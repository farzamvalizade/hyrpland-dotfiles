#!/bin/bash

# Fetch the active window's class (app ID) via hyprctl
app_class=$(hyprctl activewindow -j | jq -r '.class')

# Check if a window is focused
if [ "$app_class" == "null" ] || [ -z "$app_class" ]; then
    echo "" # Output nothing if no window is focused
else
    # Convert the app class to uppercase and output it
    echo "${app_class^^}"
fi