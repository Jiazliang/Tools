@echo off
:: Set UTF-8 encoding to support special characters
chcp 65001 > nul
:: Enable delayed variable expansion for proper variable handling in loops
setlocal enabledelayedexpansion

:: Set log file path
set "logfile=.\output.log"

:: Clear/create log file
type nul > "%logfile%"

(
    dir /b /s "..\VSC_testbench\SWConfig\*.arxml"
    echo line1
    echo line2
    echo line3
    call .\ticker.exe 1 5
    call .\ticker.exe 6 10
) 2>&1 | powershell -command "$logfile = \"%logfile%\"; $input | ForEach-Object { try { Write-Host $_; Add-Content -Path $logfile -Value $_ -Encoding UTF8 } catch { Write-Host \"Log write failed: $_\" } }"

endlocal
exit /b  0