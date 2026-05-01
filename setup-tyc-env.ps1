# TYC MCP 环境变量配置（Windows PowerShell）
# 用法：. .\setup-tyc-env.ps1

if (-not $env:TYC_MCP_API_KEY) {
    $apikey = Read-Host "请输入 TYC MCP API Key"
    $env:TYC_MCP_API_KEY = $apikey

    # 持久化到当前用户
    [System.Environment]::SetEnvironmentVariable("TYC_MCP_API_KEY", $apikey, "User")
    Write-Host "✅ TYC_MCP_API_KEY 已设置（当前会话 + 用户环境变量）"
} else {
    Write-Host "✅ TYC_MCP_API_KEY 已存在"
}

# 可选：测试连通性
Write-Host ""
Write-Host "→ 测试 TYC MCP 连通性..."
try {
    $response = Invoke-WebRequest -Uri "https://mcp.tianyancha.com/v1" `
        -Headers @{ "Authorization" = "Bearer $env:TYC_MCP_API_KEY" } `
        -Method Head -UseBasicParsing -ErrorAction Stop
    Write-Host "   HTTP 状态: $($response.StatusCode)"
} catch {
    Write-Host "   ⚠️  连接异常: $_"
}
