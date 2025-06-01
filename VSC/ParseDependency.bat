@echo off
:: Set UTF-8 encoding to support special characters
chcp 65001 > nul
:: Enable delayed variable expansion for proper variable handling in loops
setlocal enabledelayedexpansion

:: Get the path to Config.ini in the same directory as the batch file
set "config=%~dp0Config.ini"
:: Parse VSTAR_XML_FILES section from config and store in content variable
call :parseConfig "%config%" "VSTAR_XML_FILES" "%content%"
:: Build arguments with -e flag using the parsed content
call :setArgs "-e" "%content%" "%arguments%"
if defined arguments echo arguments:%arguments%

:: Parse WORKSPACE_FOLDERS section from config
call :parseConfig "%config%" "WORKSPACE_BSW_FOLDERS" "%content%"
:: Get list of .arxml files from the workspace folders
call :getFileList "%content%" "%filelist%"
:: Build arguments with -a flag using the file list
call :setArgs "-a" "%filelist%" "%arguments%"
if defined arguments echo arguments:%arguments%

:parseConfig <config> <section> <content>
:: Function to parse a specific section from the config file
set "lconfig=%~1"
set "lsection=%~2"
set "lcontent="
set "lactive=0"
for /f "delims=" %%a in (%lconfig%) do (
    set "line=%%a"
    if "!lactive!"=="1" (
        :: Check if current line starts with [, indicating a new section
        if "!line:~0,1!"=="[" (
            set "lactive=0"
        ) else (
            :: Append the line to content with comma separator
            set "lcontent=!lcontent!,!line!"
        )
    )

    :: Check if current line matches the desired section header
    if "%%a"=="[%lsection%]" set "lactive=1"
)
:: Remove the leading comma from the collected content
if defined lcontent set "content=!lcontent:~1!"
set "content=!lcontent!"
exit /b

:setArgs <flag> <content> <arguments>
:: Function to build command line arguments with a specific flag
set "lflag=%~1"
set "lcontent=%~2"
set "larguments="
:setArgs_loop
if defined lcontent (
    :: Process each item in the comma-separated list
    for /f "tokens=1* delims=," %%a in ("!lcontent!") do (
        :: Add flag and item to arguments string
        set "larguments=!larguments! %lflag% %%a"
        set "lcontent=%%b"
    )
    goto :setArgs_loop
)
:: Remove the leading space and store in output variable
if defined larguments set "larguments=!larguments:~1!"
set "arguments=%larguments%"
exit /b

:getFileList <folders> <filelist>
:: Function to recursively find all .arxml files in given folders
set "lfolders=%~1"
:getFileList_loop
if defined lfolders (
    :: Process each folder in the comma-separated list
    for /f "tokens=1* delims=," %%a in ("!lfolders!") do (
        set "lfolder=%%a"
        :: 转换为完整路径
        for %%P in ("!lfolder!") do set "lfolder=%%~fP"
        :: 添加路径结尾的反斜杠确保路径格式正确
        if not "!lfolder:~-1!"=="\" set "lfolder=!lfolder!\"
        :: Recursively find all .arxml files in current folder
        for /f "delims=" %%F in ('dir /b /s "!lfolder!*.arxml" ^2^>nul') do (
            set "file=%%F"
            set "filelist=!filelist!,!file!"
        )
        set "lfolders=%%b"
    )
    goto :getFileList_loop
)
:: Remove the leading comma from the file list
if defined filelist set "filelist=!filelist:~1!"
exit /b