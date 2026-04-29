# TYC MCP 配置指南

## 1. MCP endpoint

本仓使用单一 TYC MCP Server：

```
https://ai-mcp.tianyancha.com/mcp
```

公网托管，无需本地部署。

## 2. 认证

所有请求需携带 `Authorization: ${TYC_MCP_API_KEY}` 请求头。

API Key 从 [天眼查智能体数据平台](https://agent.tianyancha.com) 申请。

## 3. `.mcp.json` 配置

仓根目录下 `.mcp.json` 已预配置：

```json
{
  "mcpServers": {
    "tyc": {
      "url": "https://ai-mcp.tianyancha.com/mcp",
      "headers": {
        "Authorization": "${TYC_MCP_API_KEY}"
      }
    }
  }
}
```

## 4. 环境变量设置

### macOS / Linux
```bash
source ./setup-tyc-env.sh
```

或手动：
```bash
export TYC_MCP_API_KEY="your_api_key_here"
echo 'export TYC_MCP_API_KEY="your_api_key_here"' >> ~/.zshrc
```

### Windows
```powershell
. .\setup-tyc-env.ps1
```

## 5. T1.1 工具分类（167 个）

| Go 包 | 工具数 | 中文分类 |
|-------|--------|---------|
| `company` | 52 | 企业基础信息（工商 / 股东 / 财务 / 股权图谱 / 集团 / 企业搜索 / 财务分析 / 企业报告 / 地理园区）|
| `risk` | 36 | 风险合规（司法 / 失信 / 破产 / 行政处罚 / 税务 / 经营异常）|
| `operation` | 32 | 经营与公示（招投标 / 资质 / 许可 / 舆情 / 私募基金 / 投资机构）|
| `history` | 18 | 历史信息（历史工商 / 司法 / 投资）|
| `executive` | 15 | 董监高（个人画像 / 控制企业 / 合作伙伴）|
| `intellectual_property` | 14 | 知识产权（专利 / 商标 / 著作权 / 建筑资质）|

## 6. 响应规范

每个工具返回：
- tyc OpenAPI 英文 key 透传（`name` / `creditCode` / `items` / `total` 等）
- 时间戳字段毫秒 → `Asia/Shanghai` 字符串
- 项目元数据 `_summary` / `_empty` / `_warnings`（下划线前缀）

## 7. 错误码归一

- `0` 成功
- `300000`（经查无结果）→ 自动归一为 `{items: [], total: 0, _empty: true}`
- 其他非 0 → 业务错误抛出

## 8. 调试

若 `claude --plugin-dir .` 启动后 SKILL 不可见：

```bash
# 检查 MCP 连通性
curl -H "Authorization: $TYC_MCP_API_KEY" \
  https://ai-mcp.tianyancha.com/mcp

# 检查 .mcp.json 语法
cat .mcp.json | jq .

# 检查 Claude Code 是否识别 plugin
claude --help
```

## 9. 相关参考

- [天眼查智能体数据平台](https://agent.tianyancha.com)
- [MCP 协议规范](https://modelcontextprotocol.io)
- [本仓 README](../README.md)
