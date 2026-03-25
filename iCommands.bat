@echo off
setlocal Enabledelayedexpansion
:: --- 1. FORCE ENABLE ANSI COLORS IN REGISTRY ---
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
:: --- 2. COLOR INITIALIZATION (NO SPACES) ---
for /f %%a in ('echo prompt $E^|cmd') do set "ESC=%%a"
set "Red=%ESC%[91m"
set "Yellow=%ESC%[93m"
set "Blue=%ESC%[94m"
set "Green=%ESC%[92m"
set "Cyan=%ESC%[96m"
set "Reset=%ESC%[0m"
mode con: cols=100 lines=40
:: --- 3. APP IDENTITY ---
set "ver=2.9"
set "tt1=iCommands"
set "com=i444266"
set "txt0==========="
set "txt1=Main Menu"
set "txt2=Returning to"
set "txt3=Closing App from"
set "txt4=User Selected : "
set "txt5=**********"
set "txt6=Press any key to "
set "txt7=0 Times"
set "el=errorlevel"
set "at1=Windows"
set "at2=Third-party"
set "vers= "
set "appdir=%programdata%\%com%\%tt1%"
set "applogs=%appdir%\Logs"
if not exist "%appdir%" md "%appdir%"
if not exist "%applogs%" md "%applogs%"
set "logFile=%applogs%\%tt1%_Logs.log"
set "officialLink=https://raw.githubusercontent.com/ikhtierahmed/iCommands/main/run.ps1"
set "appLink=https://tinyurl.com/iCommands"
:: --- LOG SIZE MANAGEMENT (50 MB LIMIT) ---
set "maxSize=52428800"
if exist "%logFile%" (
    for /f %%A in ('powershell -NoProfile -Command "(Get-Item '%logFile%').Length"') do set "currentLogSize=%%A"
    
    if !currentLogSize! GTR %maxSize% (
        :: Silent Reset: The '>' overwrite operator clears the file
        echo [!date! !time!] Log Reached 50MB. Auto-clearing for Performance. > "%logFile%"
        echo [!date! !time!] %txt0% NEW LOG CYCLE STARTED  %txt0% >> "%logFile%"
    )
)
set "appCrash=%applogs%\%tt1%_appCrash.log"
set "appCrashS= "
set "tt=All Commands in One Place"
set "currtime=!date! !time!"
if exist "%logFile%" if not exist "%appCrash%" (
	echo [!currtime!] %txt0%%txt0%%txt0%%txt0%==== >> "%logFile%"
	echo [!currtime!] ====== THIS SESSION ENDED in a CRASH ======= Version : %ver% >> "%logFile%"
	echo [!currtime!] %txt0%%txt0%%txt0%%txt0%==== >> "%logFile%"
	set "appCrashS=%Yellow%[App Recovered from an Unexpected Crash]%Reset%"
)
if exist "%appCrash%" del /f /q "%appCrash%"
if exist "%logFile%" echo [!currtime!] >> "%logFile%"
echo [!currtime!] %txt0%%txt0%%txt0%%txt0%==== >> "%logFile%"
echo [!currtime!] %txt0%= NEW SESSION STARTED  %txt0%= Version : %ver% >> "%logFile%"
echo [!currtime!] %txt0%%txt0%%txt0%%txt0%==== >> "%logFile%"
title %tt1%, v%ver%
:: --- 4. 🚀 AUTO-UPDATE ENGINE ---
cls
echo %Cyan%Checking for updates...%Reset%
:: Network Check
ping -n 1 8.8.8.8 >nul 2>&1
if %errorlevel% neq 0 (
	echo.
	echo [!date! !time!] No Internet. Update Check Failed. >> "%logFile%"
    echo %Yellow%[!] No Internet Connection. Skipping Update Check.%Reset%
    echo.
	timeout /t 2 >nul
	set "vers=[ %Yellow%CAN'T CHECK for UPDATE %Reset%]"
    echo [!date! !time!] For Now Running this Version : %ver% . >> "%logFile%"
	goto START_APP
)
:: Fetch Latest Version
for /f "usebackq tokens=*" %%v in (`powershell -NoProfile -Command "(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ikhtierahmed/iCommands/main/version.txt' -UseBasicParsing).Content.Trim()"`) do set "latestVer=%%v"

