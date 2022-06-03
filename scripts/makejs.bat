:: Copyright Michael Lowden (LowdenTech) May 2022
:: Created on May 20, 2022

@echo off
echo.

set kioskDir="%AppData%\bby-kiosk"
set PATH=%PATH%;"%kioskDir:"=%\bin"
set skulist="%kioskDir:"=%\config\skulist.txt"
set cacheDir=%1
set dependenciesDir="%kioskDir:"=%\dependencies"
set kioskFile="%kioskDir:"=%\dependencies\kiosk.js"

cat "%dependenciesDir:"=%\base" > %kioskFile%
echo. >> %kioskFile%
printf "let products = [" >> %kioskFile%

for /F "usebackq tokens=*" %%A in (%skulist%) do (
    printf   "'"
    cat      "%cacheDir:"=%\%%A.dat"
    printf   "',"
) >> %kioskFile%

printf "]" >> %kioskFile%
