@echo off
if not exist "%~dp0..\_config.yml" ( exit /b 1 ) else ( cd /d "%~dp0.." )
if not exist assets\lib\package.json git submodule update --init --recursive
start "Jekyll Server" bundle exec jekyll serve --open-url --livereload
exit /b %errorlevel%

:: gem install bundle
:: bundle install
