@title NORway Launcher
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
echo                  _   _  ____  _____     
echo                 ^| \ ^| ^|/ __ \^|  __ \                            
echo                 ^|  \^| ^| ^|  ^| ^| ^|__) ^|_      ____ _ _   _        
echo                 ^| . ` ^| ^|  ^| ^|  _  /\ \_/\_/ / _` ^| ^| ^| ^|       
echo                 ^| ^|\  ^| ^|__^| ^| ^| \ \ \      / (_^| ^| ^|_^| ^|       
echo                 ^|_^| \_^|\____/^|_^|  \_\ \_/\_/ \__,_^|\__, ^|       
echo                        _                        _   __/ ^|       
echo                       ^| ^|                      ^| ^| ^|___/    
echo                       ^| ^| __ _ _   _ _ __   ___^| ^|__   ___ _ __ 
echo                       ^| ^|/ _` ^| ^| ^| ^| '_ \ / __^| '_ \ / _ \ '__^|
echo                       ^| ^| (_^| ^| ^|_^| ^| ^| ^| ^| (__^| ^| ^| ^|  __/ ^|   
echo                       ^|_^|\__,_^|\__,_^|_^| ^|_^|\___^|_^| ^|_^|\___^|_^|
echo.
rem ChangeColor 10 0
echo -------------------------------------------------------------------------------
echo %TXT_intro_line1%
echo %TXT_intro_line2%
echo %TXT_intro_line3%
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

if not exist norway.py goto warning_norwayfile

:commandes
cls
rem ChangeColor 14 0
echo *******************************************************************************
echo                      NORway Launcher V1.9, by littlebalup
echo *******************************************************************************
echo.
rem ChangeColor 10 0
echo.
echo %TXT_cmd_tittle%
echo  1 = %TXT_cmd_INFO%
echo  2 = %TXT_cmd_DUMP%
echo  3 = %TXT_cmd_WRITE%
echo  4 = %TXT_cmd_VWRITE%
echo  5 = %TXT_cmd_WRITEWORD%
echo  6 = %TXT_cmd_VWRITEWORD%
echo  7 = %TXT_cmd_WRITEWORDUBM%
echo  8 = %TXT_cmd_VWRITEWORDUBM%
echo  9 = %TXT_cmd_VERIFY%
echo  E = %TXT_cmd_ERASECHIP%
echo  R = %TXT_cmd_RELEASE%
echo  Q = %TXT_cmd_quit%
echo.
%MYFILES%\choice /C:123456789ERQ /N "%TXT_cmd_choose% : "
if %errorlevel%==1 goto info
if %errorlevel%==2 goto dump
if %errorlevel%==3 goto write
if %errorlevel%==4 goto vwrite
if %errorlevel%==5 goto writeword
if %errorlevel%==6 goto vwriteword
if %errorlevel%==7 goto writewordubm
if %errorlevel%==8 goto vwritewordubm
if %errorlevel%==9 goto verify
if %errorlevel%==10 goto erasechip
if %errorlevel%==11 goto release
if %errorlevel%==12 goto end
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
norway.py %teensy_port% info
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
norway.py %teensy_port% dump %dump_file_name%
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
echo NORway launcher, file compare log dated : %date% at %time% >> compare_log.txt
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
if not %filesize%==16777216 goto erreurtaillefichier
echo %TXT_willwrite_with% %CD%\%file_name%
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% WRITE %TXT_cmd_validate2% "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
norway.py %teensy_port% write %file_name%
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
if not %filesize%==16777216 goto erreurtaillefichier
echo %TXT_willwrite_with% %CD%\%file_name%
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% VWRITE %TXT_cmd_validate2% "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
norway.py %teensy_port% vwrite %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
pause
cls
goto commandes

:writeword
set activecmd=writeword
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
:retour_writeword
echo.
set /p file_name= %TXT_write_with% : 
if not exist "%CD%\%file_name%" goto erreurfichier
if "%file_name%" EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichier
echo %TXT_willwrite_with% %CD%\%file_name%
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% WRITEWORD %TXT_cmd_validate2% "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
norway.py %teensy_port% writeword %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
pause
cls
goto commandes

:vwriteword
set activecmd=vwriteword
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
:retour_vwriteword
echo.
set /p file_name= %TXT_write_with% : 
if not exist "%CD%\%file_name%" goto erreurfichier
if "%file_name%" EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichier
echo %TXT_willwrite_with% %CD%\%file_name%
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% VWRITEWORD %TXT_cmd_validate2% "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
norway.py %teensy_port% vwriteword %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
pause
cls
goto commandes

:writewordubm
set activecmd=writewordubm
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
:retour_writewordubm
echo.
set /p file_name= %TXT_write_with% : 
if not exist "%CD%\%file_name%" goto erreurfichier
if "%file_name%" EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichier
echo %TXT_willwrite_with% %CD%\%file_name%
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% WRITEWORDUBM %TXT_cmd_validate2% "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
norway.py %teensy_port% writewordubm %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
pause
cls
goto commandes

:vwritewordubm
set activecmd=vwritewordubm
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
:retour_vwritewordubm
echo.
set /p file_name= %TXT_write_with% : 
if not exist "%CD%\%file_name%" goto erreurfichier
if "%file_name%" EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichier
echo %TXT_willwrite_with% %CD%\%file_name%
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% VWRITEWORDUBM %TXT_cmd_validate2% "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
norway.py %teensy_port% vwritewordubm %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
pause
cls
goto commandes

:verify
set activecmd=verify
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
:retour_verify
echo.
set /p file_name= %TXT_verify_with% : 
if not exist "%CD%\%file_name%" goto erreurfichier
if "%file_name%" EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichier
echo %TXT_willverify_with% %CD%\%file_name%
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% VERifY %TXT_cmd_validate2% "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
norway.py %teensy_port% verify %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
pause
cls
goto commandes

:erasechip
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo %TXT_teensy_detect% %teensy_port%) else (goto erreurteensy)
echo.
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% ERASECHIP "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
norway.py %teensy_port% erasechip
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
pause
cls
goto commandes

:release
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo %TXT_teensy_detect% %teensy_port%) else (goto erreurteensy)
echo.
%MYFILES%\choice /C:%TXT_choiceYN% "%TXT_cmd_validate1% RELEASE "
if %errorlevel%==2 goto commandes
rem ChangeColor 7 0
echo.
echo -------------------------------------------------------------------------------
norway.py %teensy_port% release
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

:erreurtaillefichier
rem ChangeColor 12 0
echo %TXT_error_sizefile1% %CD%\%file_name% %TXT_error_sizefile2% %filesize% %TXT_error_sizefile3%
echo %TXT_error_sizefile4%
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

:warning_norwayfile
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
echo %TXT_warningfiles_line2%
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

