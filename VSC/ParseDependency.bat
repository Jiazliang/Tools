@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

set "config=%~dp0Config.ini"

set "content="
call :parseConfig %config% VSTAR_SCHEMA_FILES
call :setArgs "-x" "%content%" "%result%"
echo %result%

:parseConfig
REM 读取配置文件
set "active=0"
for /f "delims=" %%a in (%1) do (
    set "line=%%a"
    if "!active!"=="1" (
        REM 判断当前行是否以[开头
        if "!line:~0,1!"=="[" (
            set "active=0"
        ) else (
            set "content=!content!,!line!"
        )
    )

    REM 判断当前行是否等于期望的配置项
    if "%%a"=="[%2]" set "active=1"
)
set "content=!content:~1!"
exit /b

:setArgs <flag> <content> <result>
set "lflag=%~1"
set "lcont=%~2"
set "lres="
for %%A in (%lcont:,= %) do (
    set "lres=!lres! %lflag% %%A"
)
set "lres=!lres:~1!"
set "result=%lres%"
exit /b