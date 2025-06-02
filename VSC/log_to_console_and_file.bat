@echo off
setlocal enabledelayedexpansion

:: Set log file path
set "logfile=output.log"

:: Clear/create log file
type nul > "%logfile%"

(
    echo line1
    echo line2
    echo line3
    call .\ticker.exe 1 5
    call .\ticker.exe 6 10
) 2>&1 | powershell -command "$input | ForEach-Object { Write-Host $_; Add-Content -Path '%logfile%' -Value $_ -Encoding UTF8 }"

endlocal
exit /b  0