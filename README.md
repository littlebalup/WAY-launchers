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
  - Binary dumps comparison (if multi-dumps) with log file.
  - Options to write or verify "Per Firmware" data only on NOR.
    Require my modded NORway.py script. See Installation Instructions for more details.

SYSTEM REQUIREMENTS:
  - Windows XP Professional SP3 + ".NET Framework 3.5 SP1" 
    (http://www.microsoft.com/en-US/download/details.aspx?id=22)
  - Windows Vista SP2 + ".NET Framework 3.5 SP1"
  - Windows 7 SP1 (no need to install framework 3.5 as it is embedded)
  - Windows 8, 8.1 or 10 with ".NET Framework 3.5" enabled
    (http://msdn.microsoft.com/en-US/en-en/library/hh506443%28v=vs.110%29.aspx)

INSTALLATION INSTRUCTIONS:
  - Install python, pyserial, Teensy drivers, scripts... per Judges's instructions 
    (https://github.com/hjudges/NORway)
  - Simply paste the "WAY-launchers.exe" file into the same directory as
    NORway.py / NANDway.py / SPIway.py.
  - [optional] to enable the NOR options "write/verify PerFirmware data only", replace
    the NORway.py file by my modified one available at https://github.com/littlebalup/WAY-launchers/tree/master/NORway%20MOD
  - Execute

-------------------------------------------------------------------------
CHANGE LOG:

 v2.04: Added extra options to write/verify "Per Firmware" data only on NOR. Those Options require my 
		modded NORway.py script to be enabled. See Installation Instructions for more details.
		
 v2.03: Correction of a minor bug concerning errorlevel detection from python scripts.
        
 v2.02: Added compatibility with the latest USB serial drivers from PRJC: 
        "Teensy USB Serial" driver now detected as well as the old one.
        
 v2.01: Bug correction about Multi-dumps and binary checks. (Thanks to Joris 73 from LS)
 
 v2.00: Removed embeded console due to problems with scripts output redirection.
        Now scripts launched in a separate regular console prompt window.
        "Save screen" and "Kill process" buttons removed as well. Instead, you can 
        copy from console to save screen and use Ctrl+C to kill process if needed.
        
 v1.01: Added Teensy programming feature: can load .hex file by clicking on the teensy picture.
        Dump file extention changed: was (*.x.bin), now is (*.bin) if only one dump and (*_x.bin) if multi-dumps.

 v1.00: First release
 
-------------------------------------------------------------------------

Source code available at https://github.com/littlebalup/WAY-launchers	


Thanks to "Judges" for all his work.
Thanks to "Swizzy" for the original idea (ref to WAYgui project : https://github.com/Swizzy/WAYGui)
