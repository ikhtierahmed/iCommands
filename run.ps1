# iCommands v2.9 Remote Launcher & Offline Installer
# Author: Md. Ikhtier Ahmed (bY - IAN)

$url = "https://github.com/ikhtierahmed/iCommands/raw/b1628fb33a51dab498e554d82c63ddbfb9162169/iCommands.exe"
$desktopPath = "$HOME\Desktop\iCommands.exe"
$tempPath = "$env:TEMP\iCommands_v29.exe"

Clear-Host
Write-Host "--- iCommands v2.9 Remote Loader ---" -ForegroundColor Cyan
Write-Host "Initializing secure download..." -ForegroundColor Yellow

# Admin Check
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] Warning: iCommands requires Administrator rights for full functionality." -ForegroundColor Red
}

try {
    # Feature: Persistent Desktop Install
    if (-not (Test-Path $desktopPath)) {
        Write-Host "Saving a copy to Desktop for offline use..." -ForegroundColor Magenta
        Invoke-WebRequest -Uri $url -OutFile $desktopPath -ErrorAction Stop
        Write-Host "Done! You can now launch iCommands from your Desktop later." -ForegroundColor Green
    }

    # Standard Execution Logic
    Write-Host "Fetching latest engine to Temp..." -ForegroundColor Gray
    Invoke-WebRequest -Uri $url -OutFile $tempPath -ErrorAction Stop
    
    Write-Host "Launching v2.9..." -ForegroundColor Green
    Start-Process -FilePath $tempPath -Wait
    
    # Cleanup Temp (keeps Desktop copy safe)
    if (Test-Path $tempPath) {
        Remove-Item -Path $tempPath -Force -ErrorAction SilentlyContinue
    }
    Write-Host "Session cleaned. Thank you for using iCommands, bY - MR. 4HM3D." -ForegroundColor Cyan
}
catch {
    Write-Host "Error: Failed to fetch the executable. Please check your URL or connection." -ForegroundColor Red
}
