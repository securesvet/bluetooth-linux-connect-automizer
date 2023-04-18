#!/bin/bash

error_exit()
{
	echo "Error $1"
	exit 1
}

if [ $1 -e '-d' ]; then
	echo "Disconnecting airpods"
	bluetoothctl -- disconnect $MAC || true
fi
MAC=74:65:0C:40:78:15
bluetoothctl -- power on || error_exit "Problem powering bluetooth on" 
bluetoothctl -- pair $MAC || true
echo "Trying to connect..."
bluetoothctl -- trust $MAC
bluetoothctl -- connect $MAC || error_exit "Problem connecting airpods"
bluetoothctl -- exit
notify-send "Airpods are connected" --icon="$(pwd)/icons/airpods.png"
echo "All done"
exit 0 
