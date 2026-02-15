# Setup FTA Toughbook

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Setting up FTA Toughbook..." -ForegroundColor Cyan

# Set FIRST AGE wallpaper
& "$ScriptDir\set-wallpaper.ps1"

# Install WSL 2
& "$ScriptDir\install-wsl2.ps1"

# Install Docker Desktop
& "$ScriptDir\install-docker.ps1"

Write-Host "FTA Toughbook setup complete!" -ForegroundColor Green

