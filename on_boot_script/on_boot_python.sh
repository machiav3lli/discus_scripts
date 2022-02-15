#!/bin/bash

# This is the script used in the "IxD: Digital Sovereignity" exhibition. It uses static strings to print the flyer not reading from the JSON file. This can diffenetly replaced by reading from the JSON file.
# Two variants are available:
    # either using the printer's python library to print the full flyer
    # or print only the text then use CUPS to print the QR-Code.

BTN_POWER=23
BTN_SELECT=17
SNS_RIGHT=27 # negative
SNS_LEFT=22 # positive
LED=5

# starts the daemon
sudo pigpiod
# Initialize GPIO states
pigs pud $BTN_POWER  u
pigs pud $BTN_SELECT u
pigs pud $SNS_RIGHT u
pigs pud $SNS_LEFT u

# Flash LED on startup
for i in `seq 1 5`;
do
	pigs w $LED 1
	sleep 0.2
	pigs w $LED 0
	sleep 0.2
done

while :
do
	# PRINT
	if [ $(pigs r $BTN_SELECT) -eq 0 ]; then
		pigs w $LED 1
		if [ $(pigs r $SNS_RIGHT) -eq 0 ]; then
			python /home/pi/Discus/Python-Thermal-Printer/print_fair.py
			python /home/pi/Discus/Python-Thermal-Printer/print_flyer_positive.py
			lp -o fit-to-page -d ZJ-58 /home/pi/Discus/flyer/data/qrcode_calendar.png # Optional: print the QR-Code directly using CUPS
		elif [ $(pigs r $SNS_LEFT) -eq 0 ]; then
			python /home/pi/Discus/Python-Thermal-Printer/print_fair.py
			python /home/pi/Discus/Python-Thermal-Printer/print_flyer_negative.py
			lp -o fit-to-page -d ZJ-58 /home/pi/Discus/flyer/data/qrcode_calendar.png # print the QR-Code directly using CUPS
		else
			python /home/pi/Discus/Python-Thermal-Printer/print_fair.py
			python /home/pi/Discus/Python-Thermal-Printer/print_flyer_neutral.py
			lp -o fit-to-page -d ZJ-58 /home/pi/Discus/flyer/data/qrcode_calendar.png # print the QR-Code directly using CUPS
		fi
		sleep 1
		# Wait for release button before resuming (avoids accidental repeat)
		while [ $(pigs r $BTN_SELECT) -eq 0 ]; do continue; done
		pigs w $LED 0
	fi

	# POWER
	if [ $(pigs r $BTN_POWER) -eq 0 ]; then
		# Hold for 2+ seconds to shut down
		starttime=$(date +%s)
		while [ $(pigs r $BTN_POWER) -eq 0 ]; do
			if [ $(($(date +%s)-starttime)) -ge 2 ]; then
				pigs w $LED 1
				shutdown -h
			fi
		done
	fi
done
