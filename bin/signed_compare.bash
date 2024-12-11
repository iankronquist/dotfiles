#!/bin/bash

for filename in "${@:1}"
do
	echo "📄 File is $filename"
	disasm=$(otool -Vx $filename | grep -i 'b\.\(gt\|lt\|le\|ge|mi\)')
	#disasm=$(otool -Vx $filename | grep -i '\(gt\|lt\|le\|ge|mi\)\s')
	if [ -z "${disasm}" ]; then
		continue
	fi
	echo $disasm | while read line
	do
		echo "↪️ $line"
		echo "--"
	    echo $line | atos -i -o $filename
		echo "--"
	done
done
