:: Copyright Michael Lowden (LowdenTech) May 2022
:: Created on May 20, 2022

@echo off
echo.

set PATH=%PATH%;"%kioskDir:"=%\bin"

set kioskDir="%AppData%\bby-kiosk"
set cacheDir="%kioskDir:"=%\cached"
set dependenciesDir="%kioskDir:"=%\dependencies"

set kioskFile="%kioskDir:"=%\dependencies\kiosk.js"
set skulist=%1

:: Check for invalid parameter entries
if "%~1"=="" (
    echo Invalid entry for skulist parameter in makejs.bat
) else if not "%~2"=="" (
    echo Invalid number of parameters passed to makejs.bat
)

cat "%dependenciesDir:"=%\base" > %kioskFile%
echo. >> %kioskFile%
printf "let products = [" >> %kioskFile%

for /F "usebackq tokens=*" %%A in (%skulist%) do (
    printf   "'"
    cat      "%cacheDir:"=%\%%A.dat"
    printf   "',"
) >> %kioskFile%

printf "]" >> %kioskFile%
