# 📚 NCHU 圖書館查詢工具

本專案提供一個 MCP 工具，可在 Claude 中查詢中興大學圖書館的書籍資訊。

---

## 🚀 快速開始(windows)

### Step 0：安裝 Claude.ai 桌面版

請先下載並安裝 Claude 桌面應用程式（必要）：

🔗 [https://claude.ai/download](https://claude.ai/download)

> ✅ 安裝後請登入帳號即可，不需進一步設定。

---

### Step 1：下載本專案

---

### Step 2：執行 `setup.bat`

---

### Step 3：確認或修改 Claude 設定

修改%APPDATA%\Claude\claude_desktop_config.json成以下格式
```json
{
    "mcpServers": {
        "NCHU_library": {
            "command": "uv",
            "args": [
                "--directory",
                "C:\\Users\\User\\Downloads\\mcp\\mcp_NCHU_library",
                "run",
                "library_api.py"
            ]
        }
    }
}
```
🔁 請將 "C:\\Users\\User\\Downloads\\mcp\\mcp_NCHU_library" 替換成此專案的實際完整路徑。
⚠️ 路徑中的 \ 必須使用雙反斜線 \\。