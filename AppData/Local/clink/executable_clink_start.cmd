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

if "%WT_THEME%"=="Dracula"             set VIM_COLORSCHEME=dracula
if "%WT_THEME%"=="Iceberg"             set VIM_COLORSCHEME=iceberg
if "%WT_THEME%"=="Tokyo Night"         set VIM_COLORSCHEME=tokyonight
if "%WT_THEME%"=="Tokyo Night Storm"   set VIM_COLORSCHEME=tokyonight
if "%WT_THEME%"=="Tokyo Night Light"   set VIM_COLORSCHEME=tokyonight

if "%VIM_COLORSCHEME%"=="" (
    set VIM_COLORSCHEME=%WT_THEME: =-%
    set VIM_COLORSCHEME=%WT_THEME: =-%
    set VIM_COLORSCHEME=%VIM_COLORSCHEME:"=%
    set VIM_COLORSCHEME=%VIM_COLORSCHEME:~0,-0%
    set VIM_COLORSCHEME=%VIM_COLORSCHEME:~0,-0%
    set VIM_COLORSCHEME=%VIM_COLORSCHEME:~0,-0%
)

rem echo "WT_PROFILE_ID=%WT_PROFILE_ID%"
rem echo WT_THEME=%WT_THEME%
rem echo VIM_COLORSCHEME=%VIM_COLORSCHEME%

doskey /macrofile=%USERPROFILE%\macros.txt

endlocal & set WT_THEME=%WT_THEME% & set VIM_COLORSCHEME=%VIM_COLORSCHEME%
:skip
