# Set Windows 10 Desktop Wallpaper and Lock Screen to FIRST AGE Theme
# Downloads and applies the official FIRST 2026 season wallpaper

# Verify Windows 10
$OSVersion = [System.Environment]::OSVersion.Version
if ($OSVersion.Major -ne 10) {
    Write-Host "This script is designed for Windows 10." -ForegroundColor Yellow
}

$WallpaperUrl = "https://info.firstinspires.org/hubfs/2026%20Season/Season%20Assets/FIRST_AGE-wallpaper-dark.jpg"

# Use system location for images (accessible for lock screen before login)
$ImageDir = "C:\Windows\Web\Wallpaper\FIRST"
$WallpaperPath = "$ImageDir\FIRST_AGE-wallpaper-dark.jpg"

# Create directory if it doesn't exist
if (-not (Test-Path $ImageDir)) {
    New-Item -Path $ImageDir -ItemType Directory -Force | Out-Null
}

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

# Apply the desktop wallpaper using SystemParametersInfo via reg and rundll32
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d $WallpaperPath /f | Out-Null
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 1,True

# Set lock screen image via registry policy
Write-Host "Configuring lock screen image..." -ForegroundColor Cyan
$LockScreenRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
if (-not (Test-Path $LockScreenRegPath)) {
    New-Item -Path $LockScreenRegPath -Force | Out-Null
}
Set-ItemProperty -Path $LockScreenRegPath -Name LockScreenImage -Value $WallpaperPath
Set-ItemProperty -Path $LockScreenRegPath -Name NoChangingLockScreen -Value 1

# Disable Windows Spotlight to ensure our lock screen is used
$ContentDeliveryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
Set-ItemProperty -Path $ContentDeliveryPath -Name RotatingLockScreenEnabled -Value 0
Set-ItemProperty -Path $ContentDeliveryPath -Name RotatingLockScreenOverlayEnabled -Value 0

Write-Host "Wallpaper and lock screen set successfully!" -ForegroundColor Green
Write-Host "Lock screen will apply on next lock/login." -ForegroundColor Yellow





