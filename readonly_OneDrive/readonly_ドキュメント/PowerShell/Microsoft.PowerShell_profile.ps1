#
oh-my-posh init pwsh | Invoke-Expression
Import-Module lsd-aliases -DisableNameChecking
# WT-Theme
function Get-VimColorScheme($wtTheme) {
    switch ($wtTheme) {
        "Dracula"             { return "dracula" }
        "Iceberg"             { return "iceberg" }
        "Tokyo Night"         { return "tokyonight" }
        "Tokyo Night Storm"   { return "tokyonight" }
        "Tokyo Night Light"   { return "tokyonight" }
        default {
            # 汎用ルール：小文字化 + スペース→ハイフン
            return ($wtTheme.ToLower() -replace " ", "-")
        }
    }
}

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
$env:VIM_COLORSCHEME = Get-VimColorScheme $theme

# Write-Host "WT_THEME=$theme"
# Write-Host "VIM_COLORSCHEME=$env:VIM_COLORSCHEME"

# Set-Alias -Name cdh -Value cd %USERPROFILE%
# Set-Alias -Name cdb -Value cd %USERPROFILE%\.local\bin
# Set-Alias -Name cdc -Value cd %USERPROFILE%\.local\share\chezmoi
