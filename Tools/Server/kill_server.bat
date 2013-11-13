@echo off

echo Killing Camera Server Processes...

taskkill /F /IM startup_run.exe /T
taskkill /F /IM server.exe /T
taskkill /F /IM server.py /T
taskkill /F /IM timeout.exe /T
taskkill /F /IM cmd.exe /T
taskkill /F /IM timeout.exe /T
