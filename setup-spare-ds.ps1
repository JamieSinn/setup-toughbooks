# Setup Spare DS Toughbook

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Setting up Spare DS Toughbook..." -ForegroundColor Cyan

# Set FIRST AGE wallpaper
& "$ScriptDir\set-wallpaper.ps1"

Write-Host "Spare DS Toughbook setup complete!" -ForegroundColor Green

