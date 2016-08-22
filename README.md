# ArdupilotTiny
Run Ardupilot Scheduler on atmega328p Arduino.

#About it
It's Ardupilot HAL Scheduler port to atmega328p with Arduino headers integration.

There is an example:

	- Scheduler TEST.

#Important Changes
    STORAGE: Fited to 328p Eeprom size. It's secure work with AP_Param.
	Scheduler: Working very good, now we have fully multitaskingon 328p with Arduino headers integration.

#HOW TO BUILD

    - Download and install Arduino 1.6.6 (Tested with this version).
    - Open Arduino, click File, Preference and select ArdupilotMicro path root.
	- Open included example, compile and enjoy!