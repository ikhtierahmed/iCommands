# iCommands v2.7 Remote Launcher
# Author: Md. Ikhtier Ahmed

$url = "https://github.com/ikhtierahmed/iCommands/raw/caee6a8c7fa64f6c282df9db526c3840f16afe86/iCommands.exe"
$tempPath = "$env:TEMP\iCommands_v27.exe"

Clear-Host
Write-Host "--- iCommands v2.7 Remote Loader ---" -ForegroundColor Cyan
Write-Host "Initializing secure download..." -ForegroundColor Yellow

try {
    # Download the EXE to the Temp folder
    Invoke-WebRequest -Uri $url -OutFile $tempPath -ErrorAction Stop
    
    Write-Host "Successfully Downloaded. Launching..." -ForegroundColor Green
    
    # Run the EXE and wait for the user to close it
    Start-Process -FilePath $tempPath -Wait
    
    # Cleanup: Delete the EXE after it is closed
    if (Test-Path $tempPath) {
        Remove-Item -Path $tempPath -Force -ErrorAction SilentlyContinue
    }
    Write-Host "Session cleaned. Thank you for using iCommands." -ForegroundColor Cyan
}
catch {
    Write-Host "Error: Failed to fetch the executable. Please check your URL or connection." -ForegroundColor Red
}
