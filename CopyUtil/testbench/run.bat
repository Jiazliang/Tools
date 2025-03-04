@echo off
chcp 65001
echo CopyUtil 自动化测试脚本
echo =====================

setlocal enabledelayedexpansion

:: 获取当前脚本所在目录的绝对路径
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "COPYUTIL=%SCRIPT_DIR:~0,-10%\copyutil.exe"
set "LOG_FILE=%SCRIPT_DIR%\test_results.log"

::echo 当前脚本所在目录: %SCRIPT_DIR%
::echo CopyUtil 路径: %COPYUTIL%
::echo 日志文件路径: %LOG_FILE%

:: 创建日志文件
echo 测试开始时间: %date% %time% > %LOG_FILE%
echo. >> %LOG_FILE%

:: 测试计数器
set /a total_tests=0
set /a passed_tests=0
set /a failed_tests=0

:main
echo 1. 基本功能测试
echo ===============
rmdir /s /q %SCRIPT_DIR%\basic\out
call :run_test "单文件复制" "%COPYUTIL% -s %SCRIPT_DIR%\basic\single -d %SCRIPT_DIR%\basic\out\single -p *.txt" 0
call :run_test "递归目录复制" "%COPYUTIL% -s %SCRIPT_DIR%\basic\recursive -d %SCRIPT_DIR%\basic\out\recursive -p *.txt" 0


echo 2. 边界条件测试
echo ===============
rmdir /s /q %SCRIPT_DIR%\boundary\out
call :run_test "特殊字符处理" "%COPYUTIL% -s %SCRIPT_DIR%\boundary\special -d %SCRIPT_DIR%\boundary\out\special -p *.txt" 0


exit /b

:: 测试用例执行函数
:run_test
set /a total_tests+=1
echo 执行测试: %~1
call %~2
echo.




endlocal