@echo off
set CONF="%~dp0aria2.conf"
set BACKUP="%~dp0aria2.conf.backup"
findstr ".*" %BACKUP% >nul 2>nul && (findstr /v "^$ ^#" %BACKUP% > %CONF% & exit)
findstr ".*" %CONF% >nul 2>nul && (move /y %CONF% %BACKUP% >nul 2>nul & findstr /v "^$ ^#" %BACKUP% > %CONF% & exit)
exit
