# Setup Pit Admin Toughbook

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Setting up Pit Admin Toughbook..." -ForegroundColor Cyan

# Set FIRST AGE wallpaper
& "$ScriptDir\set-wallpaper.ps1"

Write-Host "Pit Admin Toughbook setup complete!" -ForegroundColor Green

