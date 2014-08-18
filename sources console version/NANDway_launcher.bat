@title NANDway Launcher
@echo off
set path=%systemroot%\system32;%systemroot%\system32\wbem

rem deactivate before compile
set MYFILES="%CD%"

SET language=
FOR /F "tokens=3" %%G in ('reg query hklm\system\controlset001\control\nls\language /v Installlanguage ^| findstr "Installlanguage"') DO (
	IF [%%G] EQU [040C] (set language=FR)
	IF [%%G] EQU [080C] (set language=FR)
	IF [%%G] EQU [0C0C] (set language=FR)
	IF [%%G] EQU [100C] (set language=FR)
	IF [%%G] EQU [140C] (set language=FR)
)
	IF [%language%] EQU [] (set language=EN)

call %MYFILES%\language_%language%.bat

color 0A

echo                                                                            V1.9
rem ChangeColor 14 0
echo              _   _          _   _ _____                             
echo             ^| \ ^| ^|   /\   ^| \ ^| ^|  __ \                            
echo             ^|  \^| ^|  /  \  ^|  \^| ^| ^|  ^| ^|_      ____ _ _   _        
echo             ^| . ` ^| / /\ \ ^| . ` ^| ^|  ^| \ \_/\_/ / _` ^| ^| ^| ^|       
echo             ^| ^|\  ^|/ ____ \^| ^|\  ^| ^|__^| ^|\      / (_^| ^| ^|_^| ^|       
echo             ^|_^| \_/_/    \_\_^| \_^|_____/  \_/\_/ \__,_^|\__, ^|       
echo                            _                        _   __/ ^|       
echo                           ^| ^|                      ^| ^| ^|___/        
echo                           ^| ^| __ _ _   _ _ __   ___^| ^|__   ___ _ __ 
echo                           ^| ^|/ _` ^| ^| ^| ^| '_ \ / __^| '_ \ / _ \ '__^|
echo                           ^| ^| (_^| ^| ^|_^| ^| ^| ^| ^| (__^| ^| ^| ^|  __/ ^|   
echo                           ^|_^|\__,_^|\__,_^|_^| ^|_^|\___^|_^| ^|_^|\___^|_^|   
echo.
rem ChangeColor 10 0
echo -------------------------------------------------------------------------------
echo %TXT_NANDintro_line1%
echo %TXT_intro_line2%
echo %TXT_NANDintro_line3%
echo %TXT_intro_line4%
echo.
rem ChangeColor 12 0
echo %TXT_disclaimer_line1%
echo %TXT_disclaimer_line2%
rem ChangeColor 10 0
echo -------------------------------------------------------------------------------
echo.
pause

if not exist %systemroot%\system32\wbem\wmic.exe goto warning_version

if not exist NANDway.py goto warning_nandwayfile

:commandes
cls
rem ChangeColor 14 0
echo *******************************************************************************
echo                      NANDway Launcher V1.9, by littlebalup
echo *******************************************************************************
echo.
rem ChangeColor 10 0
echo.
echo %TXT_cmd_tittle%
echo  1 = %TXT_NANDcmd_INFO%
echo  2 = %TXT_NANDcmd_DUMP%
echo  3 = %TXT_NANDcmd_WRITE%
echo  4 = %TXT_NANDcmd_VWRITE%
echo  5 = %TXT_NANDcmd_DIFFWRITE%
echo  6 = %TXT_NANDcmd_VDIFFWRITE%
echo  7 = %TXT_NANDcmd_PS3BADBLOCKS%
echo  Q = %TXT_cmd_quit%
echo.
%MYFILES%\choice /C:1234567Q /N "%TXT_cmd_choose% : "
if %errorlevel%==1 goto info
if %errorlevel%==2 goto dump
if %errorlevel%==3 goto write
if %errorlevel%==4 goto vwrite
if %errorlevel%==5 goto diffwrite
if %errorlevel%==6 goto vdiffwrite
if %errorlevel%==7 goto ps3badblocks
if %errorlevel%==8 goto end
goto end

:info
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo %TXT_teensy_detect% %teensy_port%) else (goto erreurteensy)
echo.
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% INFO "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
nandway.py %teensy_port% 0 info
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
pause
cls
goto commandes

:dump
set file_name=
set teensy_port=
set nbr_dump=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo %TXT_teensy_detect% %teensy_port%) else (goto erreurteensy)
echo.
:rtn_a
set /p nbr_dump= %TXT_dump_nbr% : 
echo %nbr_dump%|findstr /r /c:"^[0-9][0-9]*$" >nul
if "%nbr_dump%" EQU "" goto rtn_a
if %nbr_dump%==0 goto commandes
if %errorlevel%==1 goto rtn_a
:rtn_b
set /p file_name= %TXT_dump_name% : 
if "%file_name%" EQU "" goto rtn_b
echo %TXT_dump_saveas% %CD%\%file_name%_*.bin
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% DUMP %TXT_cmd_validate2% "
if %errorlevel%==2 goto commandes
set /a VAR=0
:dmpretour 
if %VAR%==%nbr_dump% goto dmpfin
set /a VAR=VAR+1
set dump_file_name=%file_name%_%VAR%.bin
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
nandway.py %teensy_port% 0 dump %dump_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
echo %TXT_dump_savedas% %CD%\%dump_file_name%
echo.
goto dmpretour
:dmpfin
echo.
if %nbr_dump% GTR 1 goto dmpchk
pause
cls
goto commandes
:dmpchk
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_dump_startcomp% " 
if %errorlevel%==2 goto commandes
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
set /a loop=0
set /a errorresult=0
set /a errorfile=0
set /a errorcode=0
if exist compare_log.txt del compare_log.txt
echo NANDway launcher, file compare log dated : %date% at %time% >> compare_log.txt
echo. >> compare_log.txt
:chkloop
if %loop%==%nbr_dump% goto chkfin
set /a loop=loop+1
set /a VAR=%nbr_dump%-(%nbr_dump%-%loop%)
:chkretour 
if %VAR%==%nbr_dump% goto chkloop
set /a VAR=VAR+1
echo %TXT_dump_compWait%
fc /b %file_name%_%loop%.bin %file_name%_%VAR%.bin >> compare_log.txt
if %errorlevel%==0 echo %file_name%_%loop%.bin %TXT_dump_compSame% %file_name%_%VAR%.bin
if %errorlevel%==1 echo %file_name%_%loop%.bin %TXT_dump_compDiff% %file_name%_%VAR%.bin
if %errorlevel%==1 (set /a errorresult=%errorlevel%)
if %errorlevel%==2 (set /a errorfile=%errorlevel%)
goto chkretour
:chkfin
echo. >> compare_log.txt
echo END >> compare_log.txt
set /a errorcode = %errorfile%%errorresult%
echo Done.
echo -------------------------------------------------------------------------------
rem ChangeColor 10 0
echo.
if %errorcode%==0 echo %TXT_dump_compOK%
rem ChangeColor 12 0
if %errorcode%==1 echo %TXT_dump_compNOK%
if %errorcode%==20 echo %TXT_dump_compERROR%
if %errorcode%==21 echo %TXT_dump_compERROR%
rem ChangeColor 10 0
echo.
pause
cls
goto commandes

