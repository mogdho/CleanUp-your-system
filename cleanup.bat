@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title Legion Ultra Optimizer - Core 3.1 Edition
mode con: cols=110 lines=40
color 0B

:: Admin Check - Failsafe
net session >nul 2>&1 || (
    color 0C
    echo [CRITICAL ERROR] Administrator privileges required. Please run as Admin.
    pause >nul
    exit
)

echo.
echo  ================================================================================
echo   LEGION SYSTEM OPTIMIZER [Core 3.1 Edition]
echo   Target Hardware: i5-13450HX ^| RTX 4060 ^| NVMe SSD
echo  ================================================================================
echo.

:: Initializing Log File on Desktop
set "LOGFILE=%UserProfile%\Desktop\Cleanup_Report.txt"
echo Legion Optimization Run: %date% at %time% > "%LOGFILE%"
echo ------------------------------------------------ >> "%LOGFILE%"

:: 1. Core Windows & User Temp
echo [1/6] Flushing System ^& User Temporary Files...
del /s /f /q "%temp%\*.*" >nul 2>&1
for /d %%p in ("%temp%\*") do rmdir /s /q "%%p" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
echo [OK] Core temporary files flushed. >> "%LOGFILE%"

:: 2. Developer & Local AI Environment Cache
echo [2/6] Optimizing Developer ^& Local AI Environments...
:: Cleans package managers
if exist "%AppData%\npm-cache" rd /s /q "%AppData%\npm-cache" >nul 2>&1
if exist "%LocalAppData%\pip\Cache" rd /s /q "%LocalAppData%\pip\Cache" >nul 2>&1
:: Cleans Ollama temp logs without touching downloaded models (e.g., Qwen)
if exist "%LocalAppData%\Ollama\logs" del /q /s /f "%LocalAppData%\Ollama\logs\*.*" >nul 2>&1
echo [OK] Node, Python, and Ollama caches optimized. >> "%LOGFILE%"

:: 3. Storage Sense & Update Cache
echo [3/6] Running Native Storage Optimization...
net stop wuauserv >nul 2>&1
rd /s /q %SystemRoot%\SoftwareDistribution\Download >nul 2>&1
net start wuauserv >nul 2>&1
cleanmgr /sagerun:1 >nul 2>&1
echo [OK] Windows update cache and Storage Sense executed. >> "%LOGFILE%"

:: 4. Graphics Subsystem Cache
echo [4/6] Rebuilding Graphics Shader Cache...
del /q /s /f "%LocalAppData%\NVIDIA\DXCache\*.*" >nul 2>&1
del /q /s /f "%LocalAppData%\D3DSCache\*.*" >nul 2>&1
echo [OK] RTX Shader and DirectX cache cleared. >> "%LOGFILE%"

:: 5. Browser Deep Clean
echo [5/6] Sanitizing Browser Cache...
taskkill /F /IM "chrome.exe" >nul 2>&1
taskkill /F /IM "msedge.exe" >nul 2>&1
del /q /s /f "%LocalAppData%\Google\Chrome\User Data\Default\Cache\*.*" >nul 2>&1
del /q /s /f "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache\*.*" >nul 2>&1
echo [OK] Web browser caches sanitized. >> "%LOGFILE%"

:: 6. Storage Maintenance (NVMe SSD Trim)
echo [6/6] Executing NVMe TRIM Command...
powershell -Command "Optimize-Volume -DriveLetter C -ReTrim -Verbose" >nul 2>&1
echo [OK] SSD TRIM operation completed successfully. >> "%LOGFILE%"

echo.
color 0A
echo  ================================================================================
echo   SYSTEM OPTIMIZATION COMPLETE!
echo  ================================================================================
echo.
echo  [!] A detailed report has been saved to your Desktop: Cleanup_Report.txt
echo.
echo  [SYSTEM STATUS]
powershell -Command "Get-CimInstance Win32_OperatingSystem | Select-Object @{Name='Uptime';Expression={(Get-Date) - $_.LastBootUpTime}} | Format-List"

timeout /t 6 >nul
exit
