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

rem echo "WT_PROFILE_ID=%WT_PROFILE_ID%"
rem echo WT_THEME=%WT_THEME%

set "aliases=%USERPROFILE%\macros.doskey"
if exist "%aliases%" (
    doskey /macrofile="%aliases%"
) else (
    echo doskey macrofile not found: %aliases%
)
rem
rem
rem
set "PROFILE=%USERPROFILE%\OneDrive\9831~1\PowerShell\Microsoft.PowerShell_profile.ps1"
set "CLINK=%LOCALAPPDATA%\clink\clink_start.cmd"

endlocal & set WT_THEME=%WT_THEME% & set WT_SHELL=%WT_SHELL% & set PROFILE=%PROFILE% & set CLINK=%CLINK%
:skip

pwsh -NoProfile -Command ^
  "if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { exit 1 } else { exit 0 }"
set "isAdmin=%ERRORLEVEL%"
echo Result: isAdmin=%isAdmin%

rem
rem python venv
rem
set "venv=%USERPROFILE%\venv\Scripts\activate.bat"
if exist "%venv%" (
rem    call "%venv%"
    echo venv: %venv%
    where.exe python
) else (
    echo venv setup file not found: %venv%
)
