---
name: tyc-ubo
description: 反洗钱合规场景下的股权多层穿透，识别最终受益所有人 (UBO) 及实际持股比例
category: banking
version: 1.0
---

# 受益所有人穿透 (UBO Screening)

## 触发条件

反洗钱开户合规、复杂股权架构企业的 UBO 识别、增强尽调中的实控关系核查时触发。

关键词：UBO、受益所有人、股权穿透、实控人、FATF、AML

## 输入要求

- **searchKey** (必填): 企业名称 或 信用代码

## 执行流程

### Step 1: 主体确认
- `get_company_registration_info` — 主体存续

### Step 2: 直接股东
- `get_shareholder_info` — 直接股东列表与持股比例

### Step 3: 受益所有人识别
- `get_beneficial_owners` — UBO 直查（含 25% 阈值与 finalRatio 字段）

### Step 4: 实控人路径
- `get_actual_controller` — 实控人
- `get_equity_ratio` — 控制结构 + 控股路径

### Step 5: 向下穿透（可选，识别隐性关联）
- `get_controlled_companies` — 向下穿透看实控人控股的全部公司

## 输出格式

```markdown
# UBO 穿透报告 — {name}

## 一、直接股权层
| 股东 | 持股比例 | 类型 |
|------|---------|------|

## 二、最终受益人 (UBO ≥25%)
| UBO 姓名 | 受益类型 | 最终受益股份 | 控制路径 |
|---------|---------|-------------|---------|

## 三、实际控制人
- 实控人: {name}
- 控制路径: {path}
- 总持股比例: {totalRatio}
- 表决权比例: {voteRatio}

## 四、关联企业网络（实控人维度）
表格列出实控人控股的其他企业

## 五、合规判定
- 满足 FATF 25% 透明度要求: 是/否
- UBO 自然人是否清晰: 是/否
- 是否需要 EDD: 是/否
```

## 示例

输入: `searchKey = "招商银行股份有限公司"`
