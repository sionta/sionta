@echo off

if not exist "%~dp0..\docs\_config.yml" (
    echo Cannot found '%~dp0..\docs\_config.yml'.
    exit /b 1
)

cd /d "%~dp0..\docs"

bundle exec jekyll clean && bundle exec jekyll serve --livereload %*

exit /b %errorlevel%
