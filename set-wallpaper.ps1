# Set Windows 10 Desktop Wallpaper to FIRST AGE Theme
# Downloads and applies the official FIRST 2026 season wallpaper

# Verify Windows 10
$OSVersion = [System.Environment]::OSVersion.Version
if ($OSVersion.Major -ne 10) {
    Write-Host "This script is designed for Windows 10." -ForegroundColor Yellow
}

$WallpaperUrl = "https://info.firstinspires.org/hubfs/2026%20Season/Season%20Assets/FIRST_AGE-wallpaper-dark.jpg"
$WallpaperPath = "$env:APPDATA\Microsoft\Windows\Themes\FIRST_AGE-wallpaper-dark.jpg"

# Download the wallpaper image
Write-Host "Downloading FIRST AGE wallpaper..." -ForegroundColor Cyan
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $WallpaperUrl -OutFile $WallpaperPath -UseBasicParsing
    Write-Host "Wallpaper downloaded to: $WallpaperPath" -ForegroundColor Green
} catch {
    Write-Host "Failed to download wallpaper: $_" -ForegroundColor Red
    exit 1
}

# Set wallpaper style to "Fill" (10) via registry
# WallpaperStyle: 0=Center, 2=Stretch, 6=Fit, 10=Fill, 22=Span
Write-Host "Configuring wallpaper style..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value "10"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value "0"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $WallpaperPath

# Set lock screen image via registry
Write-Host "Configuring lock screen image..." -ForegroundColor Cyan
$LockScreenRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
if (-not (Test-Path $LockScreenRegPath)) {
    New-Item -Path $LockScreenRegPath -Force | Out-Null
}
Set-ItemProperty -Path $LockScreenRegPath -Name LockScreenImage -Value $WallpaperPath
Set-ItemProperty -Path $LockScreenRegPath -Name NoChangingLockScreen -Value 1

# Apply the wallpaper by restarting Explorer (most reliable method for Windows 10)
Write-Host "Applying wallpaper..." -ForegroundColor Cyan
Stop-Process -Name explorer -Force
Start-Sleep -Seconds 1
Start-Process explorer

Write-Host "Wallpaper and lock screen set successfully!" -ForegroundColor Green





