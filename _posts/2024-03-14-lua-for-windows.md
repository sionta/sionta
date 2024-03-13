---
title: How to build Lua for Windows
author: sionta
categories: [Tutorial, Developer]
tags: [programming]
image:
  alt: Lua Logo
  path: https://www.lua.org/images/lua30.gif
pin: false
toc: true
---

## What is Lua?

Lua is a powerful, efficient, lightweight, embeddable scripting language. It supports procedural programming, object-oriented programming, functional programming, data-driven programming, and data description.

Lua combines simple procedural syntax with powerful data description constructs based on associative arrays and extensible semantics. Lua is dynamically typed, runs by interpreting bytecode with a register-based virtual machine, and has automatic memory management with incremental garbage collection, making it ideal for configuration, scripting, and rapid prototyping. [1](https://www.lua.org/about.html)

## Installation

### Prerequisites

- Internet connection for auto download the source file.
- `mingw32-make.exe`{: .filepath } from <https://www.mingw-w64.org/downloads/> or <https://jmeubank.github.io/tdm-gcc/>.
- `curl.exe`{: .filepath } from <https://curl.se/windows/>.
- `tar.exe`{: .filepath } from <https://gnuwin32.sourceforge.net/packages/gtar.htm>.

> In Windows 10 Build 17063 or later, `curl.exe`{: .filepath } and `tar.exe`{: .filepath } have been added. Make sure to `mingw32-make.exe`{: .filepath } they are included in the system PATH.
{: .prompt-info}

### Building

1. Copy and save the script below with the filename `build.bat`
2. Open the Command Prompt and run `build.bat`
3. The resulting directory structure of the build:

    ```
    lua
    ├─ {version}
    │  ├── bin
    │  ├── doc
    │  ├── include
    │  └── lib
    build.bat
    lua-{release}
    lua-{release}.tar.gz
    ```

#### Scripts

```shell
@echo off
setlocal enableextensions

for %%I in (mingw32-make.exe) do if "%%~$PATH:I"=="" (
    echo Ensure that mingw32-make.exe is installed and has been added to the system PATH before running this script.
    echo For downloading, visit https://www.mingw-w64.org/downloads/ or https://jmeubank.github.io/tdm-gcc/download/
    exit /b 1
)

set "WORK_DIR=%~dp0"
set "WORK_DIR=%WORK_DIR:~0,-1%"

cd /d "%WORK_DIR%"

rem Lua release and version. You can only change the RELEASE variable and nothing else
set "RELEASE=5.4.6"
set "VERSION=%RELEASE:~0,3%"

rem Prefer using the base name instead of an absolute path.
set "BASENAME=lua-%RELEASE%"

if not exist "%BASENAME%.tar.gz" curl -L -R -O https://www.lua.org/ftp/%BASENAME%.tar.gz
if %errorlevel% neq 0 exit /b %errorlevel%

if exist "%BASENAME%" rmdir /s /q "%BASENAME%"
tar zxf "%BASENAME%.tar.gz"
if %errorlevel% neq 0 exit /b %errorlevel%

cd "%BASENAME%"

mingw32-make PLAT=mingw
if %errorlevel% neq 0 exit /b %errorlevel%

rem Set up the installation with absolute path for directories.
set "INSTALL_DIR=%WORK_DIR%\lua\%VERSION%"

if exist "%INSTALL_DIR%" rmdir /s /q "%INSTALL_DIR%"

for %%I in (bin doc lib include) do (
    call set "_var=%%I"
    call set "_var=INSTALL_%%_var:~0,3%%"
    call set "%%_var%%=%INSTALL_DIR%\%%I"
    if not exist "%INSTALL_DIR%\%%I" mkdir "%INSTALL_DIR%\%%I"
)

set "TO_LIB=liblua.a"
set "TO_BIN=lua.exe luac.exe lua54.dll liblua.a"
set "TO_INC=lua.h luaconf.h lualib.h lauxlib.h lua.hpp"

cd src
for %%i in (%TO_BIN%) do copy /b /y "%%~fi" "%INSTALL_BIN%" 1>nul
for %%i in (%TO_LIB%) do copy /b /y "%%~fi" "%INSTALL_LIB%" 1>nul
for %%i in (%TO_INC%) do copy /b /y "%%~fi" "%INSTALL_INC%" 1>nul
for %%i in (..\doc\*) do copy /b /y "%%~fi" "%INSTALL_DOC%" 1>nul

echo %~n0:   Version: %RELEASE%
echo %~n0:    Prefix: %INSTALL_DIR%
echo %~n0:  Binaries: %INSTALL_BIN%
echo %~n0: Libraries: %INSTALL_LIB%
echo %~n0:  Includes: %INSTALL_INC%

endlocal & ( rem Redefined before localization
  set "INSTALL_DIR=%INSTALL_DIR%"
  set "INSTALL_BIN=%INSTALL_BIN%"
  set "INSTALL_LIB=%INSTALL_LIB%"
  set "INSTALL_INC=%INSTALL_INC%"
)

rem Permanently assigns the Lua paths to the current user.
for /f "tokens=2*" %%A in ('reg query HKCU\Environment /v Path') do set "REG_PATH=%%B"
setx PATH "%REG_PATH%;%INSTALL_BIN%;%INSTALL_LIB%;%INSTALL_DIR%\clibs"
setx PATHEXT "%PATHEXT%;.wlua;.lexe"
setx LUA_DEV "%INSTALL_DIR%"
setx LUA_PATH ".\?.lua;.\?.luac;%INSTALL_DIR%\?.lua"
setx LUA_CPATH ".\?.dll;%INSTALL_DIR%\?.dll;%INSTALL_LIB%\?.dll"

rem Testing running executeable Lua
"%INSTALL_BIN%\lua.exe" -v
"%INSTALL_BIN%\lua.exe" -e "print('You see this. Lua has been successfully installed!')"

exit /b %errorlevel%
```
{: file='build.bat'}
