:: Copyright Michael Lowden (LowdenTech) May 2022
:: Created on May 20, 2022

@echo off
echo.

set kioskDir="%AppData%\bby-kiosk"
set configDir="%kioskDir:"=%\config"
set cacheDir="%kioskDir:"=%\cached"
set skulistsDir="%kioskDir:"=%\skulists"
set logsDir="%kioskDir:"=%\logs"

set configFile="%configDir:"=%\config.txt"
set logFile="%logsDir:"=%\build.txt"

echo Checking app structure...

:: Generate basic app directories
if not exist %configDir% mkdir %configDir%
if not exist %cacheDir% mkdir %cacheDir%
if not exist %logsDir% mkdir %logsDir%

echo Loading app configuration...

:: Create config file if one doesn't exist
if not exist %configFile% (
    echo No existing configuration was found
    echo Generating default configuration...
    call :makeconfig
)

:: Set config variables
for /F "usebackq tokens=1,2 delims==" %%A in (%configFile%) do (
    if not "%%B"=="" (
        if "%%A"=="brand" (
            call :setbrand %%B
        ) else if "%%A"=="store" (
            call :setstore %%B
        )
    )
)

:: Validate that config variables were set
:: Set to defaults if necessary
:: Output defaults to config file for redundancy
if "%brand%" == "" (
    echo brand=Custom >> %configFile%
    set brand=Custom
)
if "%store%" == "" (
    echo store=000 >> %configFile%
    set store=000
)

:: If brand name is set to custom, let user set SKUs manually
if %brand%==Custom (
    call ".\skulist.bat"
)

echo Loading skulist...
set skulist="%skulistsDir:"=%\%brand%.txt"

:: If skulist does not exist then end the build script
if not exist %skulist% (
    echo skulist not found
    set timestamp="[%time%]"
    echo %timestamp:"=% ERROR: Could not find skulist: %skulist% >> %logFile%
    goto :eof
)

:: Generate cached product information from skulist
echo Generating cached product information...
call "products.bat" %skulist%

echo Generating cached availability information...
call "availability.bat" %skulist% %store%

:: Make JS files from cached product information
echo Generating JS dependencies...
call "makejs.bat" %skulist%

goto :eof

:: Function declarations below

:: Generate a new config file using defaults
:makeconfig
echo Generating new config.txt file...
(
    echo brand=Custom
    echo store=000
) > %configFile%
goto :eof

:: Set the brand name variable
:setbrand
set brand=%1
goto :eof

:: Set the store number variable
:setstore
set store=%1
goto :eof