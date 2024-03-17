@echo off

if not exist "%~dp0..\_config.yml" (
    echo Cannot found '%~dp0..\_config.yml'.
    exit /b 1
)

cd /d "%~dp0.."

git submodule update --init --recursive

gem install jekyll bundler

bundle install

exit /b %errorlevel%