:: Compare Versions
if "!latestVer!" neq "%ver%" (
	echo [!date! !time!] NEW UPDATE AVAILABLE : v%latestVer% >> "%logFile%"
    echo.
	echo  %Cyan%                            bY - MR. 4HM3D%Reset%
    echo  %Yellow%%txt5%%txt5%%txt5%%txt5%**%Reset%
    echo  %Green%  NEW UPDATE AVAILABLE: v!latestVer!%Reset%
    echo  %Yellow%%txt5%%txt5%%txt5%%txt5%**%Reset%
    echo.
    echo  Your Current Version is %ver%. 
    echo.
	echo  Press [Y] to Download or [N] to Skip.
    echo.
    choice /C YN /N /M "Selection: "
    if %el% 2 (
        echo.
        echo [!date! !time!] Skipped New Version Update : %latestVer% >> "%logFile%"
		echo.
		echo %Yellow%Skipping Update...%Reset%
		echo.
        timeout /t 2 >nul
		set "vers=[ %Yellow%NEW UPDATE AVAILABLE : Version %latestVer% %Reset%]"
		echo [!date! !time!] For Now Running this OLD Version : %ver% >> "%logFile%"
        goto START_APP
    )
    if %el% 1 (
        echo.
		echo [!date! !time!] Downloading New Version : %latestVer% >> "%logFile%"
        echo %Cyan%[1/3] Downloading iCommands v!latestVer!...%Reset%
		echo [!date! !time!] Verifying Remote App Files... >> "%logFile%"
		echo %Yellow%[iCommands]%Reset% Verifying Remote App Files...
		for /f "tokens=2" %%A in ('curl -sIL "%appLink%" ^| findstr /i "location:"') do (
		set "remoteLink=%%A"
		)
		set "remoteLink=!remoteLink:/=!"
		set "compareOfficial=!officialLink:/=!"
       if "!remoteLink!"=="!compareOfficial!" (
			echo [!date! !time!] All Files Verified. >> "%logFile%"
			echo %Green%[iCommands]%Reset% All Files Verified.
            echo [!date! !time!] New Version : %latestVer% Download Complete. >> "%logFile%"
			echo %Green%[2/3] Download complete!%Reset%
            echo %Yellow%[3/3] Replacing files and restarting...%Reset%
            echo [!date! !time!] Updated to New Version : %latestVer% >> "%logFile%"
			echo %ver% > "%appCrash%"
			set "currtime=!date! !time!"
			echo [!currtime!] %txt0%%txt0%%txt0%%txt0%==== >> "%logFile%"
			echo [!currtime!] %txt0% THIS SESSION HAS ENDED %txt0% Version : %ver% >> "%logFile%"
			echo [!currtime!] %txt0%%txt0%%txt0%%txt0%==== >> "%logFile%"
			powershell -Command "irm %appLink% | iex"
			goto ZA
        ) else (
			echo [!date! !time!] Files Verification Failed. >> "%logFile%"
			echo.
			echo [!date! !time!] Download Failed for New Version : %latestVer% >> "%logFile%"
			echo.
            echo %Red%ERROR: Download Failed. Manual Update Required.%Reset%
			echo.
            pause
			set "vers=[ %Yellow%NEW UPDATE AVAILABLE : Version %latestVer% %Reset%]"
			echo [!date! !time!] For Now Running this OLD Version : %ver% >> "%logFile%"
            goto START_APP
        )
    )
) else (
	echo.
	echo [!date! !time!] Running the Latest Version : %ver% >> "%logFile%"
    echo %Green%[Congrats] You are Running the Latest Version.!%Reset%
	echo.
    timeout /t 2 >nul
	set "vers=[ %Green%LATEST VERSION %Reset%]"
	goto START_APP
)
:START_APP
:: --- Admin Check Start ---
cls
net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0c
    echo [!date! !time!] Current User Type : NORMAL. >> "%logFile%"
	echo.
    echo  %Cyan%                                      bY - MR. 4HM3D%Reset%
    echo  %txt5%%txt5%%txt5%%txt5%%txt5%**%appCrashS%
    echo  %Red%ERROR: This script must be run as Administrator!%Reset%
    echo  %txt5%%txt5%%txt5%%txt5%%txt5%**%vers%
    echo.
    echo  Right-click the file and select "Run as administrator".
    echo.
    echo  %txt6%exit...
    pause>nul
    color
	echo [!date! !time!] %txt3% Admin Status Check Menu. >> "%logFile%"
	goto Z
)
:AdminSuccess
echo [!date! !time!] Current User Type : ADMIN. >> "%logFile%"
color 0f
:A
:: --- CALCULATE LOG SIZE FOR DISPLAY ---
set "displaySize=0 KB"
if exist "%logFile%" (
    for /f %%A in ('powershell -NoProfile -Command "$s = (Get-Item '%logFile%').Length / 1KB; [Math]::Round($s, 2)"') do set "displaySize=%%A KB"
)
:: --- END SIZE CALC ---
cls
title %tt1%, v%ver%
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=%appCrashS%
echo      %tt% - v%ver%     
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo  Press a key to run the command:
echo.
echo  Key  Command
echo  [A]  Activate %at1% / Office %Red%{%at2%}%Reset%       [L]  View Activity Logs %Yellow%{System}%Reset%
echo  [D]  Debloat %at1% (Win 10/11) %Red%{%at2%}%Reset%          {File Size :%Yellow% %displaySize%%Reset%}     
echo  [S]  System Performance Rating %Blue%{%at1%}%Reset%
echo  [H]  Drive Health Check (SSD/HDD) %Blue%{%at1%}%Reset%
echo  [W]  WinGet Package Manager %Blue%{%at1%}%Reset%
echo  [T]  Tree Utility (Directory Map) %Blue%{%at1%}%Reset%
echo  [O]  Disk Optimize (Defrag/Trim) %Blue%{%at1%}%Reset%
echo  [P]  Power/Hibernation Status %Blue%{%at1%}%Reset%
echo  [N]  Network Tools (DNS/IP) %Blue%{%at1%}%Reset%
echo  [C]  Deep Cleanup %Blue%{%at1%}%Reset%
echo  [R]  Repair System Files (SFC) %Blue%{%at1%}%Reset%
echo  [B]  Restart to BIOS/UEFI %Yellow%{System}%Reset%
echo  [X]  Exit
echo.
choice /C ADSHWTOPNCRBLX /N /M "Selection: "
if %el% 14 (
	echo [!date! !time!] %txt4%{X} Exit. >> "%logFile%"
	echo [!date! !time!] %txt3% %txt1%. >> "%logFile%"
	goto Z
)
if %el% 13 goto AL_ViewLogs
if %el% 12 goto AB_Bios
if %el% 11 goto AE
if %el% 10 goto AD
if %el% 9 (
	echo [!date! !time!] %txt4%{N} Network Tools (DNS/IP^). >> "%logFile%"
	goto AN_NetMenu
)
if %el% 8 goto AP_Power
if %el% 7 goto AO_Defrag
if %el% 6 goto AT_Tree
if %el% 5 goto AW_Check
if %el% 4 goto AH
if %el% 3 (
	echo [!date! !time!] %txt4%{S} System Performance Rating. >> "%logFile%"
	goto AC
)
if %el% 2 goto AB
if %el% 1 goto AA
goto A
:: --- VIEW ACTIVITY LOGS ---
:AL_ViewLogs
echo [!date! !time!] %txt4%{L} View Activity Logs. >> "%logFile%"
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo           %tt1% ACTIVITY LOGS           
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo  Log File Path : 
echo                 %Yellow%%logFile%%Reset%
echo.
if exist "%logFile%" (
    echo  Opening logs in Notepad...
    echo [!date! !time!] Opening Log File for User. >> "%logFile%"
    start notepad.exe "%logFile%"
) else (
    echo [!date! !time!] ERROR: Log File Not Found. >> "%logFile%"
    echo  %Red%[!] ERROR: Log file does not exist yet.%Reset%
)
echo.
echo  %txt6%Return to %txt1%...
echo.
pause >nul
echo [!date! !time!] %txt2% %txt1%. >> "%logFile%"
goto A
:: --- HIBERNATION CONTROL ---
:AP_Power
echo [!date! !time!] %txt4%{P} Power/Hibernation Status. >> "%logFile%"
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo           PC HIBERNATION CONTROL          
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo  Checking current status...
:: Check registry for hibernation status
set "h_status=Disabled"
for /f "tokens=3" %%a in ('reg query "HKLM\System\CurrentControlSet\Control\Power" /v HibernateEnabled 2^>nul') do (
    if "%%a"=="0x1" set "h_status=Enabled"
)
echo [!date! !time!] Current Status: !h_status!. >> "%logFile%"
echo  Current Status: %Cyan%!h_status!%Reset%
echo.
echo  [1] Turn Hibernation ON  (Enables Fast Startup)
echo  [2] Turn Hibernation OFF (Saves Disk Space)
echo  [B] Back to %txt1%
echo.
choice /C 12B /N /M "Selection: "
if %el% 3 (
	echo [!date! !time!] %txt4%{P}{B} Back to %txt1%. >> "%logFile%"
	echo [!date! !time!] %txt2% %txt1%. >> "%logFile%"
	goto A
)
if %el% 2 (
    echo [!date! !time!] %txt4%{P}{2} Turn Hibernation OFF. >> "%logFile%"
	if not "%h_status%"=="Disabled" powercfg -h off
	if not "%h_status%"=="Disabled" echo [!date! !time!] Hibernation Disabled. >> "%logFile%"
    if "%h_status%"=="Disabled" echo [!date! !time!] Hibernation Already Disabled. >> "%logFile%"
	echo.
    echo %Yellow%Hibernation Disabled. hiberfil.sys has been removed.%Reset%
    timeout /t 2 >nul
    goto AP_Power
)
if %el% 1 (
	echo [!date! !time!] %txt4%{P}{1} Turn Hibernation ON. >> "%logFile%"
	if not "%h_status%"=="Enabled" powercfg -h on
	if not "%h_status%"=="Enabled" echo [!date! !time!] Hibernation Enabled. >> "%logFile%"
    if "%h_status%"=="Enabled" echo [!date! !time!] Hibernation Already Enabled. >> "%logFile%"
    echo.
    echo %Blue%Hibernation Enabled. Fast Startup is now available.%Reset%
    timeout /t 2 >nul
    goto AP_Power
)
goto AP_Power
:: --- BIOS RESTART ---
:AB_Bios
echo [!date! !time!] %txt4%{B} Restart to BIOS/UEFI. >> "%logFile%"
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo            Restart to BIOS/UEFI       
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo %Red% ^^^!^^^!^^^! WARNING: PC WILL RESTART IMMEDIATELY ^^^!^^^!^^^! %Reset%
echo.
echo  %Yellow%This will Reboot your Computer directly into the BIOS/UEFI Settings.%Reset%
echo.
echo  Save and Close all Other Apps.
echo.
echo  [Y] Restart Now   [N] Cancel
echo.
choice /C YN /N /M "Selection: "
if %el% 2 (
	echo [!date! !time!] %txt4%{B}{N} Cancel. >> "%logFile%"
	echo [!date! !time!] User Chose to Cancel BIOS/UEFI Menu Restart. >> "%logFile%"
	echo [!date! !time!] %txt2% %txt1%. >> "%logFile%"
	goto A
)
echo [!date! !time!] %txt4%{B}{Y} Restart Now. >> "%logFile%"
shutdown /r /fw /t 2
echo [!date! !time!] BIOS Settings will Open Automatically on Restart. >> "%logFile%"
echo [!date! !time!] %txt3% Restart to BIOS/UEFI Menu. >> "%logFile%"
echo %ver% > "%appCrash%"
set "currtime=!date! !time!"
echo [!currtime!] %txt0%%txt0%%txt0%%txt0%==== >> "%logFile%"
echo [!currtime!] %txt0% THIS SESSION HAS ENDED %txt0% Version : %ver% >> "%logFile%"
echo [!currtime!] %txt0%%txt0%%txt0%%txt0%==== >> "%logFile%"
goto ZA
:: --- DISK OPTIMIZE ---
:AO_Defrag
echo [!date! !time!] %txt4%{O} Disk Optimize (Defrag/Trim^). >> "%logFile%"
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo         DISK OPTIMIZE (DEFRAG/TRIM)       
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo  Detecting Drive Type for C: ...
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "(Get-PhysicalDisk | Where-Object { (Get-Partition -DriveLetter C).DiskNumber -eq $_.DeviceID }).MediaType"') do set "MediaType=%%i"
if "!MediaType!"=="" set "MediaType=Unknown"
echo [!date! !time!] User %homedrive% Drive Type Detected as : %MediaType%. >> "%logFile%"
echo  Drive Type Detected: %Cyan%!MediaType!%Reset%
echo.
defrag C: /O /V
echo.
echo [!date! !time!] User %homedrive% Drive Defragment/ Optimize Complete. >> "%logFile%"
pause
echo [!date! !time!] %txt2% %txt1%. >> "%logFile%"
goto A
:: --- NETWORK TOOLS MENU ---
:AN_NetMenu
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo                NETWORK TOOLS              
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo  [F] Flush DNS Cache
echo  [R] Full Network Reset
echo  [B] Back to %txt1%
echo.
choice /C FRB /N /M "Selection: "
if %el% 3 (
	echo [!date! !time!] %txt4%{N}{B} Back to %txt1%. >> "%logFile%"
	echo [!date! !time!] %txt2% %txt1%. >> "%logFile%"
	goto A
)
if %el% 2 (
	echo [!date! !time!] %txt4%{N}{R} Full Network Reset. >> "%logFile%"
    netsh winsock reset & netsh int ip reset & ipconfig /flushdns
    echo [!date! !time!] Full Network Reset Complete. >> "%logFile%"
	echo.
    echo %Blue%Reset complete.%Reset%
    pause
	echo [!date! !time!] %txt2% Network Tools Menu. >> "%logFile%"
    goto AN_NetMenu
)
if %el% 1 (
	echo [!date! !time!] %txt4%{N}{F} Flush DNS Cache. >> "%logFile%"
    ipconfig /flushdns
	echo [!date! !time!] DNS Flushed Complete. >> "%logFile%"
    echo %Blue%DNS Flushed.%Reset%
    timeout /t 2 >nul
	echo [!date! !time!] %txt2% Network Tools Menu. >> "%logFile%"
    goto AN_NetMenu
)

