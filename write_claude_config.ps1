try {
	$configPath = Join-Path $env:APPDATA 'Claude\claude_desktop_config.json'
	$currentDir = Convert-Path .

	if (!(Test-Path $configPath)) {
		$jsonData = @{
			mcpServers = @{
				NCHU_library = @{
					command = "uv"
					args = @("--directory", $currentDir, "run", "library_api.py")
				}
			}
		}
	}
	else {
		$raw = Get-Content $configPath -Raw
		$content = $raw | ConvertFrom-Json

		if (-not $content.PSObject.Properties["mcpServers"]) {
			$content | Add-Member -MemberType NoteProperty -Name "mcpServers" -Value ([PSCustomObject]@{})
		}

		if ($null -eq $content.mcpServers) {
			$content.mcpServers = [PSCustomObject]@{}
		}

		$content.mcpServers | Add-Member -MemberType NoteProperty -Name "NCHU_library" -Value @{
			command = "uv"
			args = @("--directory", $currentDir, "run", "library_api.py")
		} -Force

		$jsonData = $content
	}

	# 轉成 JSON 並將前導空白轉為 tab
	$jsonText = $jsonData | ConvertTo-Json -Depth 5
	$tabbedJson = $jsonText -replace '^(  )+', {
		param($m)
		"`t" * ($m.Value.Length / 2)
	}

	$tabbedJson | Set-Content -Path $configPath -Encoding UTF8
	Write-Host "✅ Config written with tab-indented JSON."
}
catch {
	Write-Host "❌ Failed to write config:"
	Write-Host $_.Exception.Message
}
