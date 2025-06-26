@echo off
:: Ultimate Privacy Cleaner - Nuclear Edition v3.3
:: Includes Brave browser support and forensic-level cleanup

:: [Stealth Module]
if "%1"=="" (
    powershell -window hidden -command "Start-Process cmd -ArgumentList '/c %~f0 stealth' -WindowStyle Hidden" & exit
)

:: [Administrator Check]
NET FILE >nul 2>&1
if %errorlevel% == 0 (
    set ADMIN=true
) else (
    set ADMIN=false
)

:: [Random Delay to Avoid Detection]
set /a delay=%random% %% 11 + 5
timeout /t %delay% >nul

:: [File System Cleaner]
:: - Game Traces
rd /s /q "%AppData%\.minecraft\logs" >nul 2>&1
rd /s /q "%AppData%\.tlauncher" >nul 2>&1
del /f /q "%userprofile%\*.log" >nul 2>&1

:: - Browser Artifacts
call :cleanBrowser "Chrome"
call :cleanBrowser "Edge"
call :cleanBrowser "Firefox"
call :cleanBrowser "BraveSoftware\Brave-Browser" "Brave"

:: - System Traces
del /f /q "%Temp%\*.*" >nul 2>&1
del /f /q "%SystemRoot%\Temp\*.*" >nul 2>&1
del /f /q "%SystemRoot%\Prefetch\*.*" >nul 2>&1
del /f /q "%AppData%\Microsoft\Windows\Recent\*.*" >nul 2>&1

:: [Network Scrubber]
:: - Basic Network
ipconfig /flushdns >nul 2>&1
netsh interface ip delete arpcache >nul 2>&1
netsh winsock reset >nul 2>&1

:: - Advanced Network (if admin)
if "%ADMIN%"=="true" (
    netsh firewall reset >nul 2>&1
    netsh advfirewall reset >nul 2>&1
    netsh int ip reset >nul 2>&1
)

:: - Tor-like IP Cycling
ipconfig /release >nul 2>&1
timeout /t 5 >nul
ipconfig /renew >nul 2>&1

:: [Forensic Countermeasures]
:: - File Shredding
for %%F in (
    "%AppData%\imgui_log.txt"
    "%AppData%\paths.txt"
    "%AppData%\Microsoft\Windows\Recent\*"
) do (
    if exist "%%F" (
        cipher /w:%%F >nul 2>&1
        del /f /q "%%F" >nul 2>&1
    )
)

:: - Log Cleaning (if admin)
if "%ADMIN%"=="true" (
    wevtutil cl System >nul 2>&1
    wevtutil cl Application >nul 2>&1
    wevtutil cl Security >nul 2>&1
    fsutil usn deletejournal /D C: >nul 2>&1
)

:: [Anti-Forensic Tricks]
:: - Timestamp Obfuscation
powershell -command "Get-ChildItem '%AppData%' | ForEach-Object { $_.LastWriteTime = Get-Date }" >nul 2>&1

:: - Registry Cleaner
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /f >nul 2>&1
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths /f >nul 2>&1

:: [Final Phase]
:: - Process Hollowing Detection Bypass
taskkill /f /im ProcessHacker.exe >nul 2>&1
taskkill /f /im Procmon.exe >nul 2>&1

:: - Self-Destruct Sequence
(
    echo Set obj = CreateObject("Scripting.FileSystemObject")
    echo Set ws = CreateObject("WScript.Shell")
    echo ws.Run "cmd /c ping 127.0.0.1 -n 5 >nul & del /f /q ""%~f0"" & del /f /q ""%Temp%\selfdestruct.vbs""", 0, False
)>"%Temp%\selfdestruct.vbs"

start wscript.exe "%Temp%\selfdestruct.vbs"
exit

:: [Functions]
:cleanBrowser
set browser=%1
set alias=%2
if "%alias%"=="" set alias=%browser%

set paths=(
    "Cache"
    "Cookies"
    "History"
    "Local Storage"
    "Web Data"
    "Session Storage"
    "IndexedDB"
    "File System"
    "Service Worker"
    "GPUCache"
)

for %%P in %paths% do (
    rd /s /q "%LocalAppData%\%browser%\User Data\Default\%%P" >nul 2>&1
    del /f /q "%LocalAppData%\%browser%\User Data\Default\%%P.*" >nul 2>&1
    rd /s /q "%LocalAppData%\%browser%\User Data\Profile*\%%P" >nul 2>&1
    del /f /q "%LocalAppData%\%browser%\User Data\Profile*\%%P.*" >nul 2>&1
)

:: Clean Brave-specific items
if "%alias%"=="Brave" (
    del /f /q "%LocalAppData%\%browser%\User Data\Default\BraveWallet" >nul 2>&1
    del /f /q "%LocalAppData%\%browser%\User Data\Default\BraveRewards" >nul 2>&1
)
exit /b
