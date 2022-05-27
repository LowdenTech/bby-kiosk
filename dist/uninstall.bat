:: Copyright Michael Lowden (LowdenTech) May 2022
:: Created on May 20, 2022

@echo off

set kioskDir="%AppData%\bby-kiosk"

:: Remove the kiosk program from the computer completely
:remove
echo Removing bby-kiosk...
if exist %kioskDir% (
    echo Deleting app directory and all included files...
    rmdir /s /q %kioskDir%
) else (
    echo No existing version of bby-kiosk was found on this machine
)
echo Stoping scheduled tasks...
schtasks /delete /f /tn "bby-kiosk"

echo Operation completed successfully.
pause