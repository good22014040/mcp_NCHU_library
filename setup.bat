@echo off
setlocal ENABLEEXTENSIONS

echo [1/4] Installing uv...
powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
set PATH=%USERPROFILE%\.local\bin;%PATH%

echo [2/4] Creating virtual environment...
uv venv

echo [3/4] Activating virtual environment...
call .venv\Scripts\activate.bat

echo [4/4] Installing dependencies with uv add...
uv init
uv add "mcp[cli]" httpx requests

echo.
echo Setup complete.
pause
