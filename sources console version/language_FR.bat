rem intro
@set "TXT_intro_line1= Pour l'ex‚cution de NORway par Judges (www.github.com/hjudges/NORway)."
@set "TXT_intro_line2= Installation Note:"
@set "TXT_intro_line3=    - Placez ce programme dans le mˆme dossier que le fichier NORway.py"
@set "TXT_intro_line4=    - Executez"


rem disclaimer
@set "TXT_disclaimer_line1= ATTENTION : L'utilisation de ce programme est … vos propres risques."
@set "TXT_disclaimer_line2= L'auteur ne pourra ˆtre tenu r‚sponsable des cons‚quences de son utilisation."


rem commands
@set "TXT_cmd_tittle=Commandes:"

@set "TXT_cmd_INFO=INFO (activer le Tristate, afficher les informations de la NOR)"
@set "TXT_cmd_DUMP=DUMP (dumper la NOR)"
@set "TXT_cmd_WRITE=WRITE (flasher la NOR, buffered programming mode)"
@set "TXT_cmd_VWRITE=VWRITE (flasher et v‚rifier la NOR, buffered programming mode)"
@set "TXT_cmd_WRITEWORD=WRITEWORD (flasher la NOR, word programming mode)"
@set "TXT_cmd_VWRITEWORD=VWRITEWORD (flasher et v‚rifier la NOR, word programming mode)"
@set "TXT_cmd_WRITEWORDUBM=WRITEWORDUBM (flasher la NOR, word programming/unlock bypass mode)"
@set "TXT_cmd_VWRITEWORDUBM=VWRITEWORDUBM (flasher et v‚fier la NOR, word prgrmmng/unlock bypass mode)"
@set "TXT_cmd_VERIFY=VERIFY (v‚rifier le contenu de la NOR par rapport … un dump)"
@set "TXT_cmd_ERASECHIP=ERASECHIP (effacer tout le contenu de la NOR)"
@set "TXT_cmd_RELEASE=RELEASE (d‚sactiver le Tristate pour permettre le d‚marrage de la console)"
@set "TXT_cmd_quit=Quitter"

@set "TXT_cmd_choose=Choisissez une commande"

@set "TXT_cmd_validate1=Lancer la commande"
@set "TXT_cmd_validate2=avec ces paramŠtres"


rem choice YES or NO
@set "TXT_choiceYN=ON"


rem teensy
@set "TXT_teensy_detect=Teensy d‚tect‚ sur le port"
@set "TXT_teensyerror_line1=Erreur : Teensy non d‚tect‚."
@set "TXT_teensyerror_line2=Commande abandonn‚e."


rem dump
@set "TXT_dump_nbr=Nombre de dumps … effectuer"
@set "TXT_dump_name=Donnez un nom au(x) dump(s) (ex: "mondump")"
@set "TXT_dump_saveas=Les dumps seront enregistr‚s sous"
@set "TXT_dump_savedas=Dump enregistr‚ sous"

@set "TXT_dump_startcomp=Lancer une comparaison hexad‚cimale des dumps"
@set "TXT_dump_compWait=Merci de patienter..."
@set "TXT_dump_compSame=identique …"
@set "TXT_dump_compDiff=diff‚rent de"
@set "TXT_dump_compOK=Dumps identiques. D‚tails dans le fichier compare_log.txt."
@set "TXT_dump_compNOK=Attention : un ou plusieurs dumps diff‚rents. D‚tails dans compare_log.txt."
@set "TXT_dump_compERROR=Erreur : un ou plusieurs fichier(s) introuvable(s)"


rem write
@set "TXT_seefiles=Fichiers disponibles sous"
@set "TXT_write_with=Flasher avec le fichier (ex: "mondump.bin")"
@set "TXT_willwrite_with=La NOR sera flash‚e avec le fichier"


rem verify
@set "TXT_verify_with=V‚rifier avec le fichier (ex: "mondump.bin")"
@set "TXT_willverify_with=Le contenu de la NOR sera v‚rifi‚ par rapport au fichier"


rem error
@set "TXT_error=Une erreur s'est produite. V‚rifiez votre installation."

@set "TXT_error_nofile1=Erreur : Fichier"
@set "TXT_error_nofile2=inexistant."

@set "TXT_error_sizefile1=Erreur : La taille du fichier"
@set "TXT_error_sizefile2=est de"
@set "TXT_error_sizefile3=octets."
@set "TXT_error_sizefile4=Elle doit ˆtre de 16777216 octets (16384 Ko)."

@set "TXT_restart=Recommencer"


rem warning
@set "TXT_warningversion_line1=                             ---- ATTENTION ----"
@set "TXT_warningversion_line2=               Ce programme n‚cessite Windows XP(pro)/Vista/7/8."
@set "TXT_warningversion_line3=                    Il est incompatible avec votre sytŠme."
@set "TXT_warningversion_line4=                        Le programme va ˆtre arrˆt‚."
@set "TXT_warningversion_line5=                             -------------------"

@set "TXT_warningfiles_line1=                             ---- ATTENTION ----"
@set "TXT_warningfiles_line2=                       Fichier NORway.py non d‚tect‚."
@set "TXT_warningfiles_line3=                        Le programme va ˆtre arrˆt‚."
@set "TXT_warningfiles_line4=                             -------------------"



rem ********************************  specific NANDway *********************************

rem intro
@set "TXT_NANDintro_line1= Pour l'ex‚cution de NANDway (SBE) par Judges (www.github.com/hjudges/NORway)."
@set "TXT_NANDintro_line3=    - Placez ce programme dans le mˆme dossier que le fichier NANDway.py"

rem commands
@set "TXT_NANDcmd_INFO=INFO (afficher les informations de la NAND)"
@set "TXT_NANDcmd_DUMP=DUMP (dumper la NAND)"
@set "TXT_NANDcmd_WRITE=WRITE (flasher la NAND)"
@set "TXT_NANDcmd_VWRITE=VWRITE (flasher et v‚rifier la NAND)"
@set "TXT_NANDcmd_DIFFWRITE=DIFFWRITE (flash diff‚rentiel de la NAND)"
@set "TXT_NANDcmd_VDIFFWRITE=VDIFFWRITE (flash diff‚rentiel et v‚rifier la NAND)"
@set "TXT_NANDcmd_PS3BADBLOCKS=PS3BADBLOCKS (identifier les Bad Blocks d'un dump NAND)"

rem write
@set "TXT_NANDdiff_with=Fichier de flash diff‚rentiel (ex: "DifferenceFileFlash.txt")"
@set "TXT_NANDwillwrite_with=La NAND sera flash‚e avec le fichier"
@set "TXT_NANDwilldiff_with=en diff‚renciel par le fichier"

rem badblocks
@set "TXT_NANDbb_with=Identifier les Bad Blocks du fichier (ex: "mondump.bin")"

rem error
@set "TXT_NANDerror_sizefile4=Elle doit ˆtre de 138412032 octets (135168 Ko)."

rem warning
@set "TXT_NANDwarningfiles_line2=                       Fichier NANDway.py non d‚tect‚."


