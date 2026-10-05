@echo off
REM  Uninstaller & Setup Utility v2.0 - double-click this file to start.
REM  It launches Setup.ps1 with execution policy bypassed for this run only.
REM  Setup.ps1 asks for administrator rights itself.
title Uninstaller ^& Setup Utility v2.0
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Setup.ps1" %*
