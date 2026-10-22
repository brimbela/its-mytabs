#!/bin/zsh
# Double-click this file in Finder to stop It's MyTabs if it is still running.

PIDS=$(lsof -ti tcp:47777 -sTCP:LISTEN)

if [ -z "$PIDS" ]; then
    echo "It's MyTabs is not running."
else
    kill $PIDS
    echo "It's MyTabs stopped."
fi
