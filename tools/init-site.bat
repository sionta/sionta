@echo off

if not exist "%~dp0..\docs\_config.yml" (
    echo Cannot found '%~dp0..\docs\_config.yml'.
    exit /b 1
)

cd /d "%~dp0..\docs"

git submodule update --init --recursive

gem install jekyll bundler

bundle install

exit /b %errorlevel%
