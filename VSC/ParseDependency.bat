@echo off
:: Set UTF-8 encoding to support special characters
chcp 65001 > nul
:: Enable delayed variable expansion for proper variable handling in loops
setlocal enabledelayedexpansion

:: Get the path to Config.ini in the same directory as the batch file
set "config=%~dp0Config.ini"
:: Parse VSTAR_XML_FILES section from config and store in content variable
call :parseConfig "%config%" "VSTAR_XML_FILES" "content"
:: Build arguments with -e flag using the parsed content
call :setArgs "-e" "%content%" "arguments"
if defined arguments echo arguments:%arguments%

:: Parse WORKSPACE_FOLDERS section from config
call :parseConfig "%config%" "WORKSPACE_BSW_FOLDERS" "content"
:: Get list of .arxml files from the workspace folders
call :getFileList "%content%" "filelist"
:: Build arguments with -a flag using the file list
call :setArgs "-a" "%filelist%" "arguments"
if defined arguments echo arguments:%arguments%

endlocal
exit /b 0


:parseConfig <config> <section> <content>
:: Function to parse a specific section from the config file
setlocal enabledelayedexpansion
set "config=%~1"
set "section=%~2"
set "content="
set "lactive=0"
for /f "delims=" %%a in (%config%) do (
    set "line=%%a"
    if "!lactive!"=="1" (
        :: Check if current line starts with [, indicating a new section
        if "!line:~0,1!"=="[" (
            set "lactive=0"
        ) else (
            :: Append the line to content with comma separator
            set "content=!content!,!line!"
        )
    )

    :: Check if current line matches the desired section header
    if "%%a"=="[%section%]" set "lactive=1"
)
:: Remove the leading comma from the collected content
if defined content set "content=!content:~1!"
endlocal & set "%~3=%content%"
exit /b 0

:setArgs <flag> <content> <arguments>
:: Function to build command line arguments with a specific flag
setlocal enabledelayedexpansion
set "flag=%~1"
set "content=%~2"
set "arguments="
:setArgs_loop
if defined content (
    :: Process each item in the comma-separated list
    for /f "tokens=1* delims=," %%a in ("!content!") do (
        :: Add flag and item to arguments string
        set "arguments=!arguments! %flag% %%a"
        set "content=%%b"
    )
    goto :setArgs_loop
)
:: Remove the leading space and store in output variable
if defined arguments set "arguments=!arguments:~1!"
endlocal & set "%~3=%arguments%"
exit /b 0

:getFileList <folders> <filelist>
:: Function to recursively find all .arxml files in given folders
setlocal enabledelayedexpansion
set "folders=%~1"
:getFileList_loop
if defined folders (
    :: Process each folder in the comma-separated list
    for /f "tokens=1* delims=," %%a in ("!folders!") do (
        set "folder=%%a"
        :: Convert to absolute path
        for %%P in ("!folder!") do set "folder=%%~fP"
        :: Add trailing backslash to ensure correct path format
        if not "!folder:~-1!"=="\" set "folder=!folder!\"
        :: Recursively find all .arxml files in current folder
        for /f "delims=" %%F in ('dir /b /s "!folder!*.arxml" ^2^>nul') do (
            set "file=%%F"
            set "filelist=!filelist!,!file!"
        )
        set "folders=%%b"
    )
    goto :getFileList_loop
)
:: Remove the leading comma from the file list
if defined filelist set "filelist=!filelist:~1!"
endlocal & set "%~2=%filelist%"
exit /b 0