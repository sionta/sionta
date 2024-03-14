@echo off
if "%~1"=="/?" (
    powershell -nop -ex unrestricted -c help "%~dpn0.ps1" -full
) else (
    powershell -nop -ex unrestricted -f "%~dpn0.ps1" %*
)
