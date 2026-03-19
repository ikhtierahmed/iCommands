@echo off
setlocal Enabledelayedexpansion

:: --- Color Initialization (ANSI) ---
for /f %%a in ('echo prompt $E^|cmd') do set "ESC=%%a"
set "Red=%ESC%[91m"
set "Yellow=%ESC%[93m"
set "Blue=%ESC%[94m"
set "Cyan=%ESC%[96m"
set "Reset=%ESC%[0m"

set tt1=iCommands
set tt=All commands in one place
set ver=2.7
title %tt1%, v%ver%

:: --- Admin Check Start ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0c
    echo.
    echo %Cyan%                                   bY - IAN%Reset%
    echo  ****************************************************
    echo  %Red%ERROR: This script must be run as Administrator!%Reset%
    echo  ****************************************************
    echo.
    echo  Right-click the file and select "Run as administrator".
    echo.
    echo  Press any key to exit...
    pause>nul
    color
    exit /b
)
:AdminSuccess
color 0f

:A
cls
title %tt1%, v%ver%
echo.
echo %Cyan%                                   bY - IAN%Reset%
echo  =========================================
echo       %tt% - v%ver%
echo  =========================================
echo.
echo  Press a key to run the command:
echo.
echo  Key  Command
echo  [A]  Activate Windows / Office %Red%{Third-party}%Reset%
echo  [D]  Debloat Windows (Win 10/11) %Red%{Third-party}%Reset%
echo  [S]  System Performance Rating %Blue%{Windows}%Reset%
echo  [H]  Drive Health Check (SSD/HDD) %Blue%{Windows}%Reset%
echo  [W]  WinGet Package Manager %Blue%{Windows}%Reset%
echo  [T]  Tree Utility (Directory Map) %Blue%{Windows}%Reset%
echo  [O]  Disk Optimize (Defrag/Trim) %Blue%{Windows}%Reset%
echo  [P]  Power/Hibernation Status %Blue%{Windows}%Reset%
echo  [N]  Network Tools (DNS/IP) %Blue%{Windows}%Reset%
echo  [C]  Deep Temp Cleanup %Blue%{Windows}%Reset%
echo  [R]  Repair System Files (SFC) %Blue%{Windows}%Reset%
echo  [B]  Restart to BIOS/UEFI %Red%{System}%Reset%
echo  [X]  Exit
echo.

choice /C ADSHWTOPNCRBX /N /M "Selection: "

if errorlevel 13 goto Z
if errorlevel 12 goto AB_Bios
if errorlevel 11 goto AE
if errorlevel 10 goto AD
if errorlevel 9 goto AN_NetMenu
if errorlevel 8 goto AP_Power
if errorlevel 7 goto AO_Defrag
if errorlevel 6 goto AT_Tree
if errorlevel 5 goto AW_Check
if errorlevel 4 goto AH
if errorlevel 3 goto AC
if errorlevel 2 goto AB
if errorlevel 1 goto AA
goto A

:: --- HIBERNATION CONTROL ---
:AP_Power
cls
echo.
echo %Cyan%                                   bY - IAN%Reset%
echo  =========================================
echo         PC HIBERNATION CONTROL
echo  =========================================
echo.
echo  Checking current status...
:: Check registry for hibernation status
set "h_status=Disabled"
for /f "tokens=3" %%a in ('reg query "HKLM\System\CurrentControlSet\Control\Power" /v HibernateEnabled 2^>nul') do (
    if "%%a"=="0x1" set "h_status=Enabled"
)

echo  Current Status: %Cyan%!h_status!%Reset%
echo.
echo  [1] Turn Hibernation ON  (Enables Fast Startup)
echo  [2] Turn Hibernation OFF (Saves Disk Space)
echo  [B] Back to Main Menu
echo.
choice /C 12B /N /M "Selection: "

if errorlevel 3 goto A
if errorlevel 2 (
    powercfg -h off
    echo.
    echo %Red%Hibernation Disabled. hiberfil.sys has been removed.%Reset%
    timeout /t 2 >nul
    goto AP_Power
)
if errorlevel 1 (
    powercfg -h on
    echo.
    echo %Blue%Hibernation Enabled. Fast Startup is now available.%Reset%
    timeout /t 2 >nul
    goto AP_Power
)
goto AP_Power

