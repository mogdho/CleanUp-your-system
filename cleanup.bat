@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title System Optimizer - Core 3.2 Edition
mode con: cols=100 lines=50
color 0B

:: Admin Check - Failsafe
net session >nul 2>&1 || (
    color 0C
    echo.
    echo  [CRITICAL ERROR] Administrator privileges required. Please run as Admin.
    echo.
    pause
    exit
)

echo.
echo  ================================================================================
echo   SYSTEM OPTIMIZER [Core 3.2 Edition]
echo   Target Hardware: i5-13450HX ^| RTX 4060 ^| NVMe SSD
echo  ================================================================================
echo.

:: Capture initial free space (bytes via PowerShell)
for /f %%a in ('powershell -NoProfile -Command "(Get-PSDrive C).Free"') do set "SPACE_BEFORE=%%a"

:: Initializing Log File on Desktop (append mode - preserves history)
set "LOGFILE=%UserProfile%\Desktop\Cleanup_Report.txt"
echo. >> "%LOGFILE%"
echo ================================================================ >> "%LOGFILE%"
echo  Optimization Run: %date% at %time% >> "%LOGFILE%"
echo ================================================================ >> "%LOGFILE%"

set "TOTAL=9"
set "ERRORS=0"

:: ======================== STEP 1/9 ========================
set "STEP=1"
call :ProgressBar !STEP! !TOTAL!
echo  [!STEP!/!TOTAL!] Flushing System ^& User Temporary Files...
del /s /f /q "%temp%\*.*" >nul 2>&1
for /d %%p in ("%temp%\*") do rmdir /s /q "%%p" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%p in ("C:\Windows\Temp\*") do rmdir /s /q "%%p" >nul 2>&1
echo  [OK] Core temporary files flushed. >> "%LOGFILE%"

:: ======================== STEP 2/9 ========================
set "STEP=2"
call :ProgressBar !STEP! !TOTAL!
echo  [!STEP!/!TOTAL!] Optimizing Developer ^& Local AI Environments...
if exist "%AppData%\npm-cache" (
    rd /s /q "%AppData%\npm-cache" >nul 2>&1
    if !errorlevel! neq 0 (
        echo  [WARN] npm cache: partial cleanup ^(files in use^). >> "%LOGFILE%"
        set /a "ERRORS+=1"
    ) else (
        echo  [OK] npm cache cleared. >> "%LOGFILE%"
    )
) else (
    echo  [SKIP] npm cache not found. >> "%LOGFILE%"
)
if exist "%LocalAppData%\pip\Cache" (
    rd /s /q "%LocalAppData%\pip\Cache" >nul 2>&1
    if !errorlevel! neq 0 (
        echo  [WARN] pip cache: partial cleanup ^(files in use^). >> "%LOGFILE%"
        set /a "ERRORS+=1"
    ) else (
        echo  [OK] pip cache cleared. >> "%LOGFILE%"
    )
) else (
    echo  [SKIP] pip cache not found. >> "%LOGFILE%"
)
if exist "%LocalAppData%\Ollama\logs" (
    del /q /s /f "%LocalAppData%\Ollama\logs\*.*" >nul 2>&1
    echo  [OK] Ollama logs cleared. >> "%LOGFILE%"
) else (
    echo  [SKIP] Ollama logs not found. >> "%LOGFILE%"
)

:: ======================== STEP 3/9 ========================
set "STEP=3"
call :ProgressBar !STEP! !TOTAL!
echo  [!STEP!/!TOTAL!] Cleaning Windows Update Cache...
net stop wuauserv >nul 2>&1
if !errorlevel! neq 0 (
    echo  [WARN] Could not stop Windows Update service. >> "%LOGFILE%"
    set /a "ERRORS+=1"
) else (
    :: Wait for service to fully stop (max 15 seconds)
    set "_wuWait=0"
    :WaitForWU
    powershell -NoProfile -Command "if((Get-Service wuauserv).Status -eq 'Stopped'){exit 0}else{exit 1}" >nul 2>&1
    if !errorlevel! equ 0 goto :WUReady
    set /a "_wuWait+=1"
    if !_wuWait! geq 5 (
        echo  [WARN] Timed out waiting for Windows Update to stop. >> "%LOGFILE%"
        set /a "ERRORS+=1"
        goto :WUDone
    )
    timeout /t 3 /nobreak >nul
    goto :WaitForWU
    :WUReady
    rd /s /q "%SystemRoot%\SoftwareDistribution\Download" >nul 2>&1
    mkdir "%SystemRoot%\SoftwareDistribution\Download" >nul 2>&1
    echo  [OK] Windows Update cache cleared. >> "%LOGFILE%"
    :WUDone
    net start wuauserv >nul 2>&1
    if !errorlevel! neq 0 (
        echo  [WARN] Windows Update service failed to restart. >> "%LOGFILE%"
        set /a "ERRORS+=1"
    ) else (
        echo  [OK] Windows Update service restarted. >> "%LOGFILE%"
    )
)

