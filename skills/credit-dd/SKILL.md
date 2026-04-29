---
name: tyc-credit-dd
description: 信贷审批流程中的企业全维度尽调工具，输出标准化授信尽调底稿
category: banking
version: 1.0
---

# 授信尽调报告

## 触发条件

信贷审批流程中放款前完成企业风险画像，授信经理输出尽调底稿时触发。

关键词：授信、信贷尽调、放款审查、贷前调查、授信底稿

## 输入要求

- **searchKey** (必填): 企业名称 或 统一社会信用代码

## 执行流程

### Step 1: 工商画像
- `get_company_registration_info` — 工商登记
- `get_actual_controller` — 实控人
- `get_company_scale` — 企业规模（参保/分支/对外投资）

### Step 2: 信用评价
- `get_credit_evaluation` — 纳税信用评级 + 债券主体评级
- `get_administrative_license` — 行政许可

### Step 3: 经营风险
- `get_business_exception` — 经营异常
- `get_serious_violation` — 严重违法
- `get_administrative_penalty` — 行政处罚
- `get_tax_arrears_notice` — 欠税

### Step 4: 司法风险
- `get_dishonest_info` — 失信
- `get_judgment_debtor_info` — 被执行
- `get_judicial_documents` — 裁判文书

### Step 5: 担保与质押
- `get_equity_pledge_info` — 股权出质
- `get_chattel_mortgage_info` — 动产抵押

### Step 6: 经营活跃度
- `get_news_sentiment` — 新闻舆情
- `get_recruitment_info` — 招聘动态
- `get_bidding_info` — 招投标记录

## 输出格式

```markdown
# 授信尽调底稿 — {name}

## 1. 基本信息（工商画像）
## 2. 信用评级与许可
## 3. 经营风险（4 维）
## 4. 司法风险（3 维）
## 5. 担保与抵押占用
## 6. 经营活跃度评估
## 7. 综合授信建议
- 信贷风险评级: AAA/AA/A/B/C
- 建议授信额度区间: ...
- 担保增信建议: ...
- 重点关注: ...
```

## 示例

输入: `searchKey = "比亚迪股份有限公司"`
