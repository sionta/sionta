@echo off
if "%~1"=="" exit /b 1

setlocal enabledelayedexpansion

set "baseName=%~n1"
set "nowDate=%date%"
set "formatDate="

echo:%nowDate%| >nul findstr "^[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]$"
if %errorlevel% equ 0 set "formatDate=dd/mm/yyyy"
echo:%nowDate%| >nul findstr "^[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9]$"
if %errorlevel% equ 0 set "formatDate=yyyy/mm/dd"

if not defined formatDate exit /b 1

for /f "tokens=1-3 delims=/- " %%a in ("%nowDate%") do (
    if /i "%formatDate%"=="dd/mm/yyyy" (
        set "day=%%a"
        set "month=%%b"
        set "year=%%c"
    )
    if /i "%formatDate%"=="yyyy/mm/dd" (
        set "year=%%a"
        set "month=%%b"
        set "day=%%c"
    )
)

set "fileName=%~dp0..\_posts\%year%-%month%-%day%-%baseName%.md"

if exist "%fileName%" (
    echo Error: File name '%baseName%' already exist.
    exit /b 1
)

set "titleName=%baseName%"
set "titleName=%titleName:_= %"
set "titleName=%titleName:-= %"
set "titleName=%titleName:\= %"
set "titleName=%titleName:/= %"

>"%fileName%" (
    chcp 65001 >nul
    echo:---
    echo:title: %titleName%
    echo:categories: [TopCategorie, SubCategorie]
    echo:tags: [sample] # always use lower-case
    echo:# img_path: # e,g. /assets/img/posts
    echo:# image: # e,g. /banner_computer.gif
    echo:pin: false
    echo:toc: false
    echo:---
    echo:
    echo:## %titleName%
    chcp 437 >nul
)

exit /b 0
