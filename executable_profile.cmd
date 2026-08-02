@echo off

rem --- pwsh が存在するかチェック ---
if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" (
    set WT_SHELL=pwsh.exe
) else (
    set WT_SHELL=powershell.exe
)

rem --- doskey マクロを読み込む ---
doskey /macrofile=%USERPROFILE%\macros.txt

rem
wt-theme.cmd
rem echo "WT_THEME=%WT_THEME%"


