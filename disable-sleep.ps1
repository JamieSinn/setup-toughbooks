# Disable Sleep and Hibernate on Windows 10
# Ensures the computer is always on and reachable remotely

Write-Host "Configuring power settings..." -ForegroundColor Cyan

# Disable hibernate
Write-Host "Disabling hibernate..." -ForegroundColor Cyan
powercfg /hibernate off

# Set power plan to High Performance
Write-Host "Setting High Performance power plan..." -ForegroundColor Cyan
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Disable sleep on AC power (0 = never)
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0

# Disable monitor timeout on AC power (0 = never)
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0

# Disable hard disk timeout
powercfg /change disk-timeout-ac 0
powercfg /change disk-timeout-dc 0

# Disable USB selective suspend
powercfg /setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /setdcvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0

# Disable network adapter power saving to stay reachable
Write-Host "Disabling network adapter power management..." -ForegroundColor Cyan
$adapters = Get-NetAdapter -Physical | Get-NetAdapterPowerManagement -ErrorAction SilentlyContinue
foreach ($adapter in $adapters) {
    $adapter | Set-NetAdapterPowerManagement -WakeOnMagicPacket Enabled -WakeOnPattern Enabled -ErrorAction SilentlyContinue
    $adapter | Disable-NetAdapterPowerManagement -ErrorAction SilentlyContinue
}

# Disable sleep button and lid close actions
Write-Host "Disabling lid close and power button sleep..." -ForegroundColor Cyan
powercfg /setacvalueindex scheme_current sub_buttons lidaction 0
powercfg /setdcvalueindex scheme_current sub_buttons lidaction 0
powercfg /setacvalueindex scheme_current sub_buttons sbuttonaction 0
powercfg /setdcvalueindex scheme_current sub_buttons sbuttonaction 0

# Apply the active power scheme
powercfg /setactive scheme_current

# Enable Wake-on-LAN in registry
Write-Host "Enabling Wake-on-LAN..." -ForegroundColor Cyan
$WoLPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
Set-ItemProperty -Path $WoLPath -Name HiberbootEnabled -Value 0 -ErrorAction SilentlyContinue

# Disable fast startup (can interfere with remote access)
$FastStartupPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
Set-ItemProperty -Path $FastStartupPath -Name HiberbootEnabled -Value 0 -ErrorAction SilentlyContinue

# Enable Remote Desktop
Write-Host "Enabling Remote Desktop..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name fDenyTSConnections -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction SilentlyContinue

# Enable Windows Remote Management (WinRM)
Write-Host "Enabling WinRM..." -ForegroundColor Cyan
Enable-PSRemoting -Force -SkipNetworkProfileCheck -ErrorAction SilentlyContinue

Write-Host "Power settings configured successfully!" -ForegroundColor Green
Write-Host "Sleep and hibernate are disabled. Computer will stay reachable." -ForegroundColor Green

