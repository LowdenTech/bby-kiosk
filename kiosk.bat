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
echo 3. Check for Update
echo 4. Update Products
echo 5. Exit
echo.
set /p a="Enter a selection: "
echo.
if %a% == 1 goto install
if %a% == 2 goto remove
if %a% == 3 goto update
if %a% == 4 goto skulist
echo Aborting...
pause
exit

:: Install the kiosk program if not already present
:: If already present move to update script
:install

echo Installing bby-kiosk...
if exist %kioskDir% goto update

echo Creating app directory...
mkdir %kioskDir%

echo Copying files to directory...
xcopy /s "dist\*" %kioskDir% > nul

echo Building app files...
call "%kioskDir%\scripts\build.bat"

echo Scheduling background tasks...
schtasks /create /sc ONIDLE /tn "bby-kiosk" /tr "%kioskDir%\scripts\NoShell.vbs %kioskDir%\scripts\autorun.bat" /i 10

echo Opening Edge in kiosk mode...
"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --kiosk "%AppData%\bby-kiosk\kiosk.html" --no-first-run
goto end

:: Remove the kiosk program from the computer completely
:remove
echo Removing bby-kiosk...
if exist %kioskDir% (
    rmdir /s /q %kioskDir%
) else (
    echo No existing version of bby-kiosk was found on this machine
)
goto end

:: Check if a version of kiosk program exists and update it
:: If not, move to install script
:update
if not exist %kioskDir% (
    echo No existing version of bby-kiosk was found on this machine
    goto install
)
echo Checking for updates...
goto end

:: Update the list of skus to display on the program
:skulist
call "%AppData%/dist/scripts/skulist.bat"
goto end

:end
echo Operation completed successfully
pause