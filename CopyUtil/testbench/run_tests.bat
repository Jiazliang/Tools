@echo off
chcp 65001
echo CopyUtil 自动化测试脚本
echo =====================
pause

setlocal enabledelayedexpansion

:: 获取当前脚本所在目录的绝对路径
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "COPYUTIL=%SCRIPT_DIR%\..\copyutil.exe"
set "LOG_FILE=%SCRIPT_DIR%\test_results.log"

echo 当前脚本所在目录: %SCRIPT_DIR%
echo CopyUtil 路径: %COPYUTIL%
echo 日志文件路径: %LOG_FILE%
pause

call :main

:: 创建日志文件
echo 测试开始时间: %date% %time% > %LOG_FILE%
echo. >> %LOG_FILE%

:: 测试计数器
set /a total_tests=0
set /a passed_tests=0
set /a failed_tests=0

:: 测试用例执行函数
:run_test
setlocal
set "test_name=%~1"
set "cmd=%~2 %~3 %~4 %~5"
echo 命令: %cmd%
set "expected_code=%~6"
endlocal & set /a total_tests+=1
echo 执行测试: %~1
echo 执行测试: %~1 >> %LOG_FILE%
echo 命令: %cmd%
echo 命令: %cmd% >> %LOG_FILE%
call %cmd% > temp.out 2>&1
set "last_error=%errorlevel%"
if %last_error% equ %~5 (
    echo [通过] %~1
    echo [通过] %~1 >> %LOG_FILE%
    endlocal & set /a passed_tests+=1
) else (
    echo [失败] %~1
    echo [失败] %~1 >> %LOG_FILE%
    endlocal & set /a failed_tests+=1
)
type temp.out >> %LOG_FILE%
echo. >> %LOG_FILE%
exit /b

:main
echo 1. 基本功能测试
echo ===============

:: 单文件复制测试
echo "单文件复制" "%COPYUTIL%" "-s %SCRIPT_DIR%\basic\single\txt.txt" "-d %SCRIPT_DIR%\basic\single\out" "-p *.txt" 0
pause
call :run_test "单文件复制" "%COPYUTIL%" "-s %SCRIPT_DIR%\basic\single\txt.txt" "-d %SCRIPT_DIR%\basic\single\out" "-p *.txt" 0
pause

:: 递归目录测试
call :run_test "递归目录复制" "%COPYUTIL%" "-r" "%SCRIPT_DIR%\basic\recursive %SCRIPT_DIR%\basic\recursive_backup" 0

echo 2. 边界条件测试
echo ===============

:: 特殊字符测试
call :run_test "特殊字符处理" "%COPYUTIL%" "%SCRIPT_DIR%\boundary\special\test@#$%.txt" "%SCRIPT_DIR%\boundary\special\backup\" 0

:: 长路径测试
call :run_test "长路径处理" "%COPYUTIL%" "%SCRIPT_DIR%\boundary\longpath\very\long\path\test.txt" "%SCRIPT_DIR%\boundary\longpath\backup\" 0

echo 3. 错误处理测试
echo ===============

:: 源文件不存在测试
call :run_test "源文件不存在" "%COPYUTIL%" "%SCRIPT_DIR%\error\nonexistent.txt" "%SCRIPT_DIR%\error\dest.txt" 1

:: 权限测试
attrib +r %SCRIPT_DIR%\error\permission\readonly.txt
call :run_test "写入权限" "%COPYUTIL%" "%SCRIPT_DIR%\basic\single\source.txt" "%SCRIPT_DIR%\error\permission\readonly.txt" 1
attrib -r %SCRIPT_DIR%\error\permission\readonly.txt

:: 统计结果
echo.
echo 测试结果统计
echo ===========
echo 总测试数: %total_tests%
echo 通过数: %passed_tests%
echo 失败数: %failed_tests%

echo.
echo 测试结果已保存到 %LOG_FILE%

endlocal