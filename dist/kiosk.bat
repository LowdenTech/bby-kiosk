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
echo 1. Remove
echo 2. Check for Update
echo 3. Update Products
echo 4. Exit
echo.
set /p a="Enter a selection: "
echo.
if %a% == 1 goto remove
if %a% == 2 goto update
if %a% == 3 goto skulist
echo Aborting...
pause
exit

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
    goto end
)
echo Checking for updates...
goto end

:: Update the list of skus to display on the program
:skulist
call "%kioskDir%/scripts/skulist.bat"
goto end

:end
echo Operation completed successfully
pause