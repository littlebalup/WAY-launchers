@echo off

set "command=%1"
set "cmdfile1="%~2""
set "cmdfile2="%~3""
set /a argument1=%4
set "argument2=%5"

echo.
echo *******************************************************************************
echo                          WAY-launchers, by littlebalup
echo *******************************************************************************
echo.

rem echo command : %command%
rem echo cmdfile1 : %cmdfile1%
rem echo cmdfile2 : %cmdfile2%
rem echo argument1 : %argument1%
rem echo argument2 : %argument2%
rem goto end

set path=%systemroot%\system32;%systemroot%\system32\wbem

set MYFILES="%cd%"

if not exist %systemroot%\system32\wbem\wmic.exe goto warning_version

goto %command%

goto %end%

rem ------------- NOR codes ---------------------------------------------------------

:NORinfo
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
echo.
if not exist %myfiles%\norway.py goto warning_norwayfile
echo Starting : NORway.py %teensy_port% INFO
echo.
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% info
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:NORdump
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set /a nbr_dump=%argument1%
set "file_name=%cmdfile1%"
rem suite juste pour affichage sans guillemets
for /f "useback tokens=*" %%a in ('%file_name%') do set light_file_name=%%~a
rem 
if %file_name% EQU "" goto erreurfichier
set /a VAR=0
:NORdmpretour 
if %VAR%==%nbr_dump% goto NORdmpfin
set /a VAR=VAR+1
set dump_file_name=%file_name%.%VAR%.bin
set view_file_name=%light_file_name%.%VAR%.bin
echo.
if not exist %myfiles%\norway.py goto warning_norwayfile
echo Starting : NORway.py %teensy_port% DUMP "%view_file_name%"
echo.
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% dump %dump_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
echo Dump saved as :
echo "%view_file_name%"
echo.
goto NORdmpretour
:NORdmpfin
if %argument2% EQU True (goto NORdmpchk) else (goto end)
:NORdmpchk
echo.
echo.
echo Starting binary comparison:
echo -------------------------------------------------------------------------------
set /a loop=0
set /a errorresult=0
set /a errorfile=0
set /a errorcode=0
setlocal enabledelayedexpansion enableextensions
call :path_from_file_name fpath !cmdfile1!
:path_from_file_name <resultVar> <pathVar>
(set "%1=%~dp2")
endlocal
set "file_path="%fpath%""
if exist %file_path%\compare_log.txt del %file_path%\compare_log.txt
echo WAY launchers, file compare log dated : %date% at %time% >> %file_path%\compare_log.txt
echo. >> %file_path%\compare_log.txt
:NORchkloop
if %loop%==%nbr_dump% goto NORchkfin
set /a loop=loop+1
set /a VAR=%nbr_dump%-(%nbr_dump%-%loop%)
:NORchkretour 
if %VAR%==%nbr_dump% goto NORchkloop
set /a VAR=VAR+1
echo Please wait...
echo.
fc /b %file_name%.%loop%.bin %file_name%.%VAR%.bin >> %file_path%\compare_log.txt
if %errorlevel%==0 echo %light_file_name%.%loop%.bin same as %light_file_name%.%VAR%.bin
if %errorlevel%==1 echo %light_file_name%.%loop%.bin different from %light_file_name%.%VAR%.bin
if %errorlevel%==1 (set /a errorresult=%errorlevel%)
if %errorlevel%==2 (set /a errorfile=%errorlevel%)
goto NORchkretour
:NORchkfin
echo. >> %file_path%\compare_log.txt
echo END >> %file_path%\compare_log.txt
set /a errorcode = %errorfile%%errorresult%
echo Done.
echo -------------------------------------------------------------------------------
echo.
if %errorcode%==0 echo Dumps are identical. Details in file compare_log.txt.
if %errorcode%==1 echo Attention : one or more dumps are different. Details in file compare_log.txt.
if %errorcode%==20 echo Error : one or more files not found.
if %errorcode%==21 echo Error : one or more files not found.
goto end

:NORwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichierNOR
echo.
if not exist %myfiles%\norway.py goto warning_norwayfile
echo Starting : NORway.py %teensy_port% WRITE %file_name%
echo.
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% write %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:NORvwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichierNOR
echo.
if not exist %myfiles%\norway.py goto warning_norwayfile
echo Starting : NORway.py %teensy_port% VWRITE %file_name%
echo.
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% vwrite %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:NORwriteword
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichierNOR
echo.
if not exist %myfiles%\norway.py goto warning_norwayfile
echo Starting : NORway.py %teensy_port% WRITEWORD %file_name%
echo.
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% writeword %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:NORvwriteword
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichierNOR
echo.
if not exist %myfiles%\norway.py goto warning_norwayfile
echo Starting : NORway.py %teensy_port% VWRITEWORD %file_name%
echo.
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% vwriteword %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:NORwritewordubm
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichierNOR
echo.
if not exist %myfiles%\norway.py goto warning_norwayfile
echo Starting : NORway.py %teensy_port% WRITEWORDUBM %file_name%
echo.
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% writewordubm %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:NORvwritewordubm
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichierNOR
echo.
if not exist %myfiles%\norway.py goto warning_norwayfile
echo Starting : NORway.py %teensy_port% VWRITEWORDUBM %file_name%
echo.
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% vwritewordubm %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:NORverify
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichierNOR
echo.
if not exist %myfiles%\norway.py goto warning_norwayfile
echo Starting : NORway.py %teensy_port% VERIFY %file_name%
echo.
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% verify %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:NORrelease
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
echo.
if not exist %myfiles%\norway.py goto warning_norwayfile
echo Starting : NORway.py %teensy_port% RELEASE
echo.
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% release
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:NORerasechip
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
echo.
if not exist %myfiles%\norway.py goto warning_norwayfile
echo Starting : NORway.py %teensy_port% ERASECHIP
echo.
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% erasechip
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end


rem ------------- NAND codes ---------------------------------------------------------

:NANDinfo
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
echo.
if not exist %myfiles%\nandway.py goto warning_nandwayfile
echo Starting : NANDway.py %teensy_port% 0 INFO
echo.
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py %teensy_port% 0 info
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:NANDdump
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set /a nbr_dump=%argument1%
set "file_name=%cmdfile1%"
rem suite juste pour affichage sans guillemets
for /f "useback tokens=*" %%a in ('%file_name%') do set light_file_name=%%~a
rem 
if %file_name% EQU "" goto erreurfichier
set /a VAR=0
:NANDdmpretour 
if %VAR%==%nbr_dump% goto NANDdmpfin
set /a VAR=VAR+1
set dump_file_name=%file_name%.%VAR%.bin
set view_file_name=%light_file_name%.%VAR%.bin
echo.
if not exist %myfiles%\nandway.py goto warning_nandwayfile
echo Starting : NANDway.py %teensy_port% 0 DUMP "%view_file_name%"
echo.
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py %teensy_port% 0 dump %dump_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
echo Dump saved as :
echo "%view_file_name%"
echo.
goto NANDdmpretour
:NANDdmpfin
if %argument2% EQU True (goto NANDdmpchk) else (goto end)
:NANDdmpchk
echo.
echo.
echo Starting binary comparison:
echo -------------------------------------------------------------------------------
set /a loop=0
set /a errorresult=0
set /a errorfile=0
set /a errorcode=0
setlocal enabledelayedexpansion enableextensions
call :path_from_file_name fpath !cmdfile1!
:path_from_file_name <resultVar> <pathVar>
(set "%1=%~dp2")
endlocal
set "file_path="%fpath%""
if exist %file_path%\compare_log.txt del %file_path%\compare_log.txt
echo WAY launchers, file compare log dated : %date% at %time% >> %file_path%\compare_log.txt
echo. >> %file_path%\compare_log.txt
:NANDchkloop
if %loop%==%nbr_dump% goto NANDchkfin
set /a loop=loop+1
set /a VAR=%nbr_dump%-(%nbr_dump%-%loop%)
:NANDchkretour 
if %VAR%==%nbr_dump% goto NANDchkloop
set /a VAR=VAR+1
echo Please wait...
echo.
fc /b %file_name%.%loop%.bin %file_name%.%VAR%.bin >> %file_path%\compare_log.txt
if %errorlevel%==0 echo %light_file_name%.%loop%.bin same as %light_file_name%.%VAR%.bin
if %errorlevel%==1 echo %light_file_name%.%loop%.bin different from %light_file_name%.%VAR%.bin
if %errorlevel%==1 (set /a errorresult=%errorlevel%)
if %errorlevel%==2 (set /a errorfile=%errorlevel%)
goto NANDchkretour
:NANDchkfin
echo. >> %file_path%\compare_log.txt
echo END >> %file_path%\compare_log.txt
set /a errorcode = %errorfile%%errorresult%
echo Done.
echo -------------------------------------------------------------------------------
echo.
if %errorcode%==0 echo Dumps are identical. Details in file compare_log.txt.
if %errorcode%==1 echo Attention : one or more dumps are different. Details in file compare_log.txt.
if %errorcode%==20 echo Error : one or more files not found.
if %errorcode%==21 echo Error : one or more files not found.
goto end

:NANDwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==138412032 goto erreurtaillefichierNAND
echo.
if not exist %myfiles%\nandway.py goto warning_nandwayfile
echo Starting : NANDway.py %teensy_port% 0 WRITE %file_name%
echo.
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py %teensy_port% 0 write %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:NANDvwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==138412032 goto erreurtaillefichierNAND
echo.
if not exist %myfiles%\nandway.py goto warning_nandwayfile
echo Starting : NANDway.py %teensy_port% 0 VWRITE %file_name%
echo.
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py %teensy_port% 0 vwrite %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:NANDdiffwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==138412032 goto erreurtaillefichierNAND
set "diff_file_name=%cmdfile2%"
if not exist %diff_file_name% goto erreurfichiertxt
if %diff_file_name% EQU "" goto erreurfichiertxt
echo.
if not exist %myfiles%\nandway.py goto warning_nandwayfile
echo Starting : NANDway.py %teensy_port% 0 DIFFWRITE %file_name%
echo.
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py %teensy_port% 0 diffwrite %file_name% %diff_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:NANDvdiffwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==138412032 goto erreurtaillefichierNAND
set "diff_file_name=%cmdfile2%"
if not exist %diff_file_name% goto erreurfichiertxt
if %diff_file_name% EQU "" goto erreurfichiertxt
echo.
if not exist %myfiles%\nandway.py goto warning_nandwayfile
echo Starting : NANDway.py %teensy_port% 0 VDIFFWRITE %file_name%
echo.
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py %teensy_port% 0 vdiffwrite %file_name% %diff_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:NANDps3badblocks
set file_name=
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==138412032 goto erreurtaillefichierNAND
echo.
if not exist %myfiles%\nandway.py goto warning_nandwayfile
echo Starting : NANDway.py PS3BADBLOCKS %file_name%
echo.
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py ps3badblocks %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end


rem ------------- SPI codes ---------------------------------------------------------

