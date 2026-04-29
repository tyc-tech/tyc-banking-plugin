---
name: tyc-guarantor
description: 贷款担保审批前的资信核查，评估担保方股权冻结/出质/动产抵押/土地抵押占用与实质偿付能力
category: banking
version: 1.0
---

# 担保方资信核查

## 触发条件

信贷审批中保证人资信审查、抵押贷款的担保企业核查、连带责任风险评估。

关键词：担保、保证人、连带责任、抵押、质押、增信

## 输入要求

- **searchKey** (必填): 担保企业名称 或 信用代码

## 执行流程

### Step 1: 担保方基本面
- `get_company_registration_info`
- `get_company_scale` — 资产规模 / 参保人数
- `get_credit_evaluation` — 信用评级

### Step 2: 资产占用核查
- `get_equity_freeze` — 股权冻结
- `get_equity_pledge_info` — 股权出质
- `get_chattel_mortgage_info` — 动产抵押
- `get_land_mortgage_info` — 土地抵押
- `get_stock_pledge_info` — 上市公司股权质押（若适用）

### Step 3: 司法风险
- `get_dishonest_info`
- `get_judgment_debtor_info`
- `get_terminated_cases` — 终本案件（已无可执行财产标志）

### Step 4: 偿付能力
- `get_financial_data` — 财务数据（资产负债率/速动比率）

## 输出格式

```markdown
# 担保方资信核查 — {name}

## 一、基本面
- 注册资本: {regCapital}
- 实缴资本: {actualCapital}
- 参保人数: {socialStaffNum}
- 信用评级: ...

## 二、资产占用情况
| 类型 | 件数 | 总额 | 状态 |
|------|------|------|------|
| 股权冻结 | ... | ... | ... |
| 股权出质 | ... | ... | ... |
| 动产抵押 | ... | ... | ... |
| 土地抵押 | ... | ... | ... |
| 上市股权质押 | ... | ... | ... |

## 三、司法风险（含终本警示）
## 四、财务偿付能力
- 资产负债率: ...
- 速动比率: ...

## 五、担保有效性结论
- 接受担保: 是/否
- 担保比例建议: ...
- 重点关注: 资产占用率 X% / 司法风险 / 终本案件
```

## 示例

输入: `searchKey = "某担保公司"`