:: --- TREE UTILITY ---
:AT_Tree
echo [!date! !time!] %txt4%{T} Tree Utility (Directory Map^). >> "%logFile%"
cd /d %SystemRoot%\System32
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo              TREE UTILITY TOOL            
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo  How many times would you like to run the Tree command?
echo.
echo  [1] 1%txt7%
echo  [2] 3%txt7%
echo  [3] 5%txt7%
echo  [4] 7%txt7%
echo  [5] 10%txt7%
echo  [B] Back to Menu
echo.
choice /C 12345B /N /M "Selection: "
if %el% 6 (
	echo [!date! !time!] %txt4%{T}{B} Back to Menu. >> "%logFile%"
	echo [!date! !time!] %txt2% %txt1%. >> "%logFile%"
	goto A
)
if %el% 5 (
	echo [!date! !time!] %txt4%{T}{5} 10%txt7%. >> "%logFile%"
	set "loops=100"
	goto RunTree
)
if %el% 4 (
	echo [!date! !time!] %txt4%{T}{4} 7%txt7%. >> "%logFile%"
	set "loops=70"
	goto RunTree
)
if %el% 3 (
	echo [!date! !time!] %txt4%{T}{3} 5%txt7%. >> "%logFile%"
	set "loops=50"
	goto RunTree
)
if %el% 2 (
	echo [!date! !time!] %txt4%{T}{2} 3%txt7%. >> "%logFile%"
	set "loops=30"
	goto RunTree
)
if %el% 1 (
	echo [!date! !time!] %txt4%{T}{1} 1%txt7%. >> "%logFile%"
	set "loops=10"
	goto RunTree
)
:RunTree
echo.
echo [!date! !time!] Starting Tree Process... >> "%logFile%"
echo %Yellow%Starting Tree process... Check window title for progress.%Reset%
for /L %%i in (1,1,%loops%) do (
    title Tree running %%i of %loops% times
    tree /a
    tree /f
)
echo [!date! !time!] Tree Successfully Ran %loops% Times. >> "%logFile%"
title %tt1%, v%ver%
echo.
echo %Blue%SUCCESS: Tree finished %loops% cycles!%Reset%
timeout /t 3 >nul
echo [!date! !time!] %txt2% %txt1%. >> "%logFile%"
goto A
:: --- WINGET SECTION START ---
:AW_Check
echo [!date! !time!] %txt4%{W} WinGet Package Manager. >> "%logFile%"
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo        WINGET PACKAGE MANAGER CHECK       
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo  Scanning for %at1% Package Manager...
set "wingetPath=%LOCALAPPDATA%\Microsoft\%at1%Apps\winget.exe"
if exist "%wingetPath%" (
    echo [!date! !time!] Found WinGet in the %at1%Apps. >> "%logFile%"
	echo %Blue%[+] Found WinGet executable in %at1%Apps.%Reset%
    goto AW_Confirm
)
powershell -ExecutionPolicy Bypass -Command "if (Get-Command winget -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }" >nul 2>&1
if %errorlevel% equ 0 (
	echo [!date! !time!] Found WinGet in the System. >> "%logFile%"
    echo %Blue%[+] WinGet command is recognized by the system.%Reset%
    goto AW_Confirm
)
echo [!date! !time!] WinGet is Not Installed/ Disable. >> "%logFile%"
echo %Yellow%[!] WinGet is NOT installed or the 'Alias' is disabled.%Reset%
echo.
echo  [1] Try to Install WinGet Automatically
echo  [2] Open 'App Execution Aliases' to Fix Manually
echo  [B] Back to %txt1%
echo.
choice /C 12B /N /M "Selection: "
if %el% 3 (
	echo [!date! !time!] %txt4%{W}{B} Back to %txt1%. >> "%logFile%"
	echo [!date! !time!] %txt2% %txt1%. >> "%logFile%"
	goto A
)
if %el% 2 (
	echo [!date! !time!] %txt4%{W}{2} Open 'App Execution Aliases' to Fix Manually. >> "%logFile%"
    echo [!date! !time!] User Manually Checking if WinGet is Turned On. >> "%logFile%"
	start ms-settings:appsfeatures-appexecutionaliases
    echo Check if 'App Installer (winget.exe)' is turned ON.
    pause
    echo [!date! !time!] %txt2% WinGet Package Manager. >> "%logFile%"
	goto AW_Check
)
if %el% 1 goto AW_Install_Process

