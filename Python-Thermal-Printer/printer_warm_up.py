#!/usr/bin/env python
from Adafruit_Thermal import * # https://github.com/adafruit/Python-Thermal-Printer

def warmUp():
    # Init the printer
    printer = Adafruit_Thermal("/dev/serial0", 9600, timeout=5)
    # sets higher heat time for better quality print
    printer.begin(200)

warmUp()
