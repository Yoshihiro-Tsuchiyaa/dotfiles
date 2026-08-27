#
# ~/.config/powershell/Microsoft.PowerShell_profile.ps1 など
#
#@oh-my-posh init pwsh | Invoke-Expression
#
#
#
Import-Module lsd-aliases -DisableNameChecking
#
# WT_THEME
#
# Windows Terminal settings.json 読み取り
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

$profileId = $env:WT_PROFILE_ID
$currentProfile = $settings.profiles.list | Where-Object { $_.guid -eq $profileId }

$theme = $currentProfile.colorScheme
if (-not $theme) {
    $theme = $settings.profiles.defaults.colorScheme
}

$env:WT_THEME = $theme

# Write-Host "WT_THEME=$theme"

function cdh { Set-Location $env:USERPROFILE }
function cdb { Set-Location "$env:USERPROFILE\.local\bin" }
function cdc { Set-Location "$env:USERPROFILE\.local\share\chezmoi" }
function admin { wt -p "PowerShell (管理者)" }
#
# python:venv
#
$venv = Join-Path $env:USERPROFILE "venv\Scripts\Activate.ps1"
if (Test-Path $venv) {
    Write-Host "venv setup file found: $venv"
    . $venv
} else {
    Write-Host "venv setup file not found: $venv"
}
#
# clink setup file for editing
#
$clink = Join-Path $env:LOCALAPPDATA "clink\clink_start.cmd"
if (Test-Path $clink) {
    Write-Host "clink setup file found: $clink"
    $env:CLINK = $clink
} else {
    Write-Host "clink setup file not found: $clink"
}

