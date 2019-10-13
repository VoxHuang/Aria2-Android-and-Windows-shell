@echo off
if "%1"=="h" (goto COMMAND) else (mshta vbscript:createobject^("wscript.shell"^).run^("%~fs0 h",0^)^(window.close^)&exit)
:COMMAND
cd /d "%~dp0"
error.wsf 2>nul
exit
