# Low Battery and CPU Temperature Alert for Linux

This script checks the battery status and CPU temperature and warns the user
when battery is discharging and percentage is too low and also
when the CPU temperature is too high.

The limits can be changed/reset in the code if desired:
```$number -gt XX``` for battery and ```arrayCpuTemp -gt XX``` for CPU temp

```acpi```, ```lm-sensors``` and ```zenity``` should be installed.



I'm thankful for any comments since this is my first public commit.
