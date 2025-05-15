@echo off
setlocal ENABLEEXTENSIONS

echo [1/5] Installing uv...
powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
if errorlevel 1 (
    echo Failed to install uv.
)

echo [2/5] Creating virtual environment...
uv venv
if errorlevel 1 (
    echo Failed to create virtual environment.
)

echo [3/5] Activating virtual environment...
call .venv\Scripts\activate.bat
if errorlevel 1 (
    echo Failed to activate virtual environment.
)

echo [4/5] Installing dependencies from pyproject.toml...
uv add "mcp[cli]" httpx requests
if errorlevel 1 (
    echo Failed to install dependencies.
)

echo [5/5] Writing Claude MCP server config...

powershell -ExecutionPolicy Bypass -Command ^
try { ^
  $configPath = Join-Path $env:APPDATA 'Claude\\claude_desktop_config.json'; ^
  $currentDir = Convert-Path .; ^
  if (!(Test-Path $configPath)) { ^
    $json = @{ mcpServers = @{ NCHU_library = @{ command = 'uv'; args = @('--directory', $currentDir, 'run', 'library_api.py') } } } | ConvertTo-Json -Depth 5; ^
    $json | Set-Content -Path $configPath -Encoding UTF8 ^
  } else { ^
    $content = Get-Content $configPath -Raw | ConvertFrom-Json; ^
    if (-not $content.mcpServers) { $content | Add-Member -MemberType NoteProperty -Name 'mcpServers' -Value @{} } ^
    $content.mcpServers.NCHU_library = @{ command = 'uv'; args = @('--directory', $currentDir, 'run', 'library_api.py') }; ^
    $content | ConvertTo-Json -Depth 5 | Set-Content -Path $configPath -Encoding UTF8 ^
  } ^
  Write-Host '✅ MCP config written.' ^
} catch { ^
  Write-Host '❌ Failed to write Claude config:' ^
  Write-Host $_.Exception.Message ^
}

echo.
pause