:: ======================== STEP 4/9 ========================
set "STEP=4"
call :ProgressBar !STEP! !TOTAL!
echo  [!STEP!/!TOTAL!] Rebuilding Graphics Shader Cache...
if exist "%LocalAppData%\NVIDIA\DXCache" (
    del /q /s /f "%LocalAppData%\NVIDIA\DXCache\*.*" >nul 2>&1
    echo  [OK] NVIDIA DXCache cleared. >> "%LOGFILE%"
) else (
    echo  [SKIP] NVIDIA DXCache not found. >> "%LOGFILE%"
)
if exist "%LocalAppData%\D3DSCache" (
    del /q /s /f "%LocalAppData%\D3DSCache\*.*" >nul 2>&1
    echo  [OK] D3DS shader cache cleared. >> "%LOGFILE%"
) else (
    echo  [SKIP] D3DSCache not found. >> "%LOGFILE%"
)

:: ======================== STEP 5/9 ========================
set "STEP=5"
call :ProgressBar !STEP! !TOTAL!
echo  [!STEP!/!TOTAL!] Sanitizing Browser Caches...
:: Detect and warn if browsers are running before killing
set "BROWSER_KILLED=0"
tasklist /FI "IMAGENAME eq chrome.exe" 2>nul | findstr /I "chrome.exe" >nul 2>&1
if !errorlevel! equ 0 (
    echo  [!] Chrome is running - closing to clean cache...
    taskkill /F /IM "chrome.exe" >nul 2>&1
    set "BROWSER_KILLED=1"
)
tasklist /FI "IMAGENAME eq msedge.exe" 2>nul | findstr /I "msedge.exe" >nul 2>&1
if !errorlevel! equ 0 (
    echo  [!] Edge is running - closing to clean cache...
    taskkill /F /IM "msedge.exe" >nul 2>&1
    set "BROWSER_KILLED=1"
)
if !BROWSER_KILLED! equ 1 timeout /t 2 /nobreak >nul
:: Clean Chrome cache - all profiles, correct modern paths
for /d %%p in ("%LocalAppData%\Google\Chrome\User Data\*") do (
    if exist "%%p\Cache\Cache_Data" del /q /s /f "%%p\Cache\Cache_Data\*.*" >nul 2>&1
    if exist "%%p\Code Cache" rd /s /q "%%p\Code Cache" >nul 2>&1
    if exist "%%p\Cache\*.*" del /q /s /f "%%p\Cache\*.*" >nul 2>&1
)
:: Clean Edge cache - all profiles, correct modern paths
for /d %%p in ("%LocalAppData%\Microsoft\Edge\User Data\*") do (
    if exist "%%p\Cache\Cache_Data" del /q /s /f "%%p\Cache\Cache_Data\*.*" >nul 2>&1
    if exist "%%p\Code Cache" rd /s /q "%%p\Code Cache" >nul 2>&1
    if exist "%%p\Cache\*.*" del /q /s /f "%%p\Cache\*.*" >nul 2>&1
)
echo  [OK] Browser caches sanitized ^(all profiles^). >> "%LOGFILE%"

:: ======================== STEP 6/9 ========================
set "STEP=6"
call :ProgressBar !STEP! !TOTAL!
echo  [!STEP!/!TOTAL!] Emptying Recycle Bin...
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo  [OK] Recycle Bin emptied. >> "%LOGFILE%"

