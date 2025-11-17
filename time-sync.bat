@echo off
echo Syncing time with Windows time server...

:: Stop the Windows Time service
net stop w32time >nul 2>&1

:: Re-register the time service
w32tm /unregister >nul 2>&1
w32tm /register >nul 2>&1

:: Start the Windows Time service
net start w32time >nul 2>&1

:: Force time synchronization
w32tm /resync /force

echo Time sync complete.
pause
