# Install Docker Desktop on Windows 10

$DockerInstallerUrl = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
$DockerInstallerPath = "$env:TEMP\DockerDesktopInstaller.exe"

# Download Docker Desktop installer
Write-Host "Downloading Docker Desktop..." -ForegroundColor Cyan
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $DockerInstallerUrl -OutFile $DockerInstallerPath -UseBasicParsing
Write-Host "Download complete." -ForegroundColor Green

# Install Docker Desktop silently with WSL 2 backend
Write-Host "Installing Docker Desktop..." -ForegroundColor Cyan
Start-Process -FilePath $DockerInstallerPath -ArgumentList "install", "--quiet", "--accept-license" -Wait

# Cleanup installer
Remove-Item $DockerInstallerPath -Force

Write-Host "Docker Desktop installed successfully!" -ForegroundColor Green
Write-Host "A restart may be required before Docker Desktop can be used." -ForegroundColor Yellow