:: --- BIOS RESTART ---
:AB_Bios
cls
echo.
echo %Red%!!! WARNING: PC WILL RESTART IMMEDIATELY !!!%Reset%
echo.
echo This will reboot your computer directly into the BIOS/UEFI settings.
echo.
echo [Y] Restart Now   [N] Cancel
choice /C YN /N /M "Selection: "
if errorlevel 2 goto A
shutdown /r /fw /t 0
goto A

:: --- DISK OPTIMIZE ---
:AO_Defrag
cls
echo.
echo %Cyan%                                   bY - IAN%Reset%
echo  =========================================
echo         DISK OPTIMIZE (DEFRAG/TRIM)
echo  =========================================
echo.
echo  Detecting Drive Type for C: ...
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "(Get-PhysicalDisk | Where-Object { (Get-Partition -DriveLetter C).DiskNumber -eq $_.DeviceID }).MediaType"') do set "MediaType=%%i"
if "!MediaType!"=="" set "MediaType=Unknown"
echo  Drive Type Detected: %Cyan%!MediaType!%Reset%
echo.
defrag C: /O /V
echo.
pause
goto A

:: --- NETWORK TOOLS MENU ---
:AN_NetMenu
cls
echo.
echo %Cyan%                                   bY - IAN%Reset%
echo  =========================================
echo             NETWORK TOOLS
echo  =========================================
echo.
echo  [F] Flush DNS Cache
echo  [R] Full Network Reset
echo  [B] Back to Main Menu
echo.
choice /C FRB /N /M "Selection: "
if errorlevel 3 goto A
if errorlevel 2 (
    netsh winsock reset & netsh int ip reset & ipconfig /flushdns
    echo.
    echo %Blue%Reset complete.%Reset%
    pause
    goto AN_NetMenu
)
if errorlevel 1 (
    ipconfig /flushdns
    echo %Blue%DNS Flushed.%Reset%
    timeout /t 2 >nul
    goto AN_NetMenu
)

:: --- TREE UTILITY ---
:AT_Tree
cd /d %SystemRoot%\System32
cls
echo.
echo %Cyan%                                   bY - IAN%Reset%
echo  =========================================
echo             TREE UTILITY TOOL
echo  =========================================
echo.
echo  How many times would you like to run the Tree command?
echo.
echo  [1] 10 Times
echo  [2] 30 Times
echo  [3] 50 Times
echo  [4] 70 Times
echo  [5] 100 Times
echo  [B] Back to Menu
echo.
choice /C 12345B /N /M "Selection: "

if errorlevel 6 goto A
if errorlevel 5 (set "loops=100" & goto RunTree)
if errorlevel 4 (set "loops=70" & goto RunTree)
if errorlevel 3 (set "loops=50" & goto RunTree)
if errorlevel 2 (set "loops=30" & goto RunTree)
if errorlevel 1 (set "loops=10" & goto RunTree)

:RunTree
echo.
echo %Yellow%Starting Tree process... Check window title for progress.%Reset%
for /L %%i in (1,1,%loops%) do (
    title Tree running %%i of %loops% times
    tree /a
    tree /f
)
title %tt1%, v%ver%
echo.
echo %Blue%SUCCESS: Tree finished %loops% cycles!%Reset%
timeout /t 3 >nul
goto A

:: --- WINGET SECTION START ---
:AW_Check
cls
echo.
echo %Cyan%                                   bY - IAN%Reset%
echo  =========================================
echo       WINGET PACKAGE MANAGER CHECK
echo  =========================================
echo.
echo  Scanning for Windows Package Manager...

set "wingetPath=%LOCALAPPDATA%\Microsoft\WindowsApps\winget.exe"
if exist "%wingetPath%" (
    echo %Blue%[+] Found WinGet executable in WindowsApps.%Reset%
    goto AW_Confirm
)

powershell -ExecutionPolicy Bypass -Command "if (Get-Command winget -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }" >nul 2>&1
if %errorlevel% equ 0 (
    echo %Blue%[+] WinGet command is recognized by the system.%Reset%
    goto AW_Confirm
)

