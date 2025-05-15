@echo off
setlocal ENABLEEXTENSIONS

echo [1/4] Installing uv...
powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"

echo [2/4] Creating virtual environment...
uv venv

echo [3/4] Activating virtual environment...
powershell -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force"
call .venv\Scripts\activate.bat

echo [4/4] Installing dependencies with uv add...
uv init
uv add "mcp[cli]" httpx requests

echo Executing Claude config script...
powershell -ExecutionPolicy Bypass -File write_claude_config.ps1

echo.
echo ✅ Setup complete.
pause