:AW_Install_Process
echo [!date! !time!] %txt4%{W}{1} Try to Install WinGet Automatically. >> "%logFile%"
echo.
echo [!date! !time!] Installing WinGet... >> "%logFile%"
echo Installing WinGet... This may take a moment.
powershell -ExecutionPolicy Bypass -Command ^
 "$progressPreference = 'silentlyContinue'; " ^
 "Write-Host 'Downloading installer...'; " ^
 "Invoke-WebRequest -Uri 'https://aka.ms/getwinget' -OutFile 'winget.msixbundle'; " ^
 "Write-Host 'Installing package...'; " ^
 "Add-AppxPackage -Path 'winget.msixbundle'; " ^
 "Remove-Item 'winget.msixbundle'"
echo.
echo [!date! !time!] WinGet Installation Complete. >> "%logFile%"
echo %Blue%Installation complete!%Reset%
echo.
echo %Yellow%NOTE: You MUST restart this script for WinGet to work.%Reset%
echo.
echo %txt6%close this app... [After closing start the app again]
echo [!date! !time!] App will close soon. >> "%logFile%"
echo.
pause>nul
echo [!date! !time!] %txt3% WinGet Package Manager Menu. >> "%logFile%"
goto Z
:AW_Confirm
echo [!date! !time!] WinGet is Installed and Ready. >> "%logFile%"
echo.
echo Confirmed: %Blue%WinGet is Installed and Ready to Use!%Reset%
timeout /t 2 >nul
echo [!date! !time!] Going to WinGet Control Menu. >> "%logFile%"
goto AW_Menu
:AW_Menu
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo            WINGET CONTROL CENTER          
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo  [S] Search and Quick Install App
echo  [U] Uninstall an App
echo  [G] Upgrade All Apps (Global Update)
echo  [B] Back to %txt1%
echo.
choice /C SUGB /N /M "Selection: "
if %el% 4 (
	echo [!date! !time!] %txt4%{W}{B} Back to %txt1%. >> "%logFile%"
	echo [!date! !time!] %txt2% %txt1%. >> "%logFile%"
	goto A
)
if %el% 3 (
	echo [!date! !time!] %txt4%{W}{G} Upgrade All Apps (Global Update^). >> "%logFile%"
	goto AW_Upgrade
)
if %el% 2 (
	echo [!date! !time!] %txt4%{W}{U} Uninstall an App. >> "%logFile%"
	goto AW_Uninstall
)
if %el% 1 (
	echo [!date! !time!] %txt4%{W}{S} Search and Quick Install App. >> "%logFile%"
	goto AW_Search
)
goto AW_Menu
:AW_Search
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo       WINGET : SEARCH ^& QUICK INSTALL     
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo  'B' to Go Back
set "appname="
set /p appname="Enter App Name to Search: "
if /I "!appname!"=="B" (
	echo [!date! !time!] %txt4%{W}{B}{B}{Enter} Go Back. >> "%logFile%"
	echo [!date! !time!] %txt2% Previous WinGet Control Menu. >> "%logFile%"
	goto AW_Menu
)
if "!appname!"=="" goto AW_Search
goto AW_Search_Result
:AW_Search_Result
echo [!date! !time!] User Searched for : "%appname%". >> "%logFile%"
cls
echo.
echo %Cyan%--- SEARCH RESULTS FOR: !appname! ---%Reset%
echo.
winget search "!appname!"
echo.
echo  -----------------------------------------
echo  [I] Install an App from the list above
echo  [S] Search for something else
echo  [B] Back to WinGet Menu
echo.
choice /C ISB /N /M "Selection: "
if %el% 3 (
	echo [!date! !time!] %txt4%{W}{B}{%appname%}{Enter}{B} Back to WinGet Menu. >> "%logFile%"
	echo [!date! !time!] %txt2% WinGet Control Menu. >> "%logFile%"
	goto AW_Menu
)
if %el% 2 (
	echo [!date! !time!] %txt4%{W}{B}{%appname%}{Enter}{S} Search for something else. >> "%logFile%"
	echo [!date! !time!] %txt2% WinGet Search and Quick Install Menu. >> "%logFile%"
	goto AW_Search
)
if %el% 1 (
	echo [!date! !time!] %txt4%{W}{B}{%appname%}{Enter}{I} Install an App from the list above. >> "%logFile%"
	echo [!date! !time!] Going to Quick Install Menu. >> "%logFile%"
	goto AW_QuickInstall
)
goto AW_Search_Result
:AW_QuickInstall
echo.
echo %Cyan%--- QUICK INSTALL ---%Reset%
echo.
echo  How to Copy ID?
echo  1. Select the App ID you want to Install using Mouse.
echo  2. Press 'Enter' to Copy the ID.
echo  3. Right-Click Mouse Button to Paste the ID.
echo.
set "appid="
set /p appid="Paste the EXACT ID from above list: "
if "!appid!"=="" (
	echo [!date! !time!] %txt4%{W}{B}{%appname%}{Enter}{I}{%appid%}{Enter} . >> "%logFile%"
	echo [!date! !time!] %txt2% Search Result Menu. >> "%logFile%"
	goto AW_Search_Result
)
echo.
echo %Yellow%Installing !appid!... Please wait.%Reset%
echo [!date! !time!] Installing App with this '%appid%' ID. >> "%logFile%"
echo.
winget install --id "!appid!" --silent --accept-source-agreements --accept-package-agreements
if %errorlevel% equ 0 (
    echo.
	echo [!date! !time!] App Installation with this '%appid%' ID is Successfully. >> "%logFile%"
    echo %Blue%Successfully installed !appid!%Reset%
) else (
    echo.
	echo [!date! !time!] App Installation with this '%appid%' ID has Failed. >> "%logFile%"
    echo %Red%Failed to install. Check the ID and try again.%Reset%
)
echo.
echo %txt2% Search Menu in 3 Seconds...
timeout /t 3 >nul
echo [!date! !time!] %txt2% Search Result Menu. >> "%logFile%"
goto AW_Search_Result
:AW_Uninstall
echo.
echo If you don't know the App ID, Use Search Menu first.
echo.
set /p appid="Enter App ID or Name to uninstall: "
echo [!date! !time!] User Entered this '%appid%' App ID to Uninstall. >> "%logFile%"
winget uninstall "%appid%"
echo.
pause
echo [!date! !time!] %txt2% WinGet Control Menu. >> "%logFile%"
goto AW_Menu
:AW_Upgrade
echo.
echo.
echo Checking for %at1% App Updates...
echo.
echo [!date! !time!] User Trying to Upgrade All Apps. >> "%logFile%"
winget upgrade --all
echo.
pause
echo [!date! !time!] %txt2% WinGet Control Menu. >> "%logFile%"
goto AW_Menu
:: --- ACTIVATION / DEBLOAT ---
:AA
echo [!date! !time!] %txt4%{A} Activate %at1% / Office. >> "%logFile%"
echo.
echo Launching Activation Tool...
echo.
echo [!date! !time!] Opening a Separate Window for 'Activation Tool'. >> "%logFile%"
powershell -Command "irm https://get.activated.win | iex"
echo.
echo [!date! !time!] 'Activation Tool' %at1% Closed. >> "%logFile%"
pause
echo [!date! !time!] %txt2% %txt1%. >> "%logFile%"
goto A
:AB
echo [!date! !time!] %txt4%{D} Debloat %at1% (Win 10/11^). >> "%logFile%"
echo.
echo Launching Debloat Tool...
echo.
echo [!date! !time!] Opening a Separate Window for 'Debloat Tool'. >> "%logFile%"
powershell -Command "iwr https://git.io/debloat11 | iex"
echo.
echo [!date! !time!] 'Debloat Tool' %at1% Closed. >> "%logFile%"
pause
echo [!date! !time!] %txt2% %txt1%. >> "%logFile%"
goto A
:: --- SYSTEM PERFORMANCE (ORIGINAL v2.1) ---
:AC
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo          SYSTEM PERFORMANCE RATING        
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo  [V] View Saved Scores
echo  [R] Run NEW Assessment (May take 1-5 minutes)
echo  [B] Back to %txt1%
echo  [X] Exit
echo.
choice /C VRBX /N /M "Selection: "
if %el% 4 (
	echo [!date! !time!] %txt4%{S}{X} Exit. >> "%logFile%"
	echo [!date! !time!] %txt3% System Performance Rating Menu. >> "%logFile%"
	goto Z
)
if %el% 3 (
	echo [!date! !time!] %txt4%{S}{B} Back to %txt1%. >> "%logFile%"
	echo [!date! !time!] %txt2% %txt1%. >> "%logFile%"
	goto A
)
if %el% 2 goto AC_Run
if %el% 1 (
	echo [!date! !time!] %txt4%{S}{V} View Saved Scores. >> "%logFile%"
	goto AC_View
)
goto AC
:AC_Run
echo [!date! !time!] %txt4%{S}{R} Run NEW Assessment. >> "%logFile%"
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo        CHECKING YOUR PCs PERFORMANCE      
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo  %Yellow%Warning: Your screen may flicker and fans may speed up.%Reset%
echo.
echo  Running Assessment... Please wait until the process completes.
winsat formal
echo [!date! !time!] Assessment Complete. >> "%logFile%"
echo.
echo  %Blue%Assessment Complete!%Reset% %txt6%see your results...
echo.
pause >nul
echo [!date! !time!] Going to 'View Saved Scores' Menu. >> "%logFile%"
goto AC_View
:AC_View
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo         YOUR PCs PERFORMANCE REPORT       
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.

