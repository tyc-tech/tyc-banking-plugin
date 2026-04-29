---
name: tyc-credit-monitor
description: 贷后管理中对存量借款客户的持续风险监控，关键风险信号变化即时预警
category: banking
version: 1.0
---

# 信贷风险定期监控

## 触发条件

贷后管理周期性体检（月度/季度）、存量客户预警监控、风险信号变化触发。

关键词：贷后监控、风险预警、存量客户、信号触发、定期体检

## 输入要求

- **searchKey** (必填): 借款企业名称 或 信用代码

## 执行流程

### Step 1: 工商基本面变更
- `get_company_registration_info` — 当前状态
- `get_change_records` — 工商变更记录（关注法人/资本/地址变更）

### Step 2: 经营异常信号
- `get_business_exception` — 经营异常名录
- `get_serious_violation` — 严重违法
- `get_administrative_penalty` — 行政处罚

### Step 3: 司法风险信号
- `get_dishonest_info` — 失信
- `get_judgment_debtor_info` — 被执行
- `get_high_consumption_restriction` — 限高
- `get_case_filing_info` — 立案信息（早期信号）

### Step 4: 资产状态
- `get_equity_freeze` — 股权冻结
- `get_chattel_mortgage_info` — 动产抵押
- `get_judicial_auction` — 司法拍卖

### Step 5: 集中预警
- `get_risk_overview` — 综合风险

## 输出格式

```markdown
# 贷后风险监控报告 — {name}

> 监控周期: {since} 至 {now}

## 关键风险信号变化
- ⚠️ 法定代表人变更: 是/否
- ⚠️ 注册资本异动: 是/否
- 🚨 新增失信记录: {n} 条
- 🚨 新增被执行: {n} 条
- 🚨 股权被冻结: 是/否
- 🚨 司法拍卖标的: 是/否

## 综合风险评级变化
- 上期评级: A
- 本期评级: B
- 评级下调原因: ...

## 处置建议
- 是否触发预警: 是/否
- 建议措施: 提前结清 / 增加担保 / 强化监控 / 维持
```

## 示例

输入: `searchKey = "ABC 借款企业"`