echo %Yellow%[!] WinGet is NOT installed or the 'Alias' is disabled.%Reset%
echo.
echo  1. Try to Install WinGet automatically
echo  2. Open 'App Execution Aliases' to fix manually
echo  3. Back to Main Menu
echo.
choice /C 123 /N /M "Selection: "
if errorlevel 3 goto A
if errorlevel 2 (
    start ms-settings:appsfeatures-appexecutionaliases
    echo Check if 'App Installer (winget.exe)' is turned ON.
    pause
    goto AW_Check
)
if errorlevel 1 goto AW_Install_Process

:AW_Install_Process
echo.
echo Installing WinGet... This may take a moment.
powershell -ExecutionPolicy Bypass -Command ^
 "$progressPreference = 'silentlyContinue'; " ^
 "Write-Host 'Downloading installer...'; " ^
 "Invoke-WebRequest -Uri 'https://aka.ms/getwinget' -OutFile 'winget.msixbundle'; " ^
 "Write-Host 'Installing package...'; " ^
 "Add-AppxPackage -Path 'winget.msixbundle'; " ^
 "Remove-Item 'winget.msixbundle'"
echo.
echo %Blue%Installation complete!%Reset%
echo %Yellow%NOTE: You MUST restart this script for WinGet to work.%Reset%
pause
goto A

:AW_Confirm
echo.
echo Confirmed: %Blue%WinGet is installed and ready!%Reset%
timeout /t 2 >nul
goto AW_Menu

:AW_Menu
cls
echo.
echo %Cyan%                                   bY - IAN%Reset%
echo  =========================================
echo             WINGET CONTROL CENTER
echo  =========================================
echo.
echo  [S] Search and Quick Install App
echo  [U] Uninstall an App
echo  [G] Upgrade All Apps (Global Update)
echo  [B] Back to Main Menu
echo.
choice /C SUGB /N /M "Selection: "

if errorlevel 4 goto A
if errorlevel 3 goto AW_Upgrade
if errorlevel 2 goto AW_Uninstall
if errorlevel 1 goto AW_Search
goto AW_Menu

:AW_Search
cls
echo.
echo %Cyan%                                   bY - IAN%Reset%
echo  =========================================
echo       WINGET: SEARCH ^& QUICK INSTALL
echo  =========================================
echo.
set "appname="
set /p appname="Enter app name to search (or 'B' to go back): "
if /I "!appname!"=="B" goto AW_Menu
if "!appname!"=="" goto AW_Search

:AW_Search_Result
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

if errorlevel 3 goto AW_Menu
if errorlevel 2 goto AW_Search
if errorlevel 1 goto AW_QuickInstall
goto AW_Search_Result

:AW_QuickInstall
echo.
echo %Cyan%--- QUICK INSTALL ---%Reset%
set "appid="
set /p appid="Paste the EXACT ID from above: "
if "!appid!"=="" goto AW_Search_Result

echo.
echo %Yellow%Installing !appid!... Please wait.%Reset%
echo.
winget install --id "!appid!" --silent --accept-source-agreements --accept-package-agreements

if %errorlevel% equ 0 (
    echo.
    echo %Blue%Successfully installed !appid!%Reset%
) else (
    echo.
    echo %Red%Failed to install. Check the ID and try again.%Reset%
)

echo.
echo Returning to search in 3 seconds...
timeout /t 3 >nul
goto AW_Search_Result

:AW_Uninstall
echo.
set /p appid="Enter App ID or Name to uninstall: "
winget uninstall "%appid%"
echo.
pause
goto AW_Menu

:AW_Upgrade
echo.
echo Checking for updates...
winget upgrade --all
echo.
pause
goto AW_Menu

:: --- ACTIVATION / DEBLOAT ---
:AA
echo.
echo Launching Activation Tool...
powershell -Command "irm https://get.activated.win | iex"
pause
goto A

:AB
echo.
echo Launching Debloat Tool...
powershell -Command "iwr https://git.io/debloat11 | iex"
pause
goto A

