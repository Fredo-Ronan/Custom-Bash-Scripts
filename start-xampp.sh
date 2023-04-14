#!/bin/bash

cd /opt/lampp

sudo ./xampp start

COMMAND="start"
START="start"

echo -e "Press Q to stop..."

while [[ $COMMAND == *"start"* ]];
do
	read -p "" -n1 INPUT

	if [[ $INPUT == *"Q"* ]] || [[ $INPUT == *"q"* ]]
	then
		echo -e ""
		echo -e ""
		COMMAND="stop"
		sudo ./xampp $COMMAND
		echo -e ""
		echo -e "Stopped successfully..."
	fi
done
