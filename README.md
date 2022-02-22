# DISCUS Scripts

The software-side of DISCUS - the discussion promoting disc. This collection of the resources, scripts and programs are used in combination with [DISCUS' client](https://github.com/machiav3lli/discus_client).

- Wherever "the fair" is mentioned, ["Digital:Sovereignty Design Fair"](https://www.codingixd.org/design-fair-digitalsovereignty) is meant.

![](Banner.jpg)

## Description

#### flyer

Includes the Processing program used to create the flyer, parsing the project's information from a JSON file. The included JSON file is just an example that was used in the fair. The font is also optional.

To use a project's data created by the client:

1. Copy the project's .json file from the Android device (`/Discus/project_{id}.json`) into the flyer folder.

2. Replace the copied project file with the existing example (remove the "_id" from its name)

3. You are ready to go.

DM Sans used for the flyer is licensed under [OFL](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL).

#### on_boot_script

Includes the post-boot scripts that should be run on the Raspberry Pi. Two variants are included:

- **on_boot_processing**: Uses processing to create the flyer dynamically reading the data from a JSON file (preferably created by the client, for manual creation of the JSON see [the client's README](https://github.com/machiav3lli/discus_client/blob/main/README.md). Otherwise a Python script is used to turn up the printer's heat-time (for better print quality). This is the script meant to be used, materializing DISCUS' full concept.

- **on_boot_python**: Uses only a Python script for each answer. The text is mostly hard coded, but replacing those with dynmaically JSON-parsed strings shouldn't be hard. This is the script used in the fair as it's faster.

The post-boot scripts should be added to [one of the post-boot scripts](https://www.dexterindustries.com/howto/run-a-program-on-your-raspberry-pi-at-startup):

- Edit a post-boot script e.g. `sudo nano /home/pi/.bashrc`
- add `(sudo) sh /home/pi/Discus/on_boot_script/on_boot_*.sh` at the end of the script.

#### Python-Thermal-Printer

Includes the Python variant scripts for printing the flyer and a stand-alone to increase the heat-time of the printer. Otherwise it includes a cleaned up copy of the [Adafruit's thermal printer Python library](https://github.com/adafruit/Python-Thermal-Printer).

#### parts

Includes STP files of the main parts and a list of the needed parts to put the device together. Read further in [README](parts/README.md).

## Requirements

- [ZJ-58 CUPS filter](https://github.com/adafruit/zj-58): CUPS "driver" for Adafruit's thermal printer.
- [Python-Thermal-Printer (included)](https://github.com/adafruit/Python-Thermal-Printer): The Python3's version of the Adafruit's thermal printer library.
- [Processing](https://processing.org): The Open-Source visual-art programming language.
- [zxing4processing](http://cagewebdev.com/zxing4processing-processing-library): A small port of the bar codes' library ZXing for Processing.

## License

**DISCUS Scripts** (except DISCUS Parts) is licensed under the [GNU's GPL v3](LICENSE.md).

By [Johannes Schmidtner](https://github.com/johannesschmidtner) and [Antonios Hazim](https://github.com/machiav3lli)
