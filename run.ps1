# iCommands v2.8 Remote Launcher
# Author: Md. Ikhtier Ahmed (bY - IAN)

$url = "https://github.com/ikhtierahmed/iCommands/raw/4d69ad5e5e77f9b64c381967509be94903895db7/iCommands.exe"
$tempPath = "$env:TEMP\iCommands_v28.exe"

Clear-Host
Write-Host "--- iCommands v2.8 Remote Loader ---" -ForegroundColor Cyan
Write-Host "Initializing secure download..." -ForegroundColor Yellow

# Admin Check
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] Warning: iCommands requires Administrator rights for full functionality." -ForegroundColor Red
}

try {
    # Download the EXE to the Temp folder
    Invoke-WebRequest -Uri $url -OutFile $tempPath -ErrorAction Stop
    
    Write-Host "Successfully Downloaded. Launching v2.8..." -ForegroundColor Green
    
    # Run the EXE and wait for the user to close it
    Start-Process -FilePath $tempPath -Wait
    
    # Cleanup: Delete the EXE after it is closed to maintain zero-footprint
    if (Test-Path $tempPath) {
        Remove-Item -Path $tempPath -Force -ErrorAction SilentlyContinue
    }
    Write-Host "Session cleaned. Thank you for using iCommands." -ForegroundColor Cyan
}
catch {
    Write-Host "Error: Failed to fetch the executable. Please check your URL or connection." -ForegroundColor Red
}