:write
set activecmd=write
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo %TXT_teensy_detect% %teensy_port%) else (goto erreurteensy)
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
echo %TXT_seefiles% %cd% :
echo.
dir /b *.bin
echo -------------------------------------------------------------------------------
rem ChangeColor 10 0
:retour_write
echo.
set /p file_name= %TXT_write_with% : 
if not exist "%CD%\%file_name%" goto erreurfichier
if "%file_name%" EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==138412032 goto erreurtaillefichier
echo %TXT_NANDwillwrite_with% %CD%\%file_name%
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% WRITE %TXT_cmd_validate2% "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
nandway.py %teensy_port% 0 write %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
pause
cls
goto commandes

:vwrite
set activecmd=vwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo %TXT_teensy_detect% %teensy_port%) else (goto erreurteensy)
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
echo %TXT_seefiles% %cd% :
echo.
dir /b *.bin
echo -------------------------------------------------------------------------------
rem ChangeColor 10 0
:retour_vwrite
echo.
set /p file_name= %TXT_write_with% : 
if not exist "%CD%\%file_name%" goto erreurfichier
if "%file_name%" EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==138412032 goto erreurtaillefichier
echo %TXT_NANDwillwrite_with% %CD%\%file_name%
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% VWRITE %TXT_cmd_validate2% "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
nandway.py %teensy_port% 0 vwrite %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
pause
cls
goto commandes

