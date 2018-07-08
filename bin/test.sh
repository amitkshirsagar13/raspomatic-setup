#!/bin/sh
if ifconfig wlp2s0 | grep -q "inet " ; then
	echo "Test in If"
else
	echo "Test in Else"
fi

