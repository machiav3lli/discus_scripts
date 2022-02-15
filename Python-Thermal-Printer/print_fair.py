#!/usr/bin/env python
from Adafruit_Thermal import * # https://github.com/adafruit/Python-Thermal-Printer
import random

def printFlyer():
    # Init the printer
    printer = Adafruit_Thermal("/dev/serial0", 9600, timeout=5)
    # sets higher heat time for better quality print
    printer.begin(200)

    # exhibition's/project's info
    printer.justify('L')
    printer.setSize('M')
    printer.print("Digital:Sovereignty\n")
    printer.setSize('S')
    printer.print("February 17-23, 2022")
    printer.feed(2)
    printer.print("for more information visit:\nhttps://www.codingixd.org/\n")
    printer.feed()

printFlyer()
