# 🏦 tyc-banking-plugin

> **银行合规风控 AI SKILL 集** — 天眼查 OpenAPI + MCP 协议驱动的 8 个银行向业务 SKILL

[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](LICENSE)
[![MCP](https://img.shields.io/badge/MCP-TYC%20天眼查-orange.svg)](https://agent.tianyancha.com)
[![Claude](https://img.shields.io/badge/Claude%20Code-Compatible-purple.svg)](https://claude.ai)

---

## 1. 项目简介

`tyc-banking-plugin` 为银行对公客户经理、合规风控、反洗钱专员、信贷审批人员提供 AI Agent SKILL 集，覆盖中国银行典型业务场景：

- 企业开户 KYB
- AML 客户尽调（CDD / EDD）
- 授信前尽调
- 受益所有人（UBO）穿透
- 交易对手风险评估
- 贸易融资合规核查
- 贷后信贷监控
- 担保方资信核查

---

## 2. 核心价值

```
+---------------------------------------------------------------+
|                                                               |
|    天眼查 Banking SKILL × MCP × 中国企业数据底座               |
|                                                               |
|    +----------------------+     MCP    +------------------+   |
|    | /tyc-kyb             | ◄────────► | tyc-company      |   |
|    | /tyc-aml             | Auto-Route | tyc-risk         |   |
|    | /tyc-credit-dd       |            | tyc-executive    |   |
|    | /tyc-counterparty    |            | tyc-operation    |   |
|    | /tyc-ubo             |            +------------------+   |
|    | /tyc-trade-compliance|                                   |
|    | /tyc-credit-monitor  |       ✅ 30 秒出 KYB 报告         |
|    | /tyc-guarantor       |       ✅ 18 类司法风险自动扫描     |
|    +----------------------+       ✅ UBO 多层股权穿透          |
|                                                               |
+---------------------------------------------------------------+
```

---

## 3. 快速开始（2 种装法选一）

### 方式 A · bash 一键脚本（推荐 · 30 秒搞定）

```bash
bash <(curl -sL https://raw.githubusercontent.com/tyc-opensource/tyc-banking-plugin/main/install_tyc_mcp.sh)
```

脚本会：① 提示输入 `TYC_MCP_API_KEY`（[申请](https://agent.tianyancha.com)）→ ② 自动写入 `~/.claude/.mcp.json` → ③ 复制 SKILL 到 `~/.claude/skills/tyc-*` → ④ 复制命令到 `~/.claude/commands/`。完成后**重启 Claude Code** 即可使用。

### 方式 B · 本地 plugin-dir（开发 / 调试）

```bash
git clone https://github.com/tyc-opensource/tyc-banking-plugin.git
cd tyc-banking-plugin
export TYC_MCP_API_KEY="your_api_key_here"
claude --plugin-dir .
```

启动后项目级 `.mcp.json` 自动加载。

---

### 试用

在 Claude 会话中输入 `/tyc-` 看自动补全，例如：

```
/tyc-kyb 宁德时代新能源科技股份有限公司
```


## 4. SKILL / Command 列表（8 个）

| # | 命令 | 名称 | 耗时 | 典型场景 |
|---|------|------|-----|---------|
| 1 | `/tyc-kyb` | KYB 企业核验 30 秒报告 | ~30s | 企业开户 KYB、客户身份核验 |
| 2 | `/tyc-aml` | AML 客户尽职调查 | ~1min | 反洗钱 CDD / EDD、可疑交易调查 |
| 3 | `/tyc-credit-dd` | 授信尽调报告 | ~1min | 信贷授信前尽调、贷前审查 |
| 4 | `/tyc-counterparty` | 交易对手风险评估 | ~30s | 大额交易对手核查、反欺诈 |
| 5 | `/tyc-ubo` | 受益所有人穿透(UBO) | ~45s | AML UBO 识别、监管报告 |
| 6 | `/tyc-trade-compliance` | 贸易融资合规核查 | ~1min | 信用证 / 跨境贸易融资 |
| 7 | `/tyc-credit-monitor` | 信贷风险定期监控 | ~1min | 贷后监控、到期预警 |
| 8 | `/tyc-guarantor` | 担保方资信核查 | ~30s | 担保贷款、连带责任审查 |

详见 [commands/](commands/) 与 [skills/](skills/)。

---

## 5. 典型应用场景

### 场景 A: 30 秒 KYB · 企业开户核验

```
用户: /tyc-kyb 北京百度网讯科技有限公司
  ↓ 自动编排 9 个聚合工具
  ↓ 工商 + 股东 + 实控人 + 18 类风险 + 黑名单
Claude: 输出 5 段 Markdown 报告
  1. 主体核验（名称 / 代码 / 法代 / 存续）
  2. 股权穿透（TOP 5 股东 / UBO）
  3. 风险扫描（失信 / 被执行 / 限高 / 行政处罚）
  4. 黑名单比对（经营异常 / 严重违法）
  5. KYB 结论（通过 / 人工复核 / 谢绝）
```

### 场景 B: AML 可疑交易调查

```
用户: /tyc-aml 某目标客户
  ↓ 触发 EDD 级尽调
Claude: 输出结构化 AML 尽调档案，含 PEP 识别、制裁名单比对、可疑关联人员。
```

### 场景 C: 贷后信贷预警

```
用户: /tyc-credit-monitor 某贷款客户
  ↓ 风险对比 90 天变化
Claude: 输出信号等级（🔴 / 🟡 / 🔵）+ 建议动作（展期 / 催收 / 诉讼准备）。
```

---

## 6. 天眼查 MCP 集成

所有 SKILL 通过单一 MCP server `tyc`（URL: `https://mcp.tianyancha.com/v1`）调用业务语义聚合层共 **163 个**聚合工具，分 6 大分类：

| Go 包 | 中文分类 | 工具数 | 本仓主要使用 |
|-------|---------|--------|------------|
| `company` | 企业基础信息 | 49 | kyb / credit-dd / ubo / guarantor |
| `risk` | 风险合规 | 35 | aml / kyb / counterparty / credit-monitor |
| `executive` | 董监高 | 15 | aml（PEP 识别）/ ubo |
| `operation` | 经营与公示 | 32 | trade-compliance |
| `history` | 历史信息 | 18 | credit-monitor（90 天变化对比）|

`.mcp.json` 已预配置，无需修改：

```json
{
  "mcpServers": {
    "tyc": {
      "url": "https://mcp.tianyancha.com/v1",
      "headers": { "Authorization": "${TYC_MCP_API_KEY}" }
    }
  }
}
```

---

## 7. 配置说明

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| `TYC_MCP_API_KEY` | — | 必填，从 `agent.tianyancha.com` 申请 |
| MCP endpoint | `https://mcp.tianyancha.com/v1` | 公网托管，无需自部署 |
| 输出格式 | Markdown | Claude Code 自动渲染 |

详见 [docs/MCP_CONFIGURATION.md](docs/MCP_CONFIGURATION.md)。

Windows 用户参考：`.\setup-tyc-env.ps1`

---

## 8. 常见问题

**Q: 是否需要本地部署 MCP Server？**
A: 不需要。TYC MCP Server 已公网托管（`mcp.tianyancha.com`）。

**Q: API Key 怎么收费？**
A: 从 [agent.tianyancha.com](https://agent.tianyancha.com) 申请，有免费额度和付费套餐。

**Q: 能否修改 SKILL？**
A: Apache-2.0 License 允许二次开发，PR 欢迎。

---

## 9. 贡献指南

1. Fork 本仓
2. 新建 feature 分支（`feat/xxx`）
3. 修改 `skills/<name>/SKILL.md`
4. 提交 PR，描述业务场景与底层工具清单
5. CI 自动跑 evals 验证

SKILL 命名规范：`/tyc-<场景简称>`（kebab-case）。

---

## 10. License

Apache-2.0 · 见 [LICENSE](LICENSE)

---

## 11. 致谢

- 数据源：[天眼查](https://www.tianyancha.com)
- 协议：[Model Context Protocol (MCP)](https://modelcontextprotocol.io)

---

## 12. 联系我们

- Issues: https://github.com/tyc-opensource/tyc-banking-plugin/issues
- API 申请：https://agent.tianyancha.com
- 商务合作：contact@tianyancha.com
