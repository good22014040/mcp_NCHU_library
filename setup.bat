@echo off
setlocal

REM === Step 1: 安裝 uv（若已安裝會跳過）===
powershell -ExecutionPolicy ByPass -Command "irm https://astral.sh/uv/install.ps1 | iex"

REM === Step 2: 建立虛擬環境在當前資料夾 ===
uv venv

REM === Step 3: 啟用虛擬環境 ===
call .venv\Scripts\activate.bat

REM === Step 4: 安裝 uv.yaml 中列出的套件 ===
uv install

REM === Step 5: 註冊 MCP 工具（根據程式內容）===
uv run mcp install library_api.py

REM === Step 6: 啟動主程式 ===
echo.
echo ✅ 所有準備作業完成，正在啟動伺服器...
uv run python library_api.py
