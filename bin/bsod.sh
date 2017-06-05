#!/bin/bash

set -e
#set -x


cd ~

#if ! [ -d /Volumes/Logs/dumps ]; then
#	mkdir -p /Volumes/Logs
#	mount_smbfs //synology.barkly.local/Logs /Volumes/Logs
#fi

recent_bsod=$(ls -Art /Volumes/Logs/dumps/ | grep "$1$" | tail -n 1)


echo $recent_bsod

mkdir -p ~/gg/bsod/$recent_bsod
echo cd ~/gg/bsod/$recent_bsod
cd ~/gg/bsod/$recent_bsod


cp /Volumes/Logs/dumps/$recent_bsod/*.zip .
unzip *.zip

if [ -e memory.dmp ]; then
	grep -a '\[Barkly:0x[a-z0-9]\+\]' memory.dmp | strings | sort > panic.txt
	cat panic.txt

	~/gg/RV-Tools/Debugging/PanicParser.py panic.txt > parsed.txt
	cat parsed.txt

	bugcheckinfo.py memory.dmp
else
	echo "No memory dump. Go look in logs."
fi
