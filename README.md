WAY-launchers
=============

New GUI for NORway, NANDway and SPIway from Judges (https://github.com/hjudges/NORway)

------------------------------------------------------------------------
ATTENTION : The use of this program is at your own risk!
The author can not be held responsible for the consequences of its use.
------------------------------------------------------------------------

Simple GUI, written in VB.net and batch, to easily launch and work with the 
well known NORway, NANDway and SPIway python scripts by Judges for PS3 and PS4
hardware flashing using Teensy++ 2.0.

ADDITIONAL FEATURES:
  - Teensy COM port auto-detection
  - Teensy programming (load .hex file by clicking on teensy picture)
  - Multiple dumps (you can define a quantity of dumps to perform)
  - Binary dumps comparison after dumps (if multi-dumps) with log file.
  - Command prompt screen save.

SYSTEM REQUIREMENTS:
  - Windows XP Professional SP3 + ".NET Framework 3.5 SP1" 
    (http://www.microsoft.com/en-US/download/details.aspx?id=22)
  - Windows Vista SP2 + ".NET Framework 3.5 SP1"
  - Windows 7 SP1 (no need to install framework 3.5 as it is embedded)
  - Windows 8 or 8.1 with ".NET Framework 3.5" enabled
    (http://msdn.microsoft.com/en-US/en-en/library/hh506443%28v=vs.110%29.aspx)

INSTALL INSTRUCTIONS:
  - Install python, pyserial, Teensy drivers, scripts... per Judges's instructions 
    (https://github.com/hjudges/NORway)
  - Simply paste the "WAY-launchers.exe" file into the same directory as
    NORway.py / NANDway.py / SPIway.py.
  - Execute 

-------------------------------------------------------------------------
CHANGE LOG:

 v1.01: Added Teensy programming feature: can load .hex file by clicking on the teensy picture.
	Dump file extention changed: was (*.x.bin), now is (*.bin) if only one dump and (*_x.bin) if multi-dumps.

 v1.00: First release
-------------------------------------------------------------------------

Source code available at https://github.com/littlebalup/WAY-launchers	



Thanks to "Judges" for all his work.
Thanks to "Swizzy" for the original idea (ref to WAYgui project : https://github.com/Swizzy/WAYGui)
Thanks to "Elrat", "Tactick-knife", "NONORMZ", "Karrath" 
and all "Logic-Sunrise" community (http://www.logic-sunrise.com)
