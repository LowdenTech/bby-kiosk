:: Copyright Michael Lowden (LowdenTech) May 2022
:: Created on May 20, 2022

@echo off
echo.

set kioskDir="%AppData%\bby-kiosk"
set configDir="%kioskDir:"=%\config"
set cacheDir="%kioskDir:"=%\cached"
set skulist="%configDir:"=%\skulist.txt"
set branch="master"
set logFile="%kioskDir:"=%\logs\build.txt"

echo Checking app structure...

if not exist %configDir% mkdir %configDir%
if not exist %cacheDir% mkdir %cacheDir%
if not exist "%kioskDir:"=%\logs" mkdir "%kioskDir:"=%\logs"

echo Loading app configuration...

:: Load either a new configuration or an existing one, if any
:start
if exist %configDir% (
    if not exist "%kioskDir:"=%\config\config.txt" goto makeconfig
    echo Loading config files...
) else (
    echo No config found.
    echo Generating config files...
    mkdir "%kioskDir:"=%\config"
    goto makeconfig
)

:: If skulist does not exist, create a new one using path from config.txt
if not exist %skulist% (
    echo Generating new skulist.txt file...
    call "%kioskDir:"=%\scripts\skulist.bat" %skulist%
)

:: Generate cached product information from skulist
:: If no skulist file is found, log error and exit build phase
if exist %skulist% (
    echo Generating cached information for products...
    call "%kioskDir:"=%\scripts\products.bat" %skulist% %cacheDir%
) else (
    for /F "tokens=2" %%B in ('date /t') do (
        set mydate=%%B
    )
    set timestamp="[%mydate%%time%]"
    echo %timestamp:"=% Build failed. Could not cache product information. Unable to load skufile >> %logFile%
    pause
    exit
)

:: Make JS files from cached product information
:: If no skulist file is found, log error and exit build phase
if exist %skulist% (
    echo Generating JS dependencies...
    call "%kioskDir:"=%\scripts\makejs.bat" %cacheDir%
) else (
    for /F "tokens=2" %%B in ('date /t') do (
        set mydate=%%B
    )
    set timestamp="[%mydate%%time%]"
    echo %timestamp:"=% Build failed. Could not make JS dependencies. Unable to load skufile >> %logFile%
    pause
    exit
)

goto end

:: Generate a new config file in the config directory
:makeconfig
echo Generating new config.txt file...
(
    echo *Change which GitHub branch to pull from
    echo branch=%branch%
    echo *Change the filepath for the skulist.txt file
    echo skulist=%skulist%
    echo *Change the location of the cached product information
    echo cache=%cacheDir%
) > "%configDir:"=%\config.txt"
goto start

:end