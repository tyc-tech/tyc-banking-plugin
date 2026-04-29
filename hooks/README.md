# hooks/

可选 · Claude Code hooks 配置。

## hooks.json

示例：在调用 KYB 工具前自动记录合规日志（银行风控要求）。

## 用法

将 `hooks.json` 合并到 `.claude/settings.json`：

```bash
# 查看 hooks.json 示例
cat hooks/hooks.json

# 手动合并到 ~/.claude/settings.json
```

详见 [Claude Code hooks 文档](https://docs.claude.com/claude-code/hooks)。
