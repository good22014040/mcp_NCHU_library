@echo off
setlocal ENABLEEXTENSIONS

echo [1/6] 正在安裝 uv...
powershell -ExecutionPolicy ByPass -Command "irm https://astral.sh/uv/install.ps1 | iex"
if errorlevel 1 (
    echo ❌ uv 安裝可能失敗（忽略錯誤，繼續執行）...
)

echo [2/6] 建立虛擬環境...
uv venv
if errorlevel 1 (
    echo ❌ 建立虛擬環境失敗，請確認 uv 已正確安裝
)

echo [3/6] 啟用虛擬環境...
call .venv\Scripts\activate.bat
if errorlevel 1 (
    echo ❌ 無法啟用虛擬環境，請手動檢查 .venv 資料夾
)

echo [4/6] 安裝依賴套件（來自 uv.yaml）...
uv install
if errorlevel 1 (
    echo ❌ 套件安裝失敗，請檢查 uv.yaml 格式或網路連線
)

echo [5/6] 註冊 MCP 工具...
uv run mcp install library_api.py
if errorlevel 1 (
    echo ❌ MCP 註冊失敗，請檢查 library_api.py 是否正常
)

echo [6/6] 啟動伺服器...
uv run python library_api.py
if errorlevel 1 (
    echo ❌ 程式啟動失敗，請檢查有無語法錯誤或缺少套件
)

echo.
echo ✅ 流程結束。請確認上方是否有錯誤訊息。
pause
