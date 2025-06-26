@echo off
:: Silent System Cleanup Utility
:: v2.0 - Enhanced Privacy Edition

:: Check for silent mode
if "%1"=="" (
    start /min cmd /c "%~f0" stealth & exit
)

:: Hide the console window
if "%1"=="stealth" (
    echo >nul 2>&1
    :: Begin silent operations
)

:: Clear Minecraft traces
del /f /q "%AppData%\.minecraft\logs\*.*" >nul 2>&1
del /f /q "%AppData%\.minecraft\launcher_accounts_microsoft_store.json" >nul 2>&1
del /f /q "%AppData%\.minecraft\config\ias.json" >nul 2>&1
rd /s /q "%AppData%\.minecraft\logs" >nul 2>&1

:: Clear TLauncher traces
rd /s /q "%AppData%\.tlauncher\logs" >nul 2>&1

:: Clear miscellaneous files
del /f /q "%AppData%\imgui_log.txt" >nul 2>&1
del /f /q "%AppData%\paths.txt" >nul 2>&1

:: Network cleanup
ipconfig /release >nul 2>&1
timeout /t 3 >nul
ipconfig /renew >nul 2>&1
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1

:: Browser cache cleanup (common browsers)
del /f /q "%LocalAppData%\Google\Chrome\User Data\Default\Cache\*.*" >nul 2>&1
del /f /q "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache\*.*" >nul 2>&1
del /f /q "%AppData%\Mozilla\Firefox\Profiles\*.default-release\cache2\entries\*.*" >nul 2>&1

:: Recent documents cleanup
del /f /q "%AppData%\Microsoft\Windows\Recent\*.*" >nul 2>&1

:: Temp files cleanup
del /f /q "%Temp%\*.*" >nul 2>&1
del /f /q "%SystemRoot%\Temp\*.*" >nul 2>&1

:: Prefetch cleanup (requires admin)
if exist "%SystemRoot%\Prefetch\" (
    del /f /q "%SystemRoot%\Prefetch\*.*" >nul 2>&1
)

:: Event log clearing (requires admin)
wevtutil cl System >nul 2>&1
wevtutil cl Application >nul 2>&1
wevtutil cl Security >nul 2>&1

:: Self-destruct mechanism
(
    echo @echo off
    echo ping 127.0.0.1 -n 3 ^>nul
    echo del /f /q "%~f0" ^>nul 2^>^&1
) > "%Temp%\cleanup.bat"

start /min cmd /c "%Temp%\cleanup.bat" & exit
