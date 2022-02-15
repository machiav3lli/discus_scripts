#!/usr/bin/env python
from Adafruit_Thermal import * # https://github.com/adafruit/Python-Thermal-Printer
import random

positiveArgs = ["Neusortierung des ruhenden\nVerkehrs","Weniger Lärm im Kiez","Mehr und sicherer Raum für\nunsere Kinder"]

def printFlyer():
    # Init the printer
    printer = Adafruit_Thermal("/dev/serial0", 9600, timeout=5)
    # sets higher heat time for better quality print
    printer.begin(200)

    printer.feed(3)
    printer.boldOn()
    printer.justify('C')
    printer.setSize('L')
    printer.print("Wie stehst du\nzum Ausbau der\nOderstraße zur\nFahrradstraße?")
    printer.feed(4)  # Blank lines
    printer.boldOff()
    printer.setSize('S')
    printer.print("Du hast dagegen gestimmt. Hier\naber ein Argument für die\nDurchführung:")
    printer.feed(2)  # Blank lines
    printer.setSize('M')
    printer.print(random.choice(positiveArgs))
    printer.feed(3)  # Blank lines
    printer.setDefault()
    printer.print("Erfahre mehr über das Projekt\nund komme in den Austausch mit\nanderen Bürgerinnen und Bürgern\nBürgern auf mein.berlin:")
    printer.feed()
    printer.print("https://link.infini.fr/hYzBZc8-")
    printer.feed(4)
    printer.boldOn()
    printer.justify('C')
    printer.print("Am Samstag, den 30.10.2021\num 14 Uhr findet ein\nKonsultationstreffen. Treffpunkt\nist an der Oderstraße,\nEingang II am Tempelhofer Feld,\nHöhe Allerstraße.")
    printer.feed(4)
    # the image must have width of 384px otherwise it'll get cropped
    #printer.printImage('/home/pi/Discus/flyer_low/qrcode_calendar.png', True)
    #printer.feed()
    print("The flyer was printed.")

printFlyer()
