@echo off
setlocal enabledelayedexpansion

:: Set log file path
set "logfile=output.log"

:: Clear/create log file
type nul > "%logfile%"

:: Use PowerShell Tee-Object for dual output
echo [!date! !time!] !input! 2>&1 | powershell -command "$input | Tee-Object -FilePath '%logfile%' -Append"
(
    echo line1
    echo line2
    echo line3
) 2>&1 | powershell -command "$input | Tee-Object -FilePath '%logfile%' -Append"

call .\ticker.exe 1 5 2>&1 | powershell -command "$input | ForEach-Object { Write-Host $_; Add-Content -Path '%logfile%' -Value $_ }"

:: Example usage
call :LogAndExecute ".\ticker.exe" "5 10"
exit /b

:: Function to execute command with logging
:LogAndExecute
set "cmd=%~1"
set "args=%~2"
echo Executing: %cmd% %args%
powershell -command "& !cmd! !args! | ForEach-Object { Write-Host $_; Add-Content -Path '%logfile%' -Value $_ }"
exit /b