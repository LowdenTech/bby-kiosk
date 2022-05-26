:: Copyright Michael Lowden (LowdenTech) May 2022
:: Created on May 20, 2022

:: Check for updates and rebuild the project
call "%AppData%\bby-kiosk\scripts\update.bat"

:: Rebuild app using existing config
call "%kioskDir%\scripts\build.bat"

:: Open Edge in kiosk mode pointing to kiosk.hmtl file
"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --kiosk "%AppData%\bby-kiosk\kiosk.html" --edge-kiosk-type=fullscreen --no-first-run