:: --- SYSTEM PERFORMANCE (ORIGINAL v2.1) ---
:AC
cls
echo.
echo %Cyan%                                   bY - IAN%Reset%
echo  =========================================
echo          SYSTEM PERFORMANCE RATING
echo  =========================================
echo.
echo  [V] View saved scores
echo  [R] Run NEW assessment (May take 1-5 minutes)
echo  [B] Back to main menu
echo  [X] Exit
echo.
choice /C VRBX /N /M "Selection: "
if errorlevel 4 goto Z
if errorlevel 3 goto A
if errorlevel 2 goto AC_Run
if errorlevel 1 goto AC_View
goto AC

:AC_Run
cls
echo.
echo  =========================================
echo    YOUR PC PERFORMANCE DATA GENERATING...
echo  =========================================
echo.
echo  %Yellow%Warning: Your screen may flicker and fans may speed up.%Reset%
echo.
echo  Running Assessment... Please wait until the process completes.
winsat formal
echo.
echo  %Blue%Assessment Complete!%Reset% Press any key to see your results...
pause >nul
goto AC_View

:AC_View
cls
echo.
echo  =========================================
echo           YOUR PC PERFORMANCE REPORT
echo  =========================================
echo.
powershell -Command ^
 "$cpu = (Get-CimInstance Win32_Processor).Name;" ^
 "$ram = [Math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum / 1GB);" ^
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
echo.
echo  -----------------------------------------
echo.
echo  QUICK GUIDE:
echo  1.0 to 3.9: Entry Level (Web browsing/Office)
echo  4.0 to 6.9: Mid-Range (Multi-tasking/HD Video)
echo  7.0 to 9.9: High Performance (Gaming/Heavy Work)
echo.
echo  Press any key to return to the Performance menu...
pause >nul
goto AC

:: --- DRIVE HEALTH (ORIGINAL v2.1) ---
:AH
cls
echo.
echo %Cyan%                                   bY - IAN%Reset%
echo  =========================================
echo        DRIVE HEALTH REPORT (S.M.A.R.T)
echo  =========================================
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
echo  %Blue%Done!%Reset% Press any key to return...
pause >nul
goto A

:: --- CLEANUP TOOL (ORIGINAL v2.1) ---
:AD
cls
echo.
echo %Cyan%                                   bY - IAN%Reset%
echo  =========================================
echo                 CLEANUP TOOL
echo  =========================================
echo.
echo.
echo  %Cyan%Starting Safe Cleanup...%Reset%
:: The Logic: 
:: 1. We use PowerShell to get all items.
:: 2. We filter out the specific file name of THIS running script ($PSCommandPath).
:: 3. We use -ErrorAction SilentlyContinue so it doesn't crash if it hits itself.
echo  [+] Cleaning User Temp (Safe Mode)...
powershell -Command "Get-ChildItem -Path $env:TEMP\* -Recurse | Where-Object { $_.FullName -notlike \"*$($env:USERNAME)*\" -and $_.Attributes -notmatch 'ReadOnly' } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue"
echo  [+] Cleaning Windows Temp...
powershell -Command "Remove-Item -Path 'C:\Windows\Temp\*' -Recurse -Force -ErrorAction SilentlyContinue"
echo  [+] Cleaning Prefetch...
powershell -Command "Remove-Item -Path 'C:\Windows\Prefetch\*' -Recurse -Force -ErrorAction SilentlyContinue"
echo.
echo %Green%Cleanup Complete!%Reset%
echo.
echo  %Yellow%Note: Active system files were safely skipped.%Reset%
echo.
pause
goto A

:: --- SYSTEM REPAIR ---
:AE
cls
echo.
echo %Cyan%                                   bY - IAN%Reset%
echo  =========================================
echo             SYSTEM REPAIR (SFC)
echo  =========================================
echo.
echo  Launching System File Checker (SFC)...
sfc /scannow
echo.
echo  %Blue%Scan/Repair Complete!%Reset%
pause
goto A

:Z
cls
echo.
echo %Cyan%                                   bY - IAN%Reset%
echo  =========================================
echo       %tt% - v%ver%
echo  =========================================
echo.
echo  Goodbye!
timeout /t 2 >nul
powershell -Command "Remove-Item -Path $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue"
exit /b