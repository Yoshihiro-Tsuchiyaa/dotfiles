@echo off
if "%WT_PROFILE_ID%"=="" goto :skip
setlocal

if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" (
    set WT_SHELL=pwsh.exe
) else (
    set WT_SHELL=powershell.exe
)

set SETTINGS=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

for /f %%A in ('jq -r ".profiles.list[] | select(.guid==\"%WT_PROFILE_ID%\") | .colorScheme" "%SETTINGS%"') do (
    set WT_THEME=%%A
)

if "%WT_THEME%"=="" (
    for /f %%A in ('jq -r ".profiles.defaults.colorScheme" "%SETTINGS%"') do (
        set WT_THEME=%%A
    )
)

rem for /f "tokens=*" %%A in ('pwsh -NoLogo -NoProfile -Command ^
rem   "(Get-Content $env:SETTINGS -Raw | ConvertFrom-Json).profiles.list | Where-Object { $_.guid -eq $env:WT_PROFILE_ID } | Select-Object -ExpandProperty colorScheme"') do (
rem     set WT_THEME=%%A
rem )
rem 
rem if "%WT_THEME%"=="" (
rem     for /f "tokens=*" %%A in ('pwsh -NoLogo -NoProfile -Command ^
rem       "(Get-Content $env:SETTINGS -Raw | ConvertFrom-Json).profiles.defaults.colorScheme"') do (
rem         set WT_THEME=%%A
rem     )
rem )

rem echo "WT_PROFILE_ID=%WT_PROFILE_ID%"
rem echo WT_THEME=%WT_THEME%

set "aliases=%USERPROFILE%\macros.doskey"
if exist "%aliases%" (
    doskey /macrofile="%aliases%"
) else (
    echo "doskey macrofile not found: %aliases%"
)
rem
rem
rem
set "PROFILE=%USERPROFILE%\OneDrive\9831~1\PowerShell\Microsoft.PowerShell_profile.ps1"
set "CLINK=%LOCALAPPDATA%\clink\clink_start.cmd"

rem
rem python venv
rem
set "venv=%USERPROFILE%\venv\Scripts\activate.bat"
if exist "%venv%" (
    call "%venv%"
    echo "venv: %venv%"
    where python
) else (
    echo "venv setup file not found: %venv%"
)

endlocal & set WT_THEME=%WT_THEME% & set WT_SHELL=%WT_SHELL% & set PROFILE=%PROFILE% & set CLINK=%CLINK%
:skip

