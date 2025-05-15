function ConvertTo-TabIndentedJson {
	param (
		[Parameter(Mandatory = $true)]
		$InputObject
	)

	# 先轉成 JSON（標準格式）
	$json = $InputObject | ConvertTo-Json -Depth 10

	# 逐行替換前導空白為 tab
	$lines = $json -split "`n"
	for ($i = 0; $i -lt $lines.Length; $i++) {
		$lines[$i] = $lines[$i] -replace '^(  )+', {
			param($m)
			"`t" * ($m.Value.Length / 2)
		}
	}
	return ($lines -join "`r`n")
}

try {
	$configPath = Join-Path $env:APPDATA 'Claude\claude_desktop_config.json'
	$currentDir = Convert-Path .

	# 新增或載入原始內容
	if (!(Test-Path $configPath)) {
		$content = [PSCustomObject]@{
			mcpServers = @{}
		}
	} else {
		$raw = Get-Content $configPath -Raw
		$content = $raw | ConvertFrom-Json
	}

	# 確保 mcpServers 存在
	if (-not $content.PSObject.Properties["mcpServers"]) {
		$content | Add-Member -MemberType NoteProperty -Name "mcpServers" -Value ([PSCustomObject]@{})
	}

	# 加入或更新 NCHU_library
	$content.mcpServers | Add-Member -MemberType NoteProperty -Name "NCHU_library" -Value @{
		command = "uv"
		args = @(
			"--directory",
			$currentDir,
			"run",
			"library_api.py"
		)
	} -Force

	# 格式化為 tab 縮排
	$tabbedJson = ConvertTo-TabIndentedJson -InputObject $content

	# 寫入檔案
	$tabbedJson | Set-Content -Path $configPath -Encoding UTF8

	Write-Host "✅ Config written with tab indentation."
}
catch {
	Write-Host "❌ Failed to write config:"
	Write-Host $_.Exception.Message
}