:: ======================== STEP 7/9 ========================
set "STEP=7"
call :ProgressBar !STEP! !TOTAL!
echo  [!STEP!/!TOTAL!] Flushing DNS Resolver Cache...
ipconfig /flushdns >nul 2>&1
if !errorlevel! neq 0 (
    echo  [WARN] DNS cache flush encountered an error. >> "%LOGFILE%"
    set /a "ERRORS+=1"
) else (
    echo  [OK] DNS resolver cache flushed. >> "%LOGFILE%"
)

:: ======================== STEP 8/9 ========================
set "STEP=8"
call :ProgressBar !STEP! !TOTAL!
echo  [!STEP!/!TOTAL!] Purging Thumbnail ^& Icon Cache...
:: Kill explorer to release file locks on thumbcache/iconcache .db files
echo  [!] Temporarily stopping Windows Explorer...
taskkill /F /IM "explorer.exe" >nul 2>&1
timeout /t 2 /nobreak >nul
:: Delete the now-unlocked cache files
del /f /s /q /a "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
del /f /s /q /a "%LocalAppData%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
:: Restart explorer
start "" explorer.exe
timeout /t 2 /nobreak >nul
echo  [OK] Thumbnail and icon caches purged. >> "%LOGFILE%"

:: ======================== STEP 9/9 ========================
set "STEP=9"
call :ProgressBar !STEP! !TOTAL!
echo  [!STEP!/!TOTAL!] Executing NVMe TRIM Command...
powershell -NoProfile -Command "Optimize-Volume -DriveLetter C -ReTrim -Verbose" >nul 2>&1
if !errorlevel! neq 0 (
    echo  [WARN] SSD TRIM may not have completed fully. >> "%LOGFILE%"
    set /a "ERRORS+=1"
) else (
    echo  [OK] SSD TRIM operation completed. >> "%LOGFILE%"
)

:: ======================== RESULTS ========================
:: Capture final free space
for /f %%a in ('powershell -NoProfile -Command "(Get-PSDrive C).Free"') do set "SPACE_AFTER=%%a"

echo.
call :ProgressBar !TOTAL! !TOTAL!
echo.
color 0A
echo  ================================================================================
echo   SYSTEM OPTIMIZATION COMPLETE!
echo  ================================================================================
echo.

:: Calculate and display space reclaimed (done in PowerShell to handle large numbers)
for /f "delims=" %%r in ('powershell -NoProfile -Command "$f=[long]%SPACE_AFTER%-[long]%SPACE_BEFORE%;if($f -gt 1GB){'{0:N2} GB' -f ($f/1GB)}elseif($f -gt 1MB){'{0:N2} MB' -f ($f/1MB)}elseif($f -gt 0){'Less than 1 MB'}else{'No measurable space change'}"') do set "FREED=%%r"
echo  [SPACE RECLAIMED] !FREED!
echo  [SPACE RECLAIMED] !FREED! >> "%LOGFILE%"

if !ERRORS! gtr 0 (
    echo  [WARNINGS] !ERRORS! operation^(s^) had warnings. Check the log for details.
    echo  [WARNINGS] !ERRORS! warning^(s^) during this run. >> "%LOGFILE%"
) else (
    echo  [STATUS] All operations completed successfully.
    echo  [STATUS] All operations completed without errors. >> "%LOGFILE%"
)

echo.
echo  [!] Report saved to: %LOGFILE%
echo.
echo  [SYSTEM STATUS]
powershell -NoProfile -Command "Get-CimInstance Win32_OperatingSystem | Select-Object @{Name='Uptime';Expression={(Get-Date) - $_.LastBootUpTime}} | Format-List"

echo.
echo  Press any key to exit...
pause >nul
exit

:: ========================================
:: Progress Bar Function
:: ========================================
:ProgressBar
set /a "_filled=%~1 * 40 / %~2"
set /a "_empty=40 - _filled"
set /a "_pct=%~1 * 100 / %~2"
set "_bar="
for /l %%i in (1,1,!_filled!) do set "_bar=!_bar!█"
for /l %%i in (1,1,!_empty!) do set "_bar=!_bar!░"
echo  [!_bar!] !_pct!%%
goto :eof
