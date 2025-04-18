@echo off
setlocal

if "%1"=="__LOGGING_ACTIVE__" (
    set "_LOGGING_ACTIVE=1"
    goto :main_script
)

powershell -NoProfile -Command "& '%~f0' __LOGGING_ACTIVE__ | Tee-Object -FilePath 'Debug.log'"
echo.
echo Log file 'Debug.log' created/updated.
pause
goto :eof

:main_script

docker compose down
set BUILDKIT_PROGRESS=plain
docker compose up --force-recreate --build
pause