:diffwrite
set activecmd=diffwrite
set file_name=
set diff_file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo %TXT_teensy_detect% %teensy_port%) else (goto erreurteensy)
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
echo %TXT_seefiles% %cd% :
echo.
dir /b *.bin,*.txt
echo -------------------------------------------------------------------------------
rem ChangeColor 10 0
:retour_diffwrite
echo.
set /p file_name= %TXT_write_with% : 
if not exist "%CD%\%file_name%" goto erreurfichier
if "%file_name%" EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==138412032 goto erreurtaillefichier
:retour_diffwritetxt
set /p diff_file_name= %TXT_NANDdiff_with% : 
if not exist "%CD%\%diff_file_name%" goto erreurfichiertxt
if "%diff_file_name%" EQU "" goto erreurfichiertxt
echo %TXT_NANDwillwrite_with% %CD%\%file_name%
echo %TXT_NANDwilldiff_with% %CD%\%diff_file_name%
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% DIFFWRITE %TXT_cmd_validate2% "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
nandway.py %teensy_port% 0 diffwrite %file_name% %diff_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
pause
cls
goto commandes

:vdiffwrite
set activecmd=vdiffwrite
set file_name=
set diff_file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo %TXT_teensy_detect% %teensy_port%) else (goto erreurteensy)
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
echo %TXT_seefiles% %cd% :
echo.
dir /b *.bin,*.txt
echo -------------------------------------------------------------------------------
rem ChangeColor 10 0
:retour_vdiffwrite
echo.
set /p file_name= %TXT_write_with% : 
if not exist "%CD%\%file_name%" goto erreurfichier
if "%file_name%" EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==138412032 goto erreurtaillefichier
:retour_vdiffwritetxt
set /p diff_file_name= %TXT_NANDdiff_with% : 
if not exist "%CD%\%diff_file_name%" goto erreurfichiertxt
if "%diff_file_name%" EQU "" goto erreurfichiertxt
echo %TXT_NANDwillwrite_with% %CD%\%file_name%
echo %TXT_NANDwilldiff_with% %CD%\%diff_file_name%
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% VDIFFWRITE %TXT_cmd_validate2% "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
nandway.py %teensy_port% 0 vdiffwrite %file_name% %diff_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
pause
cls
goto commandes

:ps3badblocks
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
echo %TXT_seefiles% %cd% :
echo.
dir /b *.bin
echo -------------------------------------------------------------------------------
rem ChangeColor 10 0
echo.
set /p file_name= %TXT_NANDbb_with% : 
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% PS3BADBLOCKS "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
nandway.py ps3badblocks %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
pause
cls
goto commandes

:erreur
rem ChangeColor 12 0
echo %TXT_error%
echo.
rem ChangeColor 10 0
pause
cls
goto commandes

:erreurteensy
rem ChangeColor 12 0
echo %TXT_teensyerror_line1%
echo %TXT_teensyerror_line2%
echo.
rem ChangeColor 10 0
pause
cls
goto commandes

:erreurfichier
rem ChangeColor 12 0
echo %TXT_error_nofile1% %CD%\%file_name% %TXT_error_nofile2%
echo.
rem ChangeColor 10 0
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_restart% "
if %errorlevel%==1 (goto retour_%activecmd%) else (goto commandes) 

:erreurfichiertxt
rem ChangeColor 12 0
echo %TXT_error_nofile1% %CD%\%diff_file_name% %TXT_error_nofile2%
echo.
rem ChangeColor 10 0
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_restart%  "
if %errorlevel%==1 (goto retour_%activecmd%txt) else (goto commandes) 

:erreurtaillefichier
rem ChangeColor 12 0
echo %TXT_error_sizefile1% %CD%\%file_name% %TXT_error_sizefile2% %filesize% %TXT_error_sizefile3%
echo %TXT_NANDerror_sizefile4%
echo.
rem ChangeColor 10 0
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_restart% "
if %errorlevel%==1 (goto retour_%activecmd%) else (goto commandes) 

:warning_version
cls
rem ChangeColor 12 0
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo %TXT_warningversion_line1%
echo.
echo %TXT_warningversion_line2%
echo %TXT_warningversion_line3%
echo.
echo %TXT_warningversion_line4%
echo.
echo %TXT_warningversion_line5%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
rem ChangeColor 10 0
pause
goto end

:warning_nandwayfile
cls
rem ChangeColor 12 0
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo %TXT_warningfiles_line1%
echo.
echo %TXT_NANDwarningfiles_line2%
echo.
echo %TXT_warningfiles_line3%
echo.
echo %TXT_warningfiles_line4%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
rem ChangeColor 10 0
pause
goto end

:end
exit

