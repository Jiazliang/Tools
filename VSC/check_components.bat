@echo off
:: Set UTF-8 encoding to support special characters
chcp 65001 > nul

set "all=BswM,EcuM,Os,Rte"
set "modules=Rte,Os"
call :check_components "%all%" "%modules%" "valid"
if defined valid echo %valid%

:: Exit the script
exit /b 0


:check_components
    setlocal enabledelayedexpansion
    :: Define the variables 'all' and 'modules'
    set "all=%~1%"
    set "modules=%~2%"

    :: Convert 'all' and 'modules' into arrays for easier processing
    for %%a in (%all%) do (
        set "all_%%a=1"
    )
    for %%m in (%modules%) do (
        set "module_%%m=1"
    )

    :: Initialize a flag to track if all components are found
    set "all_found=true"

    :: Check if each component in 'modules' exists in 'all'
    for %%m in (%modules%) do (
        if not defined all_%%m (
            echo Component '%%m' not found in 'all'.
            set "all_found=false"
        )
    )

    :: Output the result based on the flag
    if "%all_found%"=="true" (
        echo All components in 'modules' are found in 'all'.
    ) else (
        echo Not all components in 'modules' are found in 'all'.
    )
    endlocal & set "%~3=%all_found%"
    exit /b  0