:: --- 1. CAPTURE RATING (Fixed Escaping) ---
:: We escape |, (, and ) using ^ so Batch doesn't crash
for /f "tokens=*" %%i in ('powershell -NoProfile -Command ^
 "$s = Get-CimInstance win32_winSat;" ^
 "if ($null -eq $s -or $s.WinSPRLevel -eq 0) { Write-Output 'ERROR' } else {" ^
 "  if ($s.WinSPRLevel -ge 8) { $r = 'EXCELLENT' } " ^
 "  elseif ($s.WinSPRLevel -ge 6) { $r = 'GOOD' } " ^
 "  else { $r = 'NEEDS UPGRADE' };" ^
 "  $out = $s.WinSPRLevel.ToString() + ' ^(' + $r + '^)';" ^
 "  Write-Output $out" ^
 "}"') do set "pcRating=%%i"

:: --- 2. VISUAL DISPLAY ---
powershell -NoProfile -Command ^
 "$cpu = (Get-CimInstance Win32_Processor).Name;" ^
 "$ram = [Math]::Round((Get-CimInstance Win32_PhysicalMemory ^| Measure-Object Capacity -Sum).Sum / 1GB);" ^
 "$s = Get-CimInstance win32_winSat;" ^
 "write-host ' Processor:      ' $cpu -ForegroundColor Cyan;" ^
 "write-host ' Total RAM:      ' $ram 'GB' -ForegroundColor Cyan;" ^
 "write-host '-----------------------------------------';" ^
 "if ($null -eq $s -or $s.WinSPRLevel -eq 0) {" ^
 "  write-host ' [!] ERROR: No assessment results found.' -ForegroundColor Red;" ^
 "  write-host ' Please run a [R] NEW assessment from the previous menu.' -ForegroundColor Yellow;" ^
 "} else {" ^
 "  write-host ' CPU Score:       ' $s.CPUScore;" ^
 "  write-host ' Memory Score:    ' $s.MemoryScore;" ^
 "  write-host ' Graphics Score:  ' $s.GraphicsScore ' (Desktop)';" ^
 "  write-host ' Gaming Score:    ' $s.D3DScore ' (3D/Gaming)';" ^
 "  write-host ' Bench Score:     ' $s.DiskScore;" ^
 "  write-host '-----------------------------------------';" ^
 "  write-host ' OVERALL RATING:  ' $s.WinSPRLevel -NoNewline;" ^
 "  if ($s.WinSPRLevel -ge 8) { write-host ' [ EXCELLENT ]' -ForegroundColor Green } " ^
 "  elseif ($s.WinSPRLevel -ge 6) { write-host ' [ GOOD ]' -ForegroundColor Yellow } " ^
 "  else { write-host ' [ NEEDS UPGRADE ]' -ForegroundColor Red }" ^
 "}"

:: --- 3. UNIFORM LOGGING ---
if /i "%pcRating%"=="ERROR" (
    echo [!date! !time!] Performance View: ERROR - No results found >> "%logFile%"
) else (
    echo [!date! !time!] Performance Score: %pcRating% >> "%logFile%"
)
echo.
echo  -----------------------------------------
echo.
echo  QUICK GUIDE:
echo.
echo  1.0 to 3.9: Entry Level (Web browsing/Office)
echo  4.0 to 6.9: Mid-Range (Multi-tasking/HD Video)
echo  7.0 to 9.9: High Performance (Gaming/Heavy Work)
echo.
echo  %txt6%Return to the Performance Menu...
pause >nul
echo [!date! !time!] %txt2% System Performance Rating Menu. >> "%logFile%"
goto AC
:: --- DRIVE HEALTH (ORIGINAL v2.1) ---
:AH
echo [!date! !time!] %txt4%{H} Drive Health Check (SSD/HDD^). >> "%logFile%"
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo       DRIVE HEALTH REPORT (S.M.A.R.T)     
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
powershell -Command ^
 "Get-PhysicalDisk | ForEach-Object {" ^
 "  $health = $_.HealthStatus;" ^
 "  $color = if ($health -eq 'Healthy') { 'Green' } else { 'Red' };" ^
 "  $rel = $_ | Get-StorageReliabilityCounter;" ^
 "  write-host ' Model:       ' $_.FriendlyName -ForegroundColor Cyan;" ^
 "  write-host ' Type:        ' $_.MediaType;" ^
 "  write-host -NoNewline ' Status:      ' ; write-host $health -ForegroundColor $color;" ^
 "  if ($rel.Wear -ne $null) { write-host ' Life Left:    ' (100 - $rel.Wear) '%' -ForegroundColor Yellow }" ^
 "  else { write-host ' Life Left:    N/A (Not supported by drive)' -ForegroundColor Gray }" ^
 "  write-host '-----------------------------------------';" ^
 "}"
echo.
echo [!date! !time!] Drive Health Check Complete. >> "%logFile%"
echo  %Blue%Done!%Reset% %txt6%Return to %txt1%...
pause >nul
echo [!date! !time!] %txt2% %txt1%. >> "%logFile%"
goto A
:: --- CLEANUP TOOL (ORIGINAL v2.1) ---
:AD
echo [!date! !time!] %txt4%{C} Deep Cleanup. >> "%logFile%"
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo                CLEANUP TOOL               
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo.
echo  %Cyan%Starting Safe Cleanup...%Reset%
echo  [+] Cleaning User Temp (Safe Mode)...
powershell -Command "Get-ChildItem -Path $env:TEMP\* -Recurse | Where-Object { $_.FullName -notlike \"*$($env:USERNAME)*\" -and $_.Attributes -notmatch 'ReadOnly' } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue"
echo  [+] Cleaning %at1% Temp...
powershell -Command "Remove-Item -Path 'C:\Windows\Temp\*' -Recurse -Force -ErrorAction SilentlyContinue"
echo  [+] Cleaning Prefetch...
powershell -Command "Remove-Item -Path 'C:\Windows\Prefetch\*' -Recurse -Force -ErrorAction SilentlyContinue"
echo.
echo Opening '%Yellow%Disk Cleanup%Reset%' Tool.
echo.
echo From 'Files to Delete' list Check Everything.
echo Then 'OK'.
echo [!date! !time!] Opening 'Disk Cleanup' Tool. >> "%logFile%"
cleanmgr
echo.
echo [!date! !time!] Cleanup Complete, Waiting for App to Close. >> "%logFile%"
echo %Green%Cleanup Complete!%Reset%
echo.
echo  %Yellow%Note: Active system files were safely skipped.%Reset%
echo.
echo  %txt6%Close this App. [Required for Successfully Cleanup]
pause>nul
echo [!date! !time!] %txt3% Cleanup Menu. >> "%logFile%"
goto Z
:: --- SYSTEM REPAIR ---
:AE
echo [!date! !time!] %txt4%{R} Repair System Files (SFC^). >> "%logFile%"
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo             SYSTEM REPAIR (SFC)           
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo [!date! !time!] Launching System File Checker (SFC)... >> "%logFile%"
echo  Launching System File Checker (SFC)...
sfc /scannow
echo.
echo [!date! !time!] System Scan/Repair Complete. >> "%logFile%"
echo  %Blue%Scan/Repair Complete!%Reset%
echo.
pause
echo [!date! !time!] %txt2% %txt1%. >> "%logFile%"
goto A
:Z
echo %ver% > "%appCrash%"
set "currtime=!date! !time!"
echo [!currtime!] %txt0%%txt0%%txt0%%txt0%==== >> "%logFile%"
echo [!currtime!] %txt0% THIS SESSION HAS ENDED %txt0% Version : %ver% >> "%logFile%"
echo [!currtime!] %txt0%%txt0%%txt0%%txt0%==== >> "%logFile%"
cls
echo.
echo  %Cyan%                           bY - MR. 4HM3D%Reset%
echo  %txt0%%txt0%%txt0%%txt0%=
echo      %tt% - v%ver%     
echo  %txt0%%txt0%%txt0%%txt0%=%vers%
echo.
echo  Goodbye! Have a nice day.
echo.
timeout /t 3 >nul
goto ZA
:ZA
powershell -Command "Remove-Item -Path $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue"
exit /b
goto ZB
:ZB
cls
echo.
echo  If you are seeing this, then the app is not working properly.
echo.
pause
goto ZA
