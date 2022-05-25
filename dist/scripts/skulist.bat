:: Copyright Michael Lowden (LowdenTech) May 2022
:: Created on May 20, 2022

@echo off
echo.

set skulist=%1

set /p main="Enter sku for main product: "
set /p alt1="Enter sku for 1st alternative product: "
set /p alt2="Enter sku for 2nd alternative product: "
set /p alt3="Enter sku for 3rd alternative product: "
set /p alt4="Enter sku for 4th alternative product: "

(
    echo %main%
    echo %alt1%
    echo %alt2%
    echo %alt3%
    echo %alt4%
) > %skulist%