@echo off
setlocal ENABLEEXTENSIONS

echo [1/5] Installing uv...
powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"

echo [2/5] Creating virtual environment...
uv venv

echo [3/5] Activating virtual environment...
call .venv\Scripts\activate.bat

echo [4/5] Installing dependencies from pyproject.toml...
uv add "mcp[cli]" requests

echo [5/5] Writing Claude MCP config...
powershell -ExecutionPolicy Bypass -File write_claude_config.ps1

echo.
echo ✅ Setup completed.
pause
