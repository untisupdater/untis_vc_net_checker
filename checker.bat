@echo off








REM #################################################################










REM ## soll ich die Abhängigkeiten herunterladen die fehlen ?      ##
REM ##            v entsprechend auf 0/1 setzen                    ##
SET allowdownload=1










REM ## ist Untis auf diesem Rechner lokal installiert ? ##
REM ##            v entsprechend auf 0/1 setzen                    ##
SET untislokal=0














REM #################################################################













































REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM
REM           !!! AB HIER NICHTS MEHR ANPASSEN !!!
REM
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
REM ########################################################
cls
set versionsnummer=0.01
setlocal

echo.
echo.
echo.
echo.
echo.






echo ####################################################








echo.











echo > %appdata%/untisversionschecker.txt 2>nul
echo > %appdata%/untisversionschecker_error.txt 2>nul
set runtime15_a=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\DevDiv\vc\Servicing\14.0\RuntimeMinimum
set runtime15_b=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\DevDiv\vc\Servicing\14.0\RuntimeMinimum
set runtime15_c=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\DevDiv\VC\Servicing\14.0\RuntimeMinimum
reg query "%runtime15_a%" /v Version >> %appdata%/untisversionschecker.txt 2>nul
if %ERRORLEVEL% EQU 0 (
    goto runtime_success1
)
reg query "%runtime15_b%" /v Version >> %appdata%/untisversionschecker.txt 2>nul
if %ERRORLEVEL% EQU 0 (
    goto runtime_success2
)
reg query "%runtime15_c%" /v Version >> %appdata%/untisversionschecker.txt 2>nul
if %ERRORLEVEL% EQU 0 (
    goto runtime_success3
)
goto runtime_fehler
:runtime_success1
echo [SUCCESS1]: Microsoft Visual C++ 2015 Redistributable Package found! Good!
reg query "%runtime15_a%" /v Version
echo Microsoft C++ 2015 runtime sollte Version 14.34.31938 sein
goto runtime_end
:runtime_success2
echo [SUCCESS2]: Microsoft Visual C++ 2015 Redistributable Package found! Good!
reg query "%runtime15_b%" /v Version
echo Microsoft C++ 2015 runtime sollte Version 14.34.31938 sein
goto runtime_end
:runtime_success3
echo [SUCCESS3]: Microsoft Visual C++ 2015 Redistributable Package found! Good!
reg query "%runtime15_c%" /v Version
echo Microsoft C++ 2015 runtime sollte Version 14.34.31938 sein
goto runtime_end
:runtime_fehler
if %allowdownload% == 1 (
    start "" https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170
)
del %appdata%/untisversionschecker.txt 2>nul
del %appdata%/untisversionschecker_error.txt 2>nul
:runtime_end


echo.
echo ####################################################
echo.

reg query "HKLM\SOFTWARE\Microsoft\Net Framework Setup\NDP\v4\Full" /v "Version" >> %appdata%/untisversionschecker.txt 2>nul
if %ERRORLEVEL% EQU 0 (
    goto dotnet_success
)

if %allowdownload% == 1 (
    start "" https://dotnet.microsoft.com/en-us/download/dotnet-framework/net471
)  
goto cpp_ende

:dotnet_success
echo [SUCCESS]: Microsoft .NET Framework 4.7.1 Package found! Good! (muss Version 4.7.1 oder hoeher sein):
reg query "HKLM\SOFTWARE\Microsoft\Net Framework Setup\NDP\v4\Full" /v "Version"
:cpp_ende

echo ####################################################
echo.

set curlpath=c:\Windows\System32\curl.exe
set downloadfile=https://www.untis.at/support/hilfe-und-service/aktuelle-versionsdownloads-und-updates/untis-/-untis-express-2023/index.php
%curlpath% -o %appdata%\version_2023.txt -L %downloadfile% >nul 2>nul
(type %appdata%\version_2023.txt | find "Version: ") >%appdata%\version2_2023.txt
for /f "tokens=1,2 delims= " %%a in (%appdata%\version2_2023.txt) do (	
	echo %%b>%appdata%\versionsnummer.txt
)

SET /P versionsnummeronline=<%appdata%\versionsnummer.txt
del %appdata%\versionsnummer.txt
del %appdata%\version_2023.txt
del %appdata%\version2_2023.txt







SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "tokens=3* skip=2" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Gruber&Petters\Untis 2023" /v "Version"') do (set installiertversionsnummer1=%%a)
if %ERRORLEVEL% EQU 0 (
    goto untis23_success
) else (
	if [%installiertversionsnummer1%]==[] (
		echo [ERROR]: Untis 2023 NOT found!
		echo Untis Version online : %versionsnummeronline%
	)
) 



















if %allowdownload% == 1 (
    start "" https://www.untis.at/fileadmin/downloads/2023/SetupUntis2023.exe
)  





goto ende

:untis23_success
echo [SUCCESS]: Untis 2023 found!





echo Untis Version installiert : %installiertversionsnummer1%
echo Untis Version online : %versionsnummeronline%
echo.

goto ende


:ende
del %appdata%\untisversionschecker.txt 2>nul
del %appdata%\untisversionschecker_error.txt 2>nul
endlocal



PAUSE
PAUSE