@echo off
setlocal enabledelayedexpansion

set "file=Config.ini"
set "last_line="

for /f "tokens=*" %%a in ('type "%file%"') do (
    if not "%%a"=="" set "last_line=%%a"
)

echo The last line is: %last_line%
endlocal