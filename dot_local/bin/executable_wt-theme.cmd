@echo off
setlocal

set SETTINGS=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" (
    for /f "tokens=*" %%A in ('pwsh -NoLogo -NoProfile -Command ^
      "(Get-Content $env:SETTINGS -Raw | ConvertFrom-Json).profiles.list | Where-Object { $_.guid -eq $env:WT_PROFILE_ID } | Select-Object -ExpandProperty colorScheme"') do (
        set WT_THEME=%%A
    )
) else (
    for /f "tokens=*" %%A in ('powershell -NoLogo -NoProfile -Command ^
      "(Get-Content $env:SETTINGS -Raw | ConvertFrom-Json).profiles.list | Where-Object { $_.guid -eq $env:WT_PROFILE_ID } | Select-Object -ExpandProperty colorScheme"') do (
        set WT_THEME=%%A
    )
)
endlocal & set WT_THEME=%WT_THEME%

