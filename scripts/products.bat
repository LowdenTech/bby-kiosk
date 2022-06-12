:: Copyright Michael Lowden (LowdenTech) May 2022
:: Created on May 20, 2022

@echo off
echo.

set kioskDir="%AppData%\bby-kiosk"
set cacheDir="%kioskDir:"=%\cached"
set logsDir="%kioskDir:"%\logs"

set logFile="%logsDir:"%\products.txt"
set skulist=%1

:: Check for invalid parameter entries
if "%~1"=="" (
    echo Invalid entry for skulist parameter in product.bat
) else if not "%~2"=="" (
    echo Invalid number of parameters passed to product.bat
)

:: Ensure cache directory exists before pulling information
if not exist %cacheDir% mkdir %cacheDir%

:: Pull product information for each sku in skulist.txt
for /F "usebackq tokens=*" %%A in (%skulist%) do (
    echo Pulling product information for %%A from BestBuy.ca...
    curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36" -o "%cacheDir:"=%\%%A.dat" "https://www.bestbuy.ca/api/v2/json/product/%%A" 2>>nul
    powershell -Command "(gc '%cacheDir:"=%\%%A.dat') -replace '''', '\''' | Out-File -encoding ASCII -NoNewline '%cacheDir:"=%\%%A.dat'"
)