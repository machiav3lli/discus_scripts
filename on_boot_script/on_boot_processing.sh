#!/bin/bash

# This is the main script planned to be used in DISCUS. The Processing program reads from the JSON file created by the client[https://github.com/machiav3lli/discus_client]. The created flyers gets printed then directly via CUPS.
# This script wasn't used in the exhibition "Ixd: Digital Sovereignity" as it's slower than the pure python one.

BTN_POWER=23
BTN_SELECT=17
SNS_RIGHT=27 # GPIO for the negative sensor
SNS_LEFT=22 # GPIO for the positive sensor
LED=5

# starts the daemon
sudo pigpiod
# Sets the thermal printer as CUPS default
#sudo lpoptions -d ZJ-58
# Initialize GPIO states
pigs pud  $BTN_POWER  u
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

python /home/pi/Discus/Python-Thermal-Printer/printer_warm_up.py
/home/pi/Discus/processing/processing-java --sketch=/home/pi/Discus/flyer --run 0
/home/pi/Discus/processing/processing-java --sketch=/home/pi/Discus/flyer --run 1
/home/pi/Discus/processing/processing-java --sketch=/home/pi/Discus/flyer --run 2

while :
do
	# PRINT
	if [ $(pigs r $BTN_SELECT) -eq 0 ]; then
		pigs w $LED 1
		if [ $(pigs r $SNS_RIGHT) -eq 0 ]; then
            lp -o media=Custom.58x210mm -d ZJ-58 /home/pi/Discus/flyer/flyer_2.png # or the python script
            /home/pi/Discus/processing/processing-java --sketch=/home/pi/Discus/flyer --run 2
		elif [ $(pigs r $SNS_LEFT) -eq 0 ]; then
            lp -o media=Custom.58x210mm -d ZJ-58 /home/pi/Discus/flyer/flyer_0.png # or the python script
            /home/pi/Discus/processing/processing-java --sketch=/home/pi/Discus/flyer --run 0
		else
            lp -o media=Custom.58x210mm -d ZJ-58 /home/pi/Discus/flyer/flyer_1.png # or the python script
            /home/pi/Discus/processing/processing-java --sketch=/home/pi/Discus/flyer --run 1
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
				shutdown -h now
			fi
		done
	fi
done
