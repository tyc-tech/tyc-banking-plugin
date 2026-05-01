#!/usr/bin/env bash
# TYC MCP 环境变量配置（macOS / Linux · bash / zsh）
# 用法：source setup-tyc-env.sh
set -euo pipefail

if [ -z "${TYC_MCP_API_KEY:-}" ]; then
  read -r -p "请输入 TYC MCP API Key: " apikey
  export TYC_MCP_API_KEY="$apikey"
  echo "✅ TYC_MCP_API_KEY 已设置到当前 shell 会话"
  echo "提示：持久化请执行 echo 'export TYC_MCP_API_KEY=\"...\"' >> ~/.\${SHELL##*/}rc"
else
  echo "✅ TYC_MCP_API_KEY 已存在"
fi

# 可选：测试连通性
echo ""
echo "→ 测试 TYC MCP 连通性..."
curl -s -o /dev/null -w "   HTTP 状态: %{http_code}\n" \
  -H "Authorization: $TYC_MCP_API_KEY" \
  "https://mcp.tianyancha.com/v1" || echo "   ⚠️  连接异常，检查 API Key 与网络"
