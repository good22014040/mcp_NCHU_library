@echo off
setlocal ENABLEEXTENSIONS

echo [1/5] Installing uv...
powershell -ExecutionPolicy ByPass -Command "irm https://astral.sh/uv/install.ps1 | iex"

echo [2/5] Creating virtual environment...
uv venv

echo [3/5] Activating virtual environment...
call .venv\Scripts\activate.bat

echo [4/5] Installing dependencies from pyproject.toml...
uv pip install

echo [5/5] Registering MCP tool and starting server...
uv run mcp install library_api.py
uv run python library_api.py

echo.
echo Setup complete.
pause
