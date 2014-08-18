rem intro
@set "TXT_intro_line1= For the execution of NORway by Judges (www.github.com/hjudges/NORway)."
@set "TXT_intro_line2= Installation Note:"
@set "TXT_intro_line3=    - Place this program into the same folder as NORway.py file"
@set "TXT_intro_line4=    - Execute"


rem disclaimer
@set "TXT_disclaimer_line1= ATTENTION : The use of this program is at your own risk."
@set "TXT_disclaimer_line2= The author can not be held responsible for the consequences of its use."


rem commands
@set "TXT_cmd_tittle=Commands:"

@set "TXT_cmd_INFO=INFO (set tristate, display NOR information)"
@set "TXT_cmd_DUMP=DUMP (dump NOR content)"
@set "TXT_cmd_WRITE=WRITE (flash NOR, buffered programming mode)"
@set "TXT_cmd_VWRITE=VWRITE (flash and verify NOR, buffered programming mode)"
@set "TXT_cmd_WRITEWORD=WRITEWORD (flash NOR, word programming mode)"
@set "TXT_cmd_VWRITEWORD=VWRITEWORD (flash and verify NOR, word programming mode)"
@set "TXT_cmd_WRITEWORDUBM=WRITEWORDUBM (flash NOR, word programming/unlock bypass mode)"
@set "TXT_cmd_VWRITEWORDUBM=VWRITEWORDUBM (flash and verify NOR, word programming/unlock bypass mode)"
@set "TXT_cmd_VERIFY=VERIFY (verify NOR content compared to a dump file)"
@set "TXT_cmd_ERASECHIP=ERASECHIP (erase entire NOR content)"
@set "TXT_cmd_RELEASE=RELEASE (release tristate, so the PS3 can boot)"
@set "TXT_cmd_quit=Quit"

@set "TXT_cmd_choose=Select a command"

@set "TXT_cmd_validate1=Start command"
@set "TXT_cmd_validate2=with those settings"


rem choice YES or NO
@set "TXT_choiceYN=YN"


rem teensy
@set "TXT_teensy_detect=Teensy found on port"
@set "TXT_teensyerror_line1=Error : Teensy not found."
@set "TXT_teensyerror_line2=Command aborted."


rem dump
@set "TXT_dump_nbr=Dump quantity"
@set "TXT_dump_name=Dump(s) name (ex: "mydump")"
@set "TXT_dump_saveas=Dump(s) will be saved as"
@set "TXT_dump_savedas=Dump saved as"

@set "TXT_dump_startcomp=Launch binary comparison of dumps"
@set "TXT_dump_compWait=Please wait..."
@set "TXT_dump_compSame=same as"
@set "TXT_dump_compDiff=different from"
@set "TXT_dump_compOK=Dumps are identical. Details in file compare_log.txt."
@set "TXT_dump_compNOK=Attention : one or more dumps are different. Details in file compare_log.txt."
@set "TXT_dump_compERROR=Error : one or more files not found."


rem write
@set "TXT_seefiles=Files available in"
@set "TXT_write_with=Write NOR with file (ex: "mydump.bin")"
@set "TXT_willwrite_with=NOR will be written with file"


rem verify
@set "TXT_verify_with=Verify with file (ex: "mydump.bin")"
@set "TXT_willverify_with=NOR content will be verified in comparison to file"


rem error
@set "TXT_error=An error occurred. Verify your installation."

@set "TXT_error_nofile1=Error : File"
@set "TXT_error_nofile2=not found."

@set "TXT_error_sizefile1=Error : Size of"
@set "TXT_error_sizefile2=is"
@set "TXT_error_sizefile3=Bytes."
@set "TXT_error_sizefile4=Should be 16777216 Bytes (16384 KB)."

@set "TXT_restart=Try again"


rem warning
@set "TXT_warningversion_line1=                             ---- ATTENTION ----"
@set "TXT_warningversion_line2=                 This program needs Windows XP(pro)/Vista/7/8."
@set "TXT_warningversion_line3=                     It is incompatible with your system."
@set "TXT_warningversion_line4=                             Program will close."
@set "TXT_warningversion_line5=                             -------------------"

@set "TXT_warningfiles_line1=                             ---- ATTENTION ----"
@set "TXT_warningfiles_line2=                          NORway.py file not found."
@set "TXT_warningfiles_line3=                             Program will close."
@set "TXT_warningfiles_line4=                             -------------------"



rem ********************************  specific NANDway *********************************

rem intro
@set "TXT_NANDintro_line1= For the execution of NANDway (SBE) by Judges (www.github.com/hjudges/NORway)."
@set "TXT_NANDintro_line3=    - Place this program into the same folder as NANDway.py file"

rem commands
@set "TXT_NANDcmd_INFO=INFO (display NAND information)"
@set "TXT_NANDcmd_DUMP=DUMP (dump NAND content)"
@set "TXT_NANDcmd_WRITE=WRITE (flash NAND)"
@set "TXT_NANDcmd_VWRITE=VWRITE (flash and verify NAND)"
@set "TXT_NANDcmd_DIFFWRITE=DIFFWRITE (differential flash NAND)"
@set "TXT_NANDcmd_VDIFFWRITE=VDIFFWRITE (differential flash and verify NAND)"
@set "TXT_NANDcmd_PS3BADBLOCKS=PS3BADBLOCKS (identify bad blocks in a NAND dump file)"

rem write
@set "TXT_NANDdiff_with=Differential flash file (ex: "DifferenceFileFlash.txt")"
@set "TXT_NANDwillwrite_with=NAND will be written with file"
@set "TXT_NANDwilldiff_with=differentially using file"

rem badblocks
@set "TXT_NANDbb_with=Identify bad blocks in file (ex: "mydump.bin")"

rem error
@set "TXT_NANDerror_sizefile4=Should be 138412032 Bytes (135168 KB)."

rem warning
@set "TXT_NANDwarningfiles_line2=                          NANDway.py file not found."













