#!/bin/bash

# Put your MAC address here.
MAC=74:65:0C:40:78:15

error_exit()
{
	echo "Error $1"
	exit 1
}

if [ $1 -e '-d' ]; then
	echo "Disconnecting airpods"
	bluetoothctl -- disconnect $MAC || error_exit "Cannot disconnect"
	notify-send "Airpods are disconnected"
	exit 0
fi

bluetoothctl -- power on || error_exit "Problem powering bluetooth on" 
# bluetoothctl -- pair $MAC || true
echo -e "\033[32mTrying to connect...\033[0m"
bluetoothctl -- trust $MAC
bluetoothctl -- connect $MAC 
notify-send "Airpods are connected" --icon="$(pwd)/icons/airpods.png"
bluetoothctl -- exit
INDEX=$(pacmd list-sinks | grep -i -C 30 "device.string\s=\s\"$MAC\"" | grep -oE "index:\s[0-9]*" | grep -o "[0-9]*")
pacmd set-default-sink $INDEX
if [[ $? -eq 0 ]]; then
	echo -e "\033[33mChanged default source to your Airpods\033[0m"
fi
echo -e "\033[32mAll done"
exit 0 
