#!/bin/bash

if ifconfig wlan0 | grep -q "inet " ; then
	sleep 60
else
	echo "Network connection down! Attempting reconnection."
	#ifup --force wlan0
	sudo ifconfig wlan0 up
fi
