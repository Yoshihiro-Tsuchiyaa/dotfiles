@echo off

rem --- pwsh が存在するかチェック ---
if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" (
    set WT_SHELL=pwsh.exe
) else (
    set WT_SHELL=powershell.exe
)

setlocal

set SETTINGS=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

rem --- Windows Terminal の colorScheme を取得 ---
for /f "tokens=*" %%A in ('pwsh -NoLogo -NoProfile -Command ^
  "(Get-Content $env:SETTINGS -Raw | ConvertFrom-Json).profiles.list | Where-Object { $_.guid -eq $env:WT_PROFILE_ID } | Select-Object -ExpandProperty colorScheme"') do (
    set WT_THEME=%%A
)

rem --- 取得できなかったら、デフォルトの colorScheme を取得 ---
if "%WT_THEME%"=="" (
    for /f "tokens=*" %%A in ('pwsh -NoLogo -NoProfile -Command ^
      "(Get-Content $env:SETTINGS -Raw | ConvertFrom-Json).profiles.defaults.colorScheme"') do (
        set WT_THEME=%%A
    )
)

rem --- Vim/Nvim 用の colorscheme 名を自動生成 ---
if "%WT_THEME%"=="Dracula"             set VIM_COLORSCHEME=dracula
if "%WT_THEME%"=="Iceberg"             set VIM_COLORSCHEME=iceberg
if "%WT_THEME%"=="Tokyo Night"         set VIM_COLORSCHEME=tokyonight
if "%WT_THEME%"=="Tokyo Night Storm"   set VIM_COLORSCHEME=tokyonight
if "%WT_THEME%"=="Tokyo Night Light"   set VIM_COLORSCHEME=tokyonight

rem --- 汎用ルール（その他のテーマ） ---
if "%VIM_COLORSCHEME%"=="" (
    set VIM_COLORSCHEME=%WT_THEME: =-%
    set VIM_COLORSCHEME=%WT_THEME: =-%
    set VIM_COLORSCHEME=%VIM_COLORSCHEME:"=%
    set VIM_COLORSCHEME=%VIM_COLORSCHEME:~0,-0%
    set VIM_COLORSCHEME=%VIM_COLORSCHEME:~0,-0%
    set VIM_COLORSCHEME=%VIM_COLORSCHEME:~0,-0%
)

echo WT_THEME=%WT_THEME%
echo VIM_COLORSCHEME=%VIM_COLORSCHEME%

rem --- doskey マクロを読み込む ---
doskey /macrofile=%USERPROFILE%\macros.txt

endlocal & set WT_THEME=%WT_THEME% & set VIM_COLORSCHEME=%VIM_COLORSCHEME%



