---
name: tyc-kyb
description: 银行开户和授信审批前的企业主体核验与全维风险扫描，30 秒输出符合 FATF/PBOC/CBIRC 标准的合规报告
category: banking
version: 1.0
---

# KYB 企业核验

## 触发条件

银行/金融机构在客户开户、授信审批、续贷复审等关键节点对企业进行尽调时触发。

关键词：KYB、企业核验、开户审查、主体核验、合规审查、授信前置

## 输入要求

- **searchKey** (必填): 企业名称 或 统一社会信用代码

## 执行流程

### Step 1: 主体真实性核验
- 调用 `get_company_registration_info` (`searchKey`) — 工商基础（法人/资本/状态/经营范围/参保人数）
- 调用 `verify_company_accuracy` (`searchKey`, `legalPersonName?`) — 三要素一致性校验

### Step 2: 股权与控制结构
- 调用 `get_shareholder_info` (`searchKey`) — 股东构成与出资明细
- 调用 `get_actual_controller` (`searchKey`) — 实际控制人
- 调用 `get_beneficial_owners` (`searchKey`) — 受益所有人 (UBO)

### Step 3: 司法风险扫描
- 调用 `get_judicial_documents` (`searchKey`) — 裁判文书
- 调用 `get_judgment_debtor_info` (`searchKey`) — 被执行人
- 调用 `get_dishonest_info` (`searchKey`) — 失信被执行人
- 调用 `get_high_consumption_restriction` (`searchKey`) — 限制高消费

### Step 4: 经营风险扫描
- 调用 `get_business_exception` (`searchKey`) — 经营异常
- 调用 `get_serious_violation` (`searchKey`) — 严重违法
- 调用 `get_administrative_penalty` (`searchKey`) — 行政处罚
- 调用 `get_tax_arrears_notice` (`searchKey`) — 欠税公告

### Step 5: 综合风险评估
- 调用 `get_risk_overview` (`searchKey`) — 自身/周边/预警风险

## 输出格式

```markdown
# KYB 企业核验报告 — {name}

> 核验时间: {ISO8601}
> 数据来源: 天眼查 T1.1 业务语义聚合层

## 一、主体信息
| 字段 | 值 |
|------|-----|
| 企业名称 | {name} |
| 统一社会信用代码 | {creditCode} |
| 法定代表人 | {legalPersonName} |
| 企业类型 | {companyOrgType} |
| 经营状态 | {regStatus} |
| 成立日期 | {estiblishTime} |
| 注册资本 | {regCapital} |
| 参保人数 | {socialStaffNum} |
| 三要素核验 | 一致/不一致 |

## 二、股权穿透
**主要股东**: 表格列出 top 5
**实际控制人**: {actualController.name} (持股比例: {totalRatio})
**最终受益人 (UBO)**: 表格列出全部

## 三、司法风险（4 维）
| 维度 | 数量 | 风险等级 |
|------|------|---------|
| 裁判文书 | {n} | 低/中/高 |
| 被执行 | {n} | ... |
| 失信 | {n} | ... |
| 限高 | {n} | ... |

## 四、经营风险（4 维）
| 维度 | 数量 | 风险等级 |
|------|------|---------|

## 五、综合风险
{risk_overview._summary}

## 六、核验结论
- 主体真实性: 通过 / 未通过
- 风险等级: 低 / 中 / 高
- 是否准入: 建议准入 / 加强审核 / 拒绝
- 关键风险点: ...
```

## 错误处理

- 若 `verify_company_accuracy` 中 match=false → 标注"主体真实性未通过"，但其他维度仍执行
- 若任一风险扫描工具返回 `_empty: true` → 该维度记 0，使用 `_summary` 文案
- 若 `get_risk_overview` 失败 → 用 4 个司法 + 4 个经营维度合计推导

## 示例

输入: `searchKey = "北京字节跳动科技有限公司"`

输出: 6 段完整核验报告，含主体信息、股权穿透、风险扫描与准入结论。
