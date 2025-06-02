@echo off
:: Set UTF-8 encoding to support special characters
chcp 65001 > nul

set "all=BswM,EcuM,Os,Rte,Com"
set "modules=Rte,Os"
call :remove_components "%all%" "%modules%" "result"
echo Result: %result%

:: Exit the script
exit /b 0


:remove_components
    setlocal enabledelayedexpansion
    :: Define the variables 'all' and 'modules'
    set "all=%~1"
    set "modules=%~2"

    :: Convert 'all' and 'modules' into arrays for easier processing
    set "all_array="
    for %%a in (%all%) do (
        set "all_array=!all_array! %%a"
    )
    set "modules_array="
    for %%m in (%modules%) do (
        set "modules_array=!modules_array! %%m"
    )

    :: Create a string to hold the result
    set "result="

    :: Iterate over 'all' components and add to result if not in 'modules'
    for %%a in (%all_array%) do (
        set "found=false"
        for %%m in (%modules_array%) do (
            if "%%a"=="%%m" (
                set "found=true"
            )
        )
        if "!found!"=="false" (
            if defined result (
                set "result=!result!,%%a"
            ) else (
                set "result=%%a"
            )
        )
    )

    endlocal & set "%~3=%result%"
    exit /b 0