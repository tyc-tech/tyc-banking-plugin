---
name: tyc-aml
description: 客户开户与增强尽职调查 EDD 全流程工具，输出符合 FATF Recommendation 10/12 的标准化反洗钱尽调报告
category: banking
version: 1.0
---

# AML 客户尽职调查

## 触发条件

银行对公开户合规审查、高风险客户增强尽调（EDD）、复杂股权架构企业准入时触发。

关键词：AML、反洗钱、KYC、UBO、PEP、EDD、FATF、开户合规

## 输入要求

- **searchKey** (必填): 企业名称 或 统一社会信用代码

## 执行流程

### Step 1: 主体核实
- `get_company_registration_info` — 主体存续状态、登记机关
- `verify_company_accuracy` — 名称/法人/信用代码三要素核验

### Step 2: 股权多层穿透 (UBO)
- `get_shareholder_info` — 股东列表
- `get_beneficial_owners` — 受益所有人识别
- `get_actual_controller` — 实际控制人
- `get_equity_ratio` — 股权控制结构（向上穿透至 25% 阈值）

### Step 3: PEP 与黑名单筛查
- `get_key_personnel` — 主要人员列表
- `get_dishonest_info` — 失信被执行

### Step 4: 跨境贸易合规
- `get_import_export_credit` — 海关信用等级
- `get_administrative_penalty` — 行政处罚（含外汇/海关类）

### Step 5: 风险综合评估
- `get_risk_overview` — 综合风险

## 输出格式

```markdown
# AML 客户尽职调查报告 — {name}

> 合规框架: FATF Rec.10/12 + PBOC 2024 反洗钱办法

## 一、客户身份识别 (CDD)
- 主体真实性: 通过 / 未通过
- 经营状态: {regStatus}
- 注册地址: {regLocation}

## 二、最终受益人识别 (UBO)
满足 25% 阈值的最终受益人列表（自然人）：
| 姓名 | 持股比例 | 控制路径 | PEP 状态 |
|------|---------|---------|----------|

## 三、控制结构透明度
- 控制层级深度: {n} 层
- 是否复杂架构: 是/否（>3 层判定为复杂）
- 疑似空壳风险: 高/中/低

## 四、PEP 与制裁筛查
- 法定代表人 PEP 标记: 是/否
- 主要人员失信记录: {n} 条

## 五、跨境业务合规
- 海关信用等级: {creditLevel}
- 外汇/海关类处罚: {n} 条

## 六、增强尽调结论
- 客户风险评级: 低/中/高 风险
- 建议: 标准 CDD / 增强 EDD / 拒绝开户
- 持续监控频率: 年度 / 半年 / 季度
```

## 错误处理

- 受益所有人为空（如外资公司）→ 标注"无法穿透至自然人，建议 EDD"
- 香港/外资企业 `companyType` 特殊 → 调整 UBO 阈值说明

## 示例

输入: `searchKey = "深圳市腾讯计算机系统有限公司"`
