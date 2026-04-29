# QUICKSTART · 3 分钟上手

## Step 1: 申请 API Key

访问 [天眼查智能体数据平台](https://agent.tianyancha.com)，注册并申请 API Key。

## Step 2: 配置环境变量

```bash
# macOS / Linux
source ./setup-tyc-env.sh

# 或直接导出
export TYC_MCP_API_KEY="your_api_key_here"
```

Windows PowerShell：

```powershell
. .\setup-tyc-env.ps1
```

## Step 3: 启动 Claude Code

```bash
claude --plugin-dir .
```

## Step 4: 体验 SKILL

在 Claude 对话框中输入 `/tyc-` 查看命令自动补全，选择需要的 SKILL。

完整 SKILL 清单与使用场景见 [README.md](README.md) 第 4-5 节。
