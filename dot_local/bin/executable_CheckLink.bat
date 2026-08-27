@echo off
setlocal

pwsh -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "%~dnp0.ps1"

endlocal

