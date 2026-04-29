---
name: tyc-counterparty
description: 贸易融资业务中对交易对手的多维风险评估，开证、议付节点识别违约风险
category: banking
version: 1.0
---

# 交易对手风险评估

## 触发条件

贸易融资开证、议付、福费廷等业务节点对交易对手做风险评估时触发。

关键词：交易对手、贸易融资、信用证、议付、违约风险

## 输入要求

- **searchKey** (必填): 交易对手企业名称 或 信用代码

## 执行流程

### Step 1: 主体与信用
- `get_company_registration_info` — 主体核验
- `get_credit_evaluation` — 纳税信用 + 债券评级

### Step 2: 进出口资质
- `get_import_export_credit` — 海关信用等级
- `get_administrative_license` — 进出口相关许可

### Step 3: 失信与处罚
- `get_dishonest_info` — 失信记录
- `get_administrative_penalty` — 行政处罚（含海关、外汇类）
- `get_business_exception` — 经营异常

### Step 4: 综合评分
- `get_risk_overview` — 综合风险

## 输出格式

```markdown
# 交易对手风险评估 — {name}

## 风险评分卡
| 维度 | 得分 (0-100) | 说明 |
|------|--------------|------|
| 主体合规性 | ... | ... |
| 进出口信用 | ... | ... |
| 失信处罚 | ... | ... |
| 经营异常 | ... | ... |
| **综合得分** | **xx** | **评级 X** |

## 业务建议
- 是否接受开证：是/否
- 议付保证金比例：5% / 10% / 30%
- 重点风险点
```

## 示例

输入: `searchKey = "上海电气进出口有限公司"`
