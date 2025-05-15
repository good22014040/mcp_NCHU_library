try {
    $configPath = Join-Path $env:APPDATA 'Claude\claude_desktop_config.json'
    $currentDir = Convert-Path .

    if (!(Test-Path $configPath)) {
        $json = @{
            mcpServers = @{
                NCHU_library = @{
                    command = "uv"
                    args = @("--directory", $currentDir, "run", "library_api.py")
                }
            }
        } | ConvertTo-Json -Depth 5

        $json | Set-Content -Path $configPath -Encoding UTF8
        Write-Host "✅ Config created: $configPath"
    }
    else {
        $raw = Get-Content $configPath -Raw
        $content = $raw | ConvertFrom-Json

        # Ensure mcpServers exists
        if (-not $content.PSObject.Properties["mcpServers"]) {
            $content | Add-Member -MemberType NoteProperty -Name "mcpServers" -Value ([PSCustomObject]@{})
        }

        if ($null -eq $content.mcpServers) {
            $content.mcpServers = [PSCustomObject]@{}
        }

        # Add or overwrite NCHU_library inside mcpServers
        $content.mcpServers | Add-Member -MemberType NoteProperty -Name "NCHU_library" -Value @{
            command = "uv"
            args = @("--directory", $currentDir, "run", "library_api.py")
        } -Force

        # Write updated config
        $jsonOut = $content | ConvertTo-Json -Depth 5
        Set-Content -Path $configPath -Value $jsonOut -Encoding UTF8

        Write-Host "✅ Config updated: $configPath"
    }
}
catch {
    Write-Host "❌ Failed to update config:"
    Write-Host $_.Exception.Message
}
