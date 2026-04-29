---
name: tyc-trade-compliance
description: 跨境贸易与国际结算场景下的合规准入工具，整合海关信用、经营资质、进出口许可与制裁名单筛查
category: banking
version: 1.0
---

# 贸易融资合规核查

## 触发条件

跨境贸易开证、外汇业务、信用证议付前的客户合规准入审核时触发。

关键词：贸易融资、跨境合规、进出口、海关、制裁、FATF

## 输入要求

- **searchKey** (必填): 企业名称 或 信用代码

## 执行流程

### Step 1: 主体合规
- `get_company_registration_info`
- `verify_company_accuracy`

### Step 2: 海关与进出口
- `get_import_export_credit` — 海关注册编码、信用等级
- `get_administrative_license` — 进出口相关许可与有效期
- `get_telecom_license` — 跨境数据/通信类许可（如适用）

### Step 3: 制裁与失信
- `get_dishonest_info` — 失信
- `get_disciplinary_list` — 惩戒名单（含部分制裁信息）
- `get_administrative_penalty` — 海关/外汇类处罚

### Step 4: 风险综合
- `get_risk_overview`
- `get_news_sentiment` — 制裁/媒体负面舆情筛查

## 输出格式

```markdown
# 贸易融资合规报告 — {name}

## 一、主体合规
## 二、海关信用与进出口资质
## 三、制裁与失信筛查
## 四、综合合规评级
- 准入决定: 通过 / 增强审核 / 拒绝
- 跨境业务限额建议: ...
```

## 示例

输入: `searchKey = "中国五矿集团有限公司"`
