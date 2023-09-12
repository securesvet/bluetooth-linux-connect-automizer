#!/usr/bin/env bash

AIRPOD_ICON=$'\uF7CC'

BATTERY_INFO=(
  "BatteryPercentCombined" 
  "HeadsetBattery" 
  "BatteryPercentSingle" 
  "BatteryPercentCase" 
  "BatteryPercentLeft" 
  "BatteryPercentRight"
)

BT_DEFAULTS=$(defaults read /Library/Preferences/com.apple.Bluetooth)
SYS_PROFILE=$(system_profiler SPBluetoothDataType 2>/dev/null)
#MAC_ADDR=$(grep -b2 "Minor Type: Headphones"<<<"${SYS_PROFILE}"|awk '/Address/{print $3}')
MAC_ADDR=74:65:0C:40:78:15
echo $MAC_ADDR
CONNECTED=$(grep -ia6 "${MAC_ADDR}"<<<"${SYS_PROFILE}"|awk '/Connected: Yes/{print 1}')
echo $CONNECTED
BT_DATA=$(grep -ia6 '"'"${MAC_ADDR}"'"'<<<"${BT_DEFAULTS}")

if [[ "${CONNECTED}" ]]; then
  for info in "${BATTERY_INFO[@]}"; do
    declare -x "${info}"="$(awk -v pat="${info}" '$0~pat{gsub (";",""); print $3 }'<<<"${BT_DATA}")"
    [[ ! -z "${!info}" ]] && OUTPUT="${OUTPUT} $(awk '/BatteryPercent/{print substr($0,15)": "}'<<<"${info}")${!info}%"
  done
   printf "%s\\n" "${AIRPOD_ICON} ${OUTPUT}"
else
  printf "%s Not Connected\\n" "${OUTPUT}"
fi

exit 0
