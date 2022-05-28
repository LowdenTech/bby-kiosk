:: Copyright Michael Lowden (LowdenTech) May 2022
:: Created on May 20, 2022

@echo off

set kioskDir="%AppData%\bby-kiosk"

:: Present main menu to user
:: Check user selection
:: Move to selected location in script
:menu
echo Starting bby-kiosk installation wizard...
echo.
echo Please select an option:
echo.
echo 1. Install
echo 2. Remove
echo 3. Exit
echo.
set /p a="Enter a selection: "
echo.
if %a% == 1 goto install
if %a% == 2 goto remove
echo Aborting...
pause
exit

:: Install the kiosk program if not already present
:install

echo Installing bby-kiosk...
if exist %kioskDir% goto update

echo Creating app directory...
mkdir %kioskDir%

echo Cloning GitHub repository...
git clone -b master https://github.com/LowdenTech/bby-kiosk.git %kioskDir%

echo Building app files...
call "%kioskDir%\scripts\build.bat"

echo Scheduling background tasks...
schtasks /create /f /sc ONIDLE /tn "bby-kiosk" /tr "%kioskDir%\scripts\NoShell.vbs %kioskDir%\scripts\autorun.bat" /i 10

echo Opening Edge in kiosk mode...
"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "%AppData%\bby-kiosk\kiosk.html" --no-first-run
exit

:: Remove the kiosk program from the computer completely
:remove

echo Stoping scheduled tasks...
schtasks /delete /f /tn "bby-kiosk"

echo Removing bby-kiosk...
if exist %kioskDir% (
    echo Deleting app directory and all included files...
    rmdir /s /q %kioskDir%
) else (
    echo No existing version of bby-kiosk was found on this machine
)
