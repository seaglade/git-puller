#!/bin/ash

while true
do
    git pull
    sleep ${GIT_INTERVAL:-10}
done