:: Run build script to ensure config changes are applied
call "%AppData%\bby-kiosk\scripts\build.bat"

:: Open Edge in kiosk mode pointing to kiosk.hmtl file
"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --kiosk "%AppData%\bby-kiosk\kiosk.html" --no-first-run