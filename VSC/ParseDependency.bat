@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

set "config=%~dp0Config.ini"
call :parseConfig "%config%" "VSTAR_XML_FILES" "%content%"
call :setArgs "-e" "%content%" "%arguments%"
echo %arguments%

call :parseConfig "%config%" "WORKSPACE_FOLDERS" "%content%"
call :getFileList "%content%" "%filelist%"
call :setArgs "-a" "%filelist%" "%arguments%"
echo %arguments%

:parseConfig <config> <section> <content>
REM 读取配置文件
set "lconfig=%~1"
set "lsection=%~2"
set "lcontent="
set "lactive=0"
for /f "delims=" %%a in (%lconfig%) do (
    set "line=%%a"
    if "!lactive!"=="1" (
        REM 判断当前行是否以[开头
        if "!line:~0,1!"=="[" (
            set "lactive=0"
        ) else (
            set "lcontent=!lcontent!,!line!"
        )
    )

    REM 判断当前行是否等于期望的配置项
    if "%%a"=="[%lsection%]" set "lactive=1"
)
set "content=!lcontent:~1!"
exit /b

:setArgs <flag> <content> <arguments>
set "lflag=%~1"
set "lcontent=%~2"
set "larguments="
:setArgs_loop
if defined lcontent (
    for /f "tokens=1* delims=," %%a in ("!lcontent!") do (
        set "larguments=!larguments! %lflag% %%a"
        set "lcontent=%%b"
    )
    goto :setArgs_loop
)
set "larguments=!larguments:~1!"
set "arguments=%larguments%"
exit /b

:getFileList <folders> <filelist>
set "lfolders=%~1"
:getFileList_loop
if defined lfolders (
    for /f "tokens=1* delims=," %%a in ("!lfolders!") do (
        set "lfolder=%%a"
        for /r %lfolder% %%F in (*.arxml) do (
            set "file=%%F"
            set "filelist=!filelist!,!file!"
        )
        set "lfolders=%%b"
    )
    goto :getFileList_loop
)
set "filelist=!filelist:~1!"
exit /b