:SPIinfo
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
echo.
if not exist %myfiles%\spiway.py goto warning_spiwayfile
echo Starting : SPIway.py %teensy_port% INFO
echo.
echo -------------------------------------------------------------------------------
%myfiles%\spiway.py %teensy_port% info
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:SPIdump
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set /a nbr_dump=%argument1%
set "file_name=%cmdfile1%"
rem suite juste pour affichage sans guillemets
for /f "useback tokens=*" %%a in ('%file_name%') do set light_file_name=%%~a
rem 
if %file_name% EQU "" goto erreurfichier
set /a VAR=0
:SPIdmpretour 
if %VAR%==%nbr_dump% goto SPIdmpfin
set /a VAR=VAR+1
set dump_file_name=%file_name%.%VAR%.bin
set view_file_name=%light_file_name%.%VAR%.bin
echo.
if not exist %myfiles%\spiway.py goto warning_spiwayfile
echo Starting : SPIway.py %teensy_port% DUMP "%view_file_name%"
echo.
echo -------------------------------------------------------------------------------
%myfiles%\spiway.py %teensy_port% dump %dump_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
echo Dump saved as :
echo "%view_file_name%"
echo.
goto SPIdmpretour
:SPIdmpfin
if %argument2% EQU True (goto SPIdmpchk) else (goto end)
:SPIdmpchk
echo.
echo.
echo Starting binary comparison:
echo -------------------------------------------------------------------------------
set /a loop=0
set /a errorresult=0
set /a errorfile=0
set /a errorcode=0
setlocal enabledelayedexpansion enableextensions
call :path_from_file_name fpath !cmdfile1!
:path_from_file_name <resultVar> <pathVar>
(set "%1=%~dp2")
endlocal
set "file_path="%fpath%""
if exist %file_path%\compare_log.txt del %file_path%\compare_log.txt
echo WAY launchers, file compare log dated : %date% at %time% >> %file_path%\compare_log.txt
echo. >> %file_path%\compare_log.txt
:SPIchkloop
if %loop%==%nbr_dump% goto SPIchkfin
set /a loop=loop+1
set /a VAR=%nbr_dump%-(%nbr_dump%-%loop%)
:SPIchkretour 
if %VAR%==%nbr_dump% goto SPIchkloop
set /a VAR=VAR+1
echo Please wait...
echo.
fc /b %file_name%.%loop%.bin %file_name%.%VAR%.bin >> %file_path%\compare_log.txt
if %errorlevel%==0 echo %light_file_name%.%loop%.bin same as %light_file_name%.%VAR%.bin
if %errorlevel%==1 echo %light_file_name%.%loop%.bin different from %light_file_name%.%VAR%.bin
if %errorlevel%==1 (set /a errorresult=%errorlevel%)
if %errorlevel%==2 (set /a errorfile=%errorlevel%)
goto SPIchkretour
:SPIchkfin
echo. >> %file_path%\compare_log.txt
echo END >> %file_path%\compare_log.txt
set /a errorcode = %errorfile%%errorresult%
echo Done.
echo -------------------------------------------------------------------------------
echo.
if %errorcode%==0 echo Dumps are identical. Details in file compare_log.txt.
if %errorcode%==1 echo Attention : one or more dumps are different. Details in file compare_log.txt.
if %errorcode%==20 echo Error : one or more files not found.
if %errorcode%==21 echo Error : one or more files not found.
goto end

:SPIwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
echo.
if not exist %myfiles%\spiway.py goto warning_spiwayfile
echo Starting : SPIway.py %teensy_port% WRITE %file_name%
echo.
echo -------------------------------------------------------------------------------
%myfiles%\spiway.py %teensy_port% write %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:SPIvwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
echo.
if not exist %myfiles%\spiway.py goto warning_spiwayfile
echo Starting : SPIway.py %teensy_port% VWRITE %file_name%
echo.
echo -------------------------------------------------------------------------------
%myfiles%\spiway.py %teensy_port% vwrite %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end

:SPIerasechip
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
echo.
if not exist %myfiles%\spiway.py goto warning_spiwayfile
echo Starting : SPIway.py %teensy_port% ERASECHIP
echo.
echo -------------------------------------------------------------------------------
%myfiles%\spiway.py %teensy_port% erasechip
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
goto end


rem ------------- error codes ---------------------------------------------------------

:erreur
echo An error occurred. Verify your installation.
goto end

:erreurteensy
echo Error : Teensy not found.
echo Command aborted.
goto end

:erreurfichier
echo Error : File %file_name% not found.
goto end

:erreurfichiertxt
echo Error : File %diff_file_name% not found.
goto end

:erreurtaillefichierNOR
echo Error : Size of %file_name% is %filesize% Bytes.
echo Should be 16777216 Bytes (16384 KB).
goto end

:erreurtaillefichierNAND
echo Error : Size of %file_name% is %filesize% Bytes.
echo Should be 138412032 Bytes (135168 KB).
goto end

:warning_version
cls
echo.
echo.
echo                              ---- ATTENTION ----
echo.
echo                  This program needs Windows XP(pro)/Vista/7/8.
echo                      It is incompatible with your system.
echo.
echo                                Command aborted.
echo.
echo                              -------------------
echo.
echo.
goto end

:warning_norwayfile
cls

echo.
echo.
echo                              ---- ATTENTION ----
echo.
echo                           NORway.py file not found.
echo.
echo                                Command aborted.
echo.
echo                              -------------------
goto end

:warning_nandwayfile
cls

echo.
echo.
echo                              ---- ATTENTION ----
echo.
echo                           NANDway.py file not found.
echo.
echo                                Command aborted.
echo.
echo                              -------------------
goto end

:warning_spiwayfile
cls

echo.
echo.
echo                              ---- ATTENTION ----
echo.
echo                           SPIway.py file not found.
echo.
echo                                Command aborted.
echo.
echo                              -------------------
goto end

:end
echo.
exit
