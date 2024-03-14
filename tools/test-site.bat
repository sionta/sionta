@echo off
if not exist "%~dp0..\_config.yml" ( exit /b 1 ) else ( cd /d "%~dp0.." )
start "Jekyll Server" bundle exec jekyll serve --open-url --livereload
exit /b %errorlevel%

:update
git submodule update --init --recursive
gem update
gem install jekyll bundler && bundle
bundle update
