:: Copyright Michael Lowden (LowdenTech) May 2022
:: Created on May 20, 2022

@echo off
echo.

set kioskDir="%AppData%\bby-kiosk"
set logFile="%kioskDir:"=%\logs\products.txt"
set skulist=%1
set cacheDir=%2

:: Check that skulist.txt exists or create a new one
if not exist %skulist% (
    echo Generating new skulist.txt file...
    call "%kioskDir:"=%\scripts\skulist.bat" %skulist%
)

:: Ensure cache directory exists before pulling information
if not exist %cacheDir% mkdir %cacheDir%

:: Log actions for future reference
for /F "tokens=2" %%B in ('date /t') do (
    set mydate=%%B
)
set timestamp="[%mydate%%time%]"
echo %timestamp:"=% Processing cURL requests to bestbuy.ca >> %logFile%

:: Pull product information for each sku in skulist.txt
for /F "usebackq tokens=*" %%A in (%skulist%) do (
    echo Pulling product information for %%A from BestBuy.ca...
    curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36" -o "%cacheDir:"=%\%%A.dat" "https://www.bestbuy.ca/api/v2/json/product/%%A" 2>> %logFile%
    powershell -Command "(gc '%cacheDir:"=%\%%A.dat') -replace '''', '\''' | Out-File -encoding ASCII -NoNewline '%cacheDir:"=%\%%A.dat'"
)