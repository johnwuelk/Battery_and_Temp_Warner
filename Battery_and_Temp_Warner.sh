#!/usr/bin/env bash
export LANG=en_US.UTF-8
###################################################################
#Script Name    :Battery and Temp Warner
#Description	:This script checks the battery status and CPU temperature and warns the user
#                   when battery is discharging and percentage is too low and also
#                   when the CPU temperature is too high.
#                   The limits can be changed/reset in the code if desired.
#                   ($number -gt XX for battery and arrayCpuTemp -gt XX for CPU temp)
#Args         :
#Author       :Johannes Wülk
#Email        :johnwuelk@gmail.com
###################################################################

battery="acpi | grep -o 'Discharging.*%'"
cpuTemp="sensors | grep -A 0 'CPU' | grep -o '[0-9]\+'"

while true #loop forever
do

outputBattery=$(eval $battery)
outputCpuTemp=$(eval $cpuTemp)

  if [[ $outputBattery == *"Discharging"* ]] #check if plugged in
  then
    #echo "Battery discharging."
    #write output into array with space as delimiter
    IFS=' ' read -r -a arrayBatt <<< "$outputBattery"
    for element in "${arrayBatt[@]}"
    do
      if [[ $element == *"%"* ]]
      then
        number=$(echo "$element" | tr -d %)
        if [[ $number -lt  30 ]] #check if battery status under 30
        then
          batteryNotify="Please charge battery now. \nDraining it too low reduces its lifespan."
          zenity --no-wrap --warning --text "$batteryNotify" #or old: notify-send
        fi
      fi
    done
  fi

IFS=$'\n' read -r -a arrayCpuTemp <<< "$outputCpuTemp"
if [[ arrayCpuTemp -gt 80 ]] #check if cpu temp over 80 °C
then
  cpuTempNotify="CPU has reached "
  cpuTempNotify+="$arrayCpuTemp"
  cpuTempNotify+=" °C, \nplease cool immediately \nor shut down computer."
  zenity --no-wrap --warning --text "$cpuTempNotify"
fi

sleep 120 #check every 2 minutes
done
