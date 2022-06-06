:: Copyright Michael Lowden (LowdenTech) May 2022
:: Created on May 20, 2022

@echo off
echo.

set skulist=%1

if exist %skulist% goto :eof

echo Generating custom skulist...

echo Instructions: > %skulist%
echo. >> %skulist%
echo 1. Erase all text in this file and replace with your list of SKUs >> %skulist%
echo 2. SKUs should be place one per line in the file >> %skulist%
echo 3. Verify you have entered each SKU correctly >> %skulist%
echo 4. When finished, save the file and exit out of this window >> %skulist%

call "%skulist%"

echo Done.