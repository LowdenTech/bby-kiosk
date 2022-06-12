:: Copyright Michael Lowden (LowdenTech) June 2022
:: Created on June 6, 2022

@echo off
echo.

set kioskDir="%AppData%\bby-kiosk"
set cacheDir="%kioskDir:"=%\cached"
set logsDir="%kioskDir:"%\logs"

set logFile="%logsDir:"%\availability.txt"
set skulist=%1
set store=%2

:: Check for invalid parameter entries
if "%~1"=="" (
    echo Invalid entry for skulist parameter in availability.bat
) else if "%~2"=="" (
    echo Invalid entry for store parameter in availability.bat
) else if not "%~3"=="" (
    echo Invalid number of parameters passed to availability.bat
)

:: If store number is the default (000) then end script
if %store%==000 goto :eof

:: Ensure cache directory exists before pulling information
if not exist %cacheDir% mkdir %cacheDir%

:: Pull product information for each sku in skulist.txt
for /F "usebackq tokens=*" %%A in (%skulist%) do (
    echo Pulling availability information for %%A from BestBuy.ca...
    curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36" -o "%cacheDir:"=%\%%A.avail" "https://www.bestbuy.ca/ecomm-api/availability/products?accept=application%%2Fvnd.bestbuy.standardproduct.v1%%2Bjson&accept-language=en-CA&locations=%store%&skus=%%A" 2>>nul
    powershell -Command "(gc '%cacheDir:"=%\%%A.avail') -replace '''', '\''' | Out-File -encoding ASCII -NoNewline '%cacheDir:"=%\%%A.avail'"
)