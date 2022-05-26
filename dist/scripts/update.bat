:: Copyright Michael Lowden (LowdenTech) May 2022
:: Created on May 20, 2022

:: Set PATH variable
set kioskDir="%AppData%\bby-kiosk"
set PATH=%PATH%;"%kioskDir:"=%\bin"
set branch=%1

if branch=="" set branch="master"

:: Pull project files from repo into temp location
git clone --single-branch -b %branch% https://github.com/LowdenTech/bby-kiosk.git "%kioskDir:"=%\temp"

:: Close any instances of edge
taskkill/im msedge.exe

:: Replace app files
xcopy /s /y "%kioskDir:"=%\temp\*" %kioskDir% > nul 

:: Remove temp location
rmdir /s /q "%kioskDir:"=%\temp"