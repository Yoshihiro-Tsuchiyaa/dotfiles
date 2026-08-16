@echo off
if "%WT_PROFILE_ID%"=="" goto :skip
setlocal

rem if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" (
rem     set WT_SHELL=pwsh.exe
rem ) else (
rem     set WT_SHELL=powershell.exe
rem )

set SETTINGS=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

for /f "tokens=*" %%A in ('powershell -NoLogo -NoProfile -Command ^
  "(Get-Content $env:SETTINGS -Raw | ConvertFrom-Json).profiles.list | Where-Object { $_.guid -eq $env:WT_PROFILE_ID } | Select-Object -ExpandProperty colorScheme"') do (
    set WT_THEME=%%A
)

if "%WT_THEME%"=="" (
    for /f "tokens=*" %%A in ('powershell -NoLogo -NoProfile -Command ^
      "(Get-Content $env:SETTINGS -Raw | ConvertFrom-Json).profiles.defaults.colorScheme"') do (
        set WT_THEME=%%A
    )
)

rem echo "WT_PROFILE_ID=%WT_PROFILE_ID%"
rem echo WT_THEME=%WT_THEME%

doskey /macrofile=%USERPROFILE%\macros.txt

rem
rem
rem
set PROFILE=%USERPROFILE%\OneDrive\9831~1\PowerShell\Microsoft.PowerShell_profile.ps1

endlocal & set WT_THEME=%WT_THEME% & set PROFILE=%PROFILE%
:skip
