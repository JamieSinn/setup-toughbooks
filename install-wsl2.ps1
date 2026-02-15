# Install WSL 2 on Windows 10

Write-Host "Installing WSL 2..." -ForegroundColor Cyan

# Enable Windows Subsystem for Linux feature
Write-Host "Enabling Windows Subsystem for Linux..." -ForegroundColor Cyan
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enable Virtual Machine Platform feature (required for WSL 2)
Write-Host "Enabling Virtual Machine Platform..." -ForegroundColor Cyan
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Set WSL 2 as the default version
Write-Host "Setting WSL 2 as default version..." -ForegroundColor Cyan
wsl --set-default-version 2

Write-Host ""
Write-Host "WSL 2 installation complete!" -ForegroundColor Green
Write-Host "A restart is required to finish the installation." -ForegroundColor Yellow
Write-Host ""

$restart = Read-Host "Restart now? (Y/N)"
if ($restart -eq "Y" -or $restart -eq "y") {
    Restart-Computer -Force
}


