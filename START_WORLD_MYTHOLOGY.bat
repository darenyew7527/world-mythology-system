@echo off
setlocal
cd /d "%~dp0"

if not exist "web\dist\index.html" (
  echo [World Mythology System] Building the local website for first use...
  where npm >nul 2>nul
  if errorlevel 1 (
    echo Node.js and npm are required because the prebuilt website is missing.
    echo Install Node.js LTS, then run this file again.
    pause
    exit /b 1
  )
  pushd web
  call npm install
  if errorlevel 1 goto :build_failed
  call npm run build
  if errorlevel 1 goto :build_failed
  popd
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0SERVE_WORLD_MYTHOLOGY.ps1" -Port 8765
if errorlevel 1 pause
exit /b %errorlevel%

:build_failed
popd
echo Website build failed. Review the messages above, then run this file again.
pause
exit /b 1
