@echo off
setlocal ENABLEEXTENSIONS

echo [1/6] Installing uv...
powershell -ExecutionPolicy ByPass -Command "irm https://astral.sh/uv/install.ps1 | iex"
if errorlevel 1 (
    echo Failed to install uv.
)

echo [2/6] Creating virtual environment...
uv venv
if errorlevel 1 (
    echo Failed to create virtual environment.
)

echo [3/6] Activating virtual environment...
call .venv\Scripts\activate.bat
if errorlevel 1 (
    echo Failed to activate virtual environment.
)

echo [4/6] Creating pyproject.toml if missing...
if not exist pyproject.toml (
    echo [project]> pyproject.toml
    echo name = "library-api">> pyproject.toml
    echo version = "0.1.0">> pyproject.toml
    echo description = "A simple MCP API for querying NCHU library books">> pyproject.toml
    echo requires-python = ">=3.10">> pyproject.toml
    echo.>> pyproject.toml
    echo dependencies = [>> pyproject.toml
    echo   "mcp[cli]",>> pyproject.toml
    echo   "httpx",>> pyproject.toml
    echo   "requests">> pyproject.toml
    echo ]>> pyproject.toml
)

echo [5/6] Installing dependencies from pyproject.toml...
uv pip install
if errorlevel 1 (
    echo Failed to install dependencies.
)

echo [6/6] Registering MCP tool and starting the server...
uv run mcp install library_api.py
uv run python library_api.py
if errorlevel 1 (
    echo Failed to start the server.
)

echo.
echo Setup complete.
pause
