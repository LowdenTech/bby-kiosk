:: Copyright Michael Lowden (LowdenTech) May 2022
:: Created on May 20, 2022

set kioskDir="%AppData%\bby-kiosk"
set configDir="%kioskDir:"=%\config"
set configFile="%configDir:"=%\config.txt"
set branch="master"

:: Get config settings

for /F "tokens=1,2 delims==" %%A in (%configFile:"=%) do (
    if not "%%B"=="" (
        if "%%A"=="branch" (
            call :setbranch %%B
        )
    )
)
goto :autorun

:setbranch
set branch="%1"
goto :eof

:autorun
:: Check for updates and rebuild the project
call "%AppData%\bby-kiosk\scripts\update.bat" %branch%

:: Rebuild app using existing config
:: call "%kioskDir%\scripts\build.bat"

:: Open Edge in kiosk mode pointing to kiosk.hmtl file
:: "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --kiosk "%AppData%\bby-kiosk\kiosk.html" --edge-kiosk-type=fullscreen --no-first-run