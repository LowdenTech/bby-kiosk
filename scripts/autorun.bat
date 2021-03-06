:: Copyright Michael Lowden (LowdenTech) May 2022
:: Created on May 20, 2022

@echo off

set kioskDir="%AppData%\bby-kiosk"
set PATH=%PATH%;"%kioskDir%\dependencies\git\bin"
set configDir="%kioskDir:"=%\config"
set configFile="%configDir:"=%\config.txt"

:: Change Directory
cd %kioskDir%

:: Clean git project folder
git reset
git checkout .

:: Get config settings
for /F "usebackq tokens=1,2 delims==" %%A in (%configFile%) do (
    if not "%%B"=="" (
        if "%%A"=="branch" (
            call :switchbranch %%B
        )
    )
)

:: Check for updates and rebuild the project
git pull

:: Rebuild app using existing config
call "%kioskDir:"=%\scripts\build.bat"

:: Close any instances of edge
taskkill/im msedge.exe /F

:: Open Edge in kiosk mode pointing to kiosk.hmtl file
start msedge "%kioskDir:"=%\kiosk.html" --start-maximized

goto :eof

:: Function declarations

:: Switch what branch of the GitHub repo this project follows
:switchbranch
git switch %1
goto :eof