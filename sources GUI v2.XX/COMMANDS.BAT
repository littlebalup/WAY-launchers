@echo off
TITLE WAY-launchers : CONSOLE

set "command=%1"			rem command
set "cmdfile1="%~2""		rem dump filename
set "cmdfile2="%~3""		rem diff filename (NAND)
set /a argument1=%4 2>nul	rem qtty of dumps
set "argument2=%5"			rem compare dumps / write perfw arg

rem ChangeColor 14 0
echo.
echo *******************************************************************************
echo                       WAY-launchers v2.04, by littlebalup
echo *******************************************************************************
echo.
rem ChangeColor 10 0

REM echo command : %command%
REM echo cmdfile1 : %cmdfile1%
REM echo cmdfile2 : %cmdfile2%
REM echo argument1 : %argument1%
REM echo argument2 : %argument2%
REM goto end

set path=%systemroot%\system32;%systemroot%\system32\wbem

set MYFILES="%cd%"

if not exist %systemroot%\system32\wbem\wmic.exe goto erreurversion

goto %command%

goto %end%

rem ------------- NOR codes ---------------------------------------------------------

:NORinfo
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
echo.
if not exist %myfiles%\norway.py goto erreurnorwayfile
echo Starting : NORway.py %teensy_port% info
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% info
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:NORdump
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set /a nbr_dump=%argument1%
set "file_name=%cmdfile1%"
rem suite juste pour affichage sans guillemets
for /f "useback tokens=*" %%a in ('%file_name%') do set light_file_name=%%~a
rem 
if %file_name% EQU "" goto erreurfichier
if %nbr_dump% GTR 1 goto NORmultidump
set dump_file_name=%file_name%.bin
set view_file_name=%light_file_name%.bin
echo.
if not exist %myfiles%\norway.py goto erreurnorwayfile
echo Starting : NORway.py %teensy_port% dump "%view_file_name%"
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% dump %dump_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
echo Dump saved as :
echo "%view_file_name%"
echo.
goto end
:NORmultidump
set /a VAR=0
:NORdmpretour 
if %VAR%==%nbr_dump% goto NORdmpfin
set /a VAR=VAR+1
set dump_file_name=%file_name%_%VAR%.bin
set view_file_name=%light_file_name%_%VAR%.bin
echo.
if not exist %myfiles%\norway.py goto erreurnorwayfile
echo Starting : NORway.py %teensy_port% dump "%view_file_name%"
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% dump %dump_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
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
rem ChangeColor 7 0
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
fc /b %file_name%_%loop%.bin %file_name%_%VAR%.bin >> %file_path%\compare_log.txt
if %errorlevel%==0 echo %light_file_name%_%loop%.bin same as %light_file_name%_%VAR%.bin
if %errorlevel%==1 echo %light_file_name%_%loop%.bin different from %light_file_name%_%VAR%.bin
if %errorlevel%==1 (set /a errorresult=%errorlevel%)
if %errorlevel%==2 (set /a errorfile=%errorlevel%)
goto NORchkretour
:NORchkfin
echo. >> %file_path%\compare_log.txt
echo END >> %file_path%\compare_log.txt
set /a errorcode = %errorfile%%errorresult%
echo Done.
echo -------------------------------------------------------------------------------
rem ChangeColor 10 0
echo.
if %errorcode%==0 echo Dumps are identical. Details in file compare_log.txt.
if %errorcode%==1 goto erreurbincheck
if %errorcode%==20 goto erreurbincheckfile
if %errorcode%==21 goto erreurbincheckfile
goto end

:NORwrite
set perfw=
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichierNOR
echo.
if not exist %myfiles%\norway.py goto erreurnorwayfile
if %argument2% EQU True (set "perfw=perfw")
echo Starting : NORway.py %teensy_port% write %file_name% %perfw%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% write %file_name% %perfw%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:NORvwrite
set perfw=
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichierNOR
echo.
if not exist %myfiles%\norway.py goto erreurnorwayfile
if %argument2% EQU True (set "perfw=perfw")
echo Starting : NORway.py %teensy_port% vwrite %file_name% %perfw%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% vwrite %file_name% %perfw%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:NORwriteword
set perfw=
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichierNOR
echo.
if not exist %myfiles%\norway.py goto erreurnorwayfile
if %argument2% EQU True (set "perfw=perfw")
echo Starting : NORway.py %teensy_port% writeword %file_name% %perfw%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% writeword %file_name% %perfw%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:NORvwriteword
set perfw=
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichierNOR
echo.
if not exist %myfiles%\norway.py goto erreurnorwayfile
if %argument2% EQU True (set "perfw=perfw")
echo Starting : NORway.py %teensy_port% vwriteword %file_name% %perfw%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% vwriteword %file_name% %perfw%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:NORwritewordubm
set perfw=
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichierNOR
echo.
if not exist %myfiles%\norway.py goto erreurnorwayfile
if %argument2% EQU True (set "perfw=perfw")
echo Starting : NORway.py %teensy_port% writewordubm %file_name% %perfw%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% writewordubm %file_name% %perfw%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:NORvwritewordubm
set perfw=
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichierNOR
echo.
if not exist %myfiles%\norway.py goto erreurnorwayfile
if %argument2% EQU True (set "perfw=perfw")
echo Starting : NORway.py %teensy_port% vwritewordubm %file_name% %perfw%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% vwritewordubm %file_name% %perfw%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:NORverify
set perfw=
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==16777216 goto erreurtaillefichierNOR
echo.
if not exist %myfiles%\norway.py goto erreurnorwayfile
if %argument2% EQU True (set "perfw=perfw")
echo Starting : NORway.py %teensy_port% verify %file_name% %perfw%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% verify %file_name% %perfw%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:NORrelease
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
echo.
if not exist %myfiles%\norway.py goto erreurnorwayfile
echo Starting : NORway.py %teensy_port% release
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% release
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:NORerasechip
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
echo.
if not exist %myfiles%\norway.py goto erreurnorwayfile
echo Starting : NORway.py %teensy_port% erasechip
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\norway.py %teensy_port% erasechip
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end


rem ------------- NAND codes ---------------------------------------------------------

:NANDinfo
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
echo.
if not exist %myfiles%\nandway.py goto erreurnandwayfile
echo Starting : NANDway.py %teensy_port% 0 info
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py %teensy_port% 0 info
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:NANDdump
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set /a nbr_dump=%argument1%
set "file_name=%cmdfile1%"
rem suite juste pour affichage sans guillemets
for /f "useback tokens=*" %%a in ('%file_name%') do set light_file_name=%%~a
rem 
if %file_name% EQU "" goto erreurfichier
if %nbr_dump% GTR 1 goto NANDmultidump
set dump_file_name=%file_name%.bin
set view_file_name=%light_file_name%.bin
echo.
if not exist %myfiles%\nandway.py goto erreurnandwayfile
echo Starting : NANDway.py %teensy_port% 0 dump "%view_file_name%"
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py %teensy_port% 0 dump %dump_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
echo Dump saved as :
echo "%view_file_name%"
echo.
goto end
:NANDmultidump
set /a VAR=0
:NANDdmpretour 
if %VAR%==%nbr_dump% goto NANDdmpfin
set /a VAR=VAR+1
set dump_file_name=%file_name%_%VAR%.bin
set view_file_name=%light_file_name%_%VAR%.bin
echo.
if not exist %myfiles%\nandway.py goto erreurnandwayfile
echo Starting : NANDway.py %teensy_port% 0 dump "%view_file_name%"
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py %teensy_port% 0 dump %dump_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
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
rem ChangeColor 7 0
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
fc /b %file_name%_%loop%.bin %file_name%_%VAR%.bin >> %file_path%\compare_log.txt
if %errorlevel%==0 echo %light_file_name%_%loop%.bin same as %light_file_name%_%VAR%.bin
if %errorlevel%==1 echo %light_file_name%_%loop%.bin different from %light_file_name%_%VAR%.bin
if %errorlevel%==1 (set /a errorresult=%errorlevel%)
if %errorlevel%==2 (set /a errorfile=%errorlevel%)
goto NANDchkretour
:NANDchkfin
echo. >> %file_path%\compare_log.txt
echo END >> %file_path%\compare_log.txt
set /a errorcode = %errorfile%%errorresult%
echo Done.
echo -------------------------------------------------------------------------------
rem ChangeColor 10 0
echo.
if %errorcode%==0 echo Dumps are identical. Details in file compare_log.txt.
if %errorcode%==1 goto erreurbincheck
if %errorcode%==20 goto erreurbincheckfile
if %errorcode%==21 goto erreurbincheckfile
goto end

:NANDwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==138412032 goto erreurtaillefichierNAND
echo.
if not exist %myfiles%\nandway.py goto erreurnandwayfile
echo Starting : NANDway.py %teensy_port% 0 write %file_name%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py %teensy_port% 0 write %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:NANDvwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
for %%A in (%file_name%) do set filesize=%%~zA
if not %filesize%==138412032 goto erreurtaillefichierNAND
echo.
if not exist %myfiles%\nandway.py goto erreurnandwayfile
echo Starting : NANDway.py %teensy_port% 0 vwrite %file_name%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py %teensy_port% 0 vwrite %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:NANDdiffwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
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
if not exist %myfiles%\nandway.py goto erreurnandwayfile
echo Starting : NANDway.py %teensy_port% 0 diffwrite %file_name%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py %teensy_port% 0 diffwrite %file_name% %diff_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:NANDvdiffwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
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
if not exist %myfiles%\nandway.py goto erreurnandwayfile
echo Starting : NANDway.py %teensy_port% 0 vdiffwrite %file_name%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py %teensy_port% 0 vdiffwrite %file_name% %diff_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
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
if not exist %myfiles%\nandway.py goto erreurnandwayfile
echo Starting : NANDway.py ps3badblocks %file_name%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\nandway.py ps3badblocks %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end


rem ------------- SPI codes ---------------------------------------------------------

:SPIinfo
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
echo.
if not exist %myfiles%\spiway.py goto erreurspiwayfile
echo Starting : SPIway.py %teensy_port% info
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\spiway.py %teensy_port% info
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:SPIdump
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set /a nbr_dump=%argument1%
set "file_name=%cmdfile1%"
rem suite juste pour affichage sans guillemets
for /f "useback tokens=*" %%a in ('%file_name%') do set light_file_name=%%~a
rem 
if %file_name% EQU "" goto erreurfichier
if %nbr_dump% GTR 1 goto SPImultidump
set dump_file_name=%file_name%.bin
set view_file_name=%light_file_name%.bin
echo.
if not exist %myfiles%\spiway.py goto erreurspiwayfile
echo Starting : SPIway.py %teensy_port% dump "%view_file_name%"
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\spiway.py %teensy_port% dump %dump_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
echo Dump saved as :
echo "%view_file_name%"
echo.
goto end
:SPImultidump
set /a VAR=0
:SPIdmpretour 
if %VAR%==%nbr_dump% goto SPIdmpfin
set /a VAR=VAR+1
set dump_file_name=%file_name%_%VAR%.bin
set view_file_name=%light_file_name%_%VAR%.bin
echo.
if not exist %myfiles%\spiway.py goto erreurspiwayfile
echo Starting : SPIway.py %teensy_port% dump "%view_file_name%"
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\spiway.py %teensy_port% dump %dump_file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
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
rem ChangeColor 7 0
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
fc /b %file_name%_%loop%.bin %file_name%_%VAR%.bin >> %file_path%\compare_log.txt
if %errorlevel%==0 echo %light_file_name%_%loop%.bin same as %light_file_name%_%VAR%.bin
if %errorlevel%==1 echo %light_file_name%_%loop%.bin different from %light_file_name%_%VAR%.bin
if %errorlevel%==1 (set /a errorresult=%errorlevel%)
if %errorlevel%==2 (set /a errorfile=%errorlevel%)
goto SPIchkretour
:SPIchkfin
echo. >> %file_path%\compare_log.txt
echo END >> %file_path%\compare_log.txt
set /a errorcode = %errorfile%%errorresult%
echo Done.
echo -------------------------------------------------------------------------------
rem ChangeColor 10 0
echo.
if %errorcode%==0 echo Dumps are identical. Details in file compare_log.txt.
if %errorcode%==1 goto erreurbincheck
if %errorcode%==20 goto erreurbincheckfile
if %errorcode%==21 goto erreurbincheckfile
goto end

:SPIwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
echo.
if not exist %myfiles%\spiway.py goto erreurspiwayfile
echo Starting : SPIway.py %teensy_port% write %file_name%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\spiway.py %teensy_port% write %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:SPIvwrite
set file_name=
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
set "file_name=%cmdfile1%"
if not exist %file_name% goto erreurfichier
if %file_name% EQU "" goto erreurfichier
echo.
if not exist %myfiles%\spiway.py goto erreurspiwayfile
echo Starting : SPIway.py %teensy_port% vwrite %file_name%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\spiway.py %teensy_port% vwrite %file_name%
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end

:SPIerasechip
set teensy_port=
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Abstract Control Model%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
for /f "usebackq" %%B in (`wmic path Win32_SerialPort Where "Description LIKE '%%Teensy USB Serial%%'" 2^>nul Get DeviceID ^| FIND "COM"`) do set teensy_port=%%B
echo.
if "%teensy_port%" NEQ "" (echo Teensy found on port %teensy_port%) else (goto erreurteensy)
echo.
echo.
if not exist %myfiles%\spiway.py goto erreurspiwayfile
echo Starting : SPIway.py %teensy_port% erasechip
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\spiway.py %teensy_port% erasechip
echo -------------------------------------------------------------------------------
echo.
if %errorlevel% NEQ 0 goto erreur
rem ChangeColor 10 0
goto end


rem ------------- hex load to teensy -------------------------------------------------

:TeensyLoad
echo.
echo Starting : teensy_loader_cli -mmcu=at90usb1286 -w -v %cmdfile1%
echo.
rem ChangeColor 7 0
echo -------------------------------------------------------------------------------
%myfiles%\teensy_loader_cli -mmcu=at90usb1286 -w -v %cmdfile1%
echo -------------------------------------------------------------------------------
rem ChangeColor 10 0
echo.
echo Done
echo.
goto end


rem ------------- error codes ---------------------------------------------------------

:erreur
rem ChangeColor 12 0
echo An error occurred. Verify your installation.
rem ChangeColor 10 0
goto end

:erreurteensy
rem ChangeColor 12 0
echo Error : Teensy not found.
echo Command aborted.
rem ChangeColor 10 0
goto end

:erreurfichier
rem ChangeColor 12 0
echo Error : File %file_name% not found.
echo Command aborted.
rem ChangeColor 10 0
goto end

:erreurfichiertxt
rem ChangeColor 12 0
echo Error : File %diff_file_name% not found.
echo Command aborted.
rem ChangeColor 10 0
goto end

:erreurtaillefichierNOR
rem ChangeColor 12 0
echo Error : Size of %file_name% is %filesize% Bytes.
echo Should be 16777216 Bytes (16384 KB).
echo Command aborted.
rem ChangeColor 10 0
goto end

:erreurtaillefichierNAND
rem ChangeColor 12 0
echo Error : Size of %file_name% is %filesize% Bytes.
echo Should be 138412032 Bytes (135168 KB).
echo Command aborted.
rem ChangeColor 10 0
goto end

:erreurversion
rem ChangeColor 12 0
echo Error : This program needs Windows XP(pro)/Vista/7/8.
echo It is incompatible with your system.
echo Command aborted.
rem ChangeColor 10 0
goto end

:erreurnorwayfile
rem ChangeColor 12 0
echo Error : NORway.py file not found.
echo Command aborted.
rem ChangeColor 10 0
goto end

:erreurnandwayfile
rem ChangeColor 12 0
echo Error : NANDway.py file not found.
echo Command aborted.
rem ChangeColor 10 0
goto end

:erreurspiwayfile
rem ChangeColor 12 0
echo Error : SPIway.py file not found.
echo Command aborted.
rem ChangeColor 10 0
goto end

:erreurbincheck
rem ChangeColor 12 0
echo Attention : one or more dumps are different. Details in file compare_log.txt.
rem ChangeColor 10 0
goto end

:erreurbincheckfile
rem ChangeColor 12 0
echo Error : one or more files not found.
rem ChangeColor 10 0
goto end

:end
echo.
echo End.
echo Press any key to exit...
pause >nul
exit
