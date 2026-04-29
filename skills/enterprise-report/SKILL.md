---
name: tyc-enterprise-report
description: 一键生成基础版/专业版企业信用报告（TYC 独有），覆盖工商/分支/变更/主要人员/联系方式/司法/经营/知产/上市全维度
category: banking
version: 1.0
---

# 企业信用报告（TYC 独有扩展）

## 触发条件

银行授信、政府监管、商务合作前需要一份**官方格式信用报告**作为决策附件时触发。

关键词：信用报告、企业报告、credit report、合作背书、融资附件

## 输入要求

- **searchKey** (必填): 企业名称 或 信用代码
- **level** (可选): `basic` 或 `professional`，默认 `professional`

## 执行流程

### Step 1: 报告主调用
- 若 level=basic: `get_enterprise_report_basic` (`searchKey`) — 工商+分支+变更+主要人员+联系方式
- 若 level=professional: `get_enterprise_report_professional` (`searchKey`) — 在 basic 基础上叠加司法风险、经营风险、知识产权、经营信息、上市信息

### Step 2: 元数据补充
- `get_company_registration_info` — 用于报告封面与时间戳
- `get_actual_controller` — 实控人补充

### Step 3: （可选）历史维度
- `get_historical_overview` — 历史信息总览（如调用方需要回溯）

## 输出格式

```markdown
# 企业信用报告（{level}）— {name}

> 报告生成时间: {ISO8601}
> 报告类型: 基础版 / 专业版

## 封面
- 企业全称: {name}
- 统一社会信用代码: {creditCode}
- 法定代表人: {legalPersonName}
- 实际控制人: {actualController}
- 报告版本: 基础版 / 专业版

## 章节（基础版含）
### 一、工商信息
### 二、分支机构
### 三、变更记录
### 四、主要人员
### 五、联系方式

## 章节（专业版增加）
### 六、司法风险
### 七、经营风险
### 八、知识产权
### 九、经营信息（招投标/许可/资质）
### 十、上市信息（如适用）
### 十一、历史回溯（如调用方启用）

## 出具机构
- 数据来源: 天眼查
- 报告标识: tyc-er-{md5(searchKey + timestamp).slice(0,8)}
```

## 错误处理

- 若 `get_enterprise_report_professional` 不可用 → 降级到 `basic` 并标注"专业版数据暂不可用"
- 若企业为非上市企业 → 跳过"上市信息"章节

## 示例

输入: `searchKey = "宁德时代新能源科技股份有限公司"`, `level = "professional"`
