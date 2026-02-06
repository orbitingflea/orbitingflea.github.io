@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
pushd "%SCRIPT_DIR%"

set "RUBY_BIN=C:\Ruby32-x64\bin"
if exist "%RUBY_BIN%\ruby.exe" (
  set "PATH=%RUBY_BIN%;%PATH%"
)

where ruby >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Ruby was not found on PATH.
  echo Install Ruby 3.2.x with DevKit, then retry.
  popd
  exit /b 1
)

where bundle >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Bundler was not found on PATH.
  echo Run: gem install bundler
  popd
  exit /b 1
)

echo Starting local Jekyll server...
set "HOST=localhost"
set "PORT=4000"
echo URL: http://%HOST%:%PORT%
echo Press Ctrl+C to stop.
echo.

start "" "http://%HOST%:%PORT%"
bundle exec jekyll serve -l --host %HOST% --port %PORT% --config "_config.yml,_config.dev.yml"
set "EXIT_CODE=%ERRORLEVEL%"

popd
exit /b %EXIT_CODE%
