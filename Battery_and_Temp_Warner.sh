#!/usr/bin/env bash
###################################################################
#Script Name	:Battery and Temp Warner
#Description	:This script checks the battery status and CPU temperature and warns the user
#              when battery is discharging and percentage is too low and also
#              when the CPU temperature is too high.
#              The limits can be changed/reset in the code
#              ($number -gt XX for battery and arrayCpuTemp[0] -gt XX for CPU temp)
#Args         :
#Author       :Johannes Bottex-Wülk
#Email        :johnwuelk@yahoo.de
###################################################################

battery="acpi | head -n 1"
cpuTemp="sensors | grep -A 0 'CPU' | grep -o '[0-9]\+'"
outputBattery=$(eval $battery)
outputCpuTemp=$(eval $cpuTemp)
#echo $'\n'

while true #loop forever
do

  if [[ $outputBattery == *"Full"* ]] #check if plugged in
  then
    #echo "Battery discharging."
    #write output into array with space as delimiter
    IFS=' ' read -r -a arrayBatt <<< "$outputBattery"
    for element in "${arrayBatt[@]}"
    do
      if [[ $element == *"%"* ]]
      then
        number=$(echo "$element" | tr -d %)
        if [[ $number -lt 30 ]] #check if battery status under 30
        then
          batteryNotify="Please charge battery now. Draining it too low reduces its lifespan."
          notify-send "$batteryNotify" #or notify with zenity
        fi
      fi
    done
  fi

IFS=$'\n' read -r -a arrayCpuTemp <<< "$outputCpuTemp"
if [[ arrayCpuTemp -gt 40 ]] #check if cpu temp over 80 °C
then
  cpuTempNotify="CPU has reached "
  cpuTempNotify+="$arrayCpuTemp"
  cpuTempNotify+=" C, please cool immediately or shut down computer."
  notify-send "$cpuTempNotify"
fi

sleep 120 #check every 2 minutes
done