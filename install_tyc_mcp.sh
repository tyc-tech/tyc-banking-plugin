#!/bin/bash
# tyc-banking-plugin Installation Script · 一键安装 / Installation
#
# 用法 / Usage:
#   curl 模式（推荐） / curl mode (recommended):
#     bash <(curl -sL https://raw.githubusercontent.com/tyc-opensource/tyc-banking-plugin/main/install_tyc_mcp.sh)
#
#   本地模式 / local mode:
#     bash install_tyc_mcp.sh
#
# 功能 / What this does:
#   1. 提示输入 TYC_MCP_API_KEY（首次） / Prompt for TYC_MCP_API_KEY (first time)
#   2. 写入 ~/.claude/.mcp.json（备份现有） / Write ~/.claude/.mcp.json (with backup)
#   3. 复制 SKILL 到 ~/.claude/skills/tyc-* / Copy SKILLs to ~/.claude/skills/tyc-*
#   4. 复制 commands 到 ~/.claude/commands/ / Copy commands
#   5. 提示重启 Claude Code 生效 / Prompt to restart Claude Code

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_NAME="tyc-banking-plugin"
REPO_OWNER="tyc-opensource"
REPO_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}"
TARBALL_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/archive/refs/heads/main.tar.gz"

echo "=========================================="
echo "  ${REPO_NAME} Installer"
echo "  天眼查 OpenAPI MCP · 银行合规风控 9 SKILL"
echo "=========================================="
echo ""

# 平台检测
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macOS"
    SHELL_RC="$HOME/.zshrc"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM="Linux"
    SHELL_RC="$HOME/.bashrc"
else
    echo -e "${RED}不支持的平台 / Unsupported platform: $OSTYPE${NC}"
    exit 1
fi

CLAUDE_DIR="$HOME/.claude"
echo -e "${BLUE}平台 / Platform: $PLATFORM${NC}"
echo -e "${BLUE}Claude 目录 / Claude dir: $CLAUDE_DIR${NC}"
echo ""

# ============ 装机模式检测（curl vs local）============
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
INSTALL_MODE="local"
SOURCE_DIR=""

if [[ "$SCRIPT_SOURCE" == /dev/fd/* ]] || [[ "$SCRIPT_SOURCE" == /proc/*/fd/* ]] || [ ! -f "$SCRIPT_SOURCE" ]; then
    INSTALL_MODE="curl"
    echo -e "${BLUE}装机模式 / Mode: curl（自动从 GitHub 下载 / auto-download from GitHub）${NC}"

    TEMP_DIR=$(mktemp -d)
    echo -e "${BLUE}下载中 / Downloading...${NC}"

    if command -v curl &> /dev/null; then
        curl -sL "$TARBALL_URL" | tar -xz -C "$TEMP_DIR" --strip-components=1
    elif command -v wget &> /dev/null; then
        wget -qO- "$TARBALL_URL" | tar -xz -C "$TEMP_DIR" --strip-components=1
    else
        echo -e "${RED}缺少 curl 或 wget / Missing curl or wget${NC}"
        exit 1
    fi

    SOURCE_DIR="$TEMP_DIR"
else
    echo -e "${BLUE}装机模式 / Mode: 本地 / local${NC}"
    SOURCE_DIR="$(cd "$(dirname "$SCRIPT_SOURCE")" && pwd)"
fi

# ============ Step 0: API Key ============
echo ""
echo "=========================================="
echo "  Step 0: TYC MCP API Key"
echo "=========================================="

if [ -z "$TYC_MCP_API_KEY" ]; then
    echo -e "${YELLOW}⚠️  环境变量 TYC_MCP_API_KEY 未设置${NC}"
    echo ""
    echo "API Key 申请: https://agent.tianyancha.com"
    echo ""
    echo "选项："
    echo "  1) 现在输入 / Enter now"
    echo "  2) 退出，稍后配置 / Exit, configure later"
    echo ""
    read -p "选择 / Select (1/2): " choice

    case $choice in
        1)
            read -p "请输入 TYC_MCP_API_KEY / Enter key: " api_key
            export TYC_MCP_API_KEY="$api_key"
            echo "export TYC_MCP_API_KEY=\"$api_key\"" >> "$SHELL_RC"
            echo -e "${GREEN}✓ 已写入 $SHELL_RC${NC}"
            ;;
        2)
            echo "退出 / Exit. 设置环境变量后重新运行 / Set env var and rerun."
            exit 0
            ;;
        *)
            echo "无效选择 / Invalid choice."
            exit 1
            ;;
    esac
else
    echo -e "${GREEN}✓ TYC_MCP_API_KEY 已存在${NC}"
fi

# ============ Step 1: 写入 ~/.claude/.mcp.json ============
echo ""
echo "=========================================="
echo "  Step 1: 写入 MCP 配置 / Install MCP config"
echo "=========================================="

mkdir -p "$CLAUDE_DIR"
MCP_CONFIG_DEST="$CLAUDE_DIR/.mcp.json"

if [ -f "$MCP_CONFIG_DEST" ]; then
    BACKUP="${MCP_CONFIG_DEST}.backup.$(date +%Y%m%d%H%M%S)"
    cp "$MCP_CONFIG_DEST" "$BACKUP"
    echo -e "${YELLOW}  已备份现有 / Backed up existing: $BACKUP${NC}"

    # 智能合并：保留现有非 tyc 服务，加入或更新 tyc
    if command -v python3 &> /dev/null; then
        python3 - <<PYEOF
import json
from pathlib import Path

config_path = Path("$MCP_CONFIG_DEST")
existing = {}
if config_path.exists():
    try:
        existing = json.loads(config_path.read_text())
    except Exception:
        existing = {}

existing.setdefault("mcpServers", {})
existing["mcpServers"]["tyc"] = {
    "url": "https://ai-mcp.tianyancha.com/mcp",
    "headers": {
        "Authorization": "Bearer \${TYC_MCP_API_KEY}"
    }
}

config_path.write_text(json.dumps(existing, ensure_ascii=False, indent=2))
print("  ✓ 智能合并完成（保留其他 MCP 服务）")
PYEOF
    else
        # 无 python3 → 直接覆盖
        cat > "$MCP_CONFIG_DEST" <<'MCPEOF'
{
  "mcpServers": {
    "tyc": {
      "url": "https://ai-mcp.tianyancha.com/mcp",
      "headers": {
        "Authorization": "${TYC_MCP_API_KEY}"
      }
    }
  }
}
MCPEOF
    fi
else
    cat > "$MCP_CONFIG_DEST" <<'MCPEOF'
{
  "mcpServers": {
    "tyc": {
      "url": "https://ai-mcp.tianyancha.com/mcp",
      "headers": {
        "Authorization": "${TYC_MCP_API_KEY}"
      }
    }
  }
}
MCPEOF
    echo -e "${GREEN}  ✓ 新建 $MCP_CONFIG_DEST${NC}"
fi

# ============ Step 2: 复制 SKILL ============
echo ""
echo "=========================================="
echo "  Step 2: 复制 SKILL 到 ~/.claude/skills/"
echo "=========================================="

SKILLS_DIR="$CLAUDE_DIR/skills"
mkdir -p "$SKILLS_DIR"

# 处理两种结构：
#   ① 标准 skills/<name>/SKILL.md（多 SKILL 仓）
#   ② 根目录 SKILL.md（单 SKILL 仓 vendor-assessment）
if [ -d "$SOURCE_DIR/skills" ]; then
    for skill_dir in "$SOURCE_DIR"/skills/*/; do
        [ -d "$skill_dir" ] || continue
        name=$(basename "$skill_dir")
        # 给用户级目录加 tyc- 前缀，避免命名冲突
        target_name="tyc-${name}"
        target="$SKILLS_DIR/$target_name"

        if [ -d "$target" ]; then
            mv "$target" "${target}.backup.$(date +%Y%m%d%H%M%S)"
            echo -e "${YELLOW}  已备份旧版 $target_name${NC}"
        fi
        cp -r "$skill_dir" "$target"
        echo -e "${GREEN}  ✓ 安装 SKILL: $target_name${NC}"
    done
elif [ -f "$SOURCE_DIR/SKILL.md" ]; then
    # 兼容旧版（不应再走到这里，但保留）
    target="$SKILLS_DIR/${REPO_NAME}"
    [ -d "$target" ] && mv "$target" "${target}.backup.$(date +%Y%m%d%H%M%S)"
    mkdir -p "$target"
    cp "$SOURCE_DIR/SKILL.md" "$target/SKILL.md"
    echo -e "${GREEN}  ✓ 安装 SKILL: $REPO_NAME${NC}"
else
    echo -e "${RED}  ✗ 源目录无 skills/ 或 SKILL.md${NC}"
fi

# ============ Step 3: 复制 commands ============
echo ""
echo "=========================================="
echo "  Step 3: 复制命令到 ~/.claude/commands/"
echo "=========================================="

COMMANDS_DIR="$CLAUDE_DIR/commands"
mkdir -p "$COMMANDS_DIR"

if [ -d "$SOURCE_DIR/commands" ]; then
    cnt=0
    for cmd_file in "$SOURCE_DIR"/commands/*.md; do
        [ -f "$cmd_file" ] || continue
        cp "$cmd_file" "$COMMANDS_DIR/"
        cnt=$((cnt+1))
    done
    echo -e "${GREEN}  ✓ 复制 $cnt 个命令${NC}"
else
    echo -e "${YELLOW}  跳过（无 commands/ 目录）${NC}"
fi

# ============ Step 4: 验证 ============
echo ""
echo "=========================================="
echo "  Step 4: 验证 / Verify"
echo "=========================================="

[ -f "$MCP_CONFIG_DEST" ] && echo -e "${GREEN}  ✓ MCP 配置${NC}" || echo -e "${RED}  ✗ MCP 配置${NC}"
skill_count=$(ls -d "$SKILLS_DIR"/tyc-* 2>/dev/null | wc -l | tr -d ' ')
echo -e "${GREEN}  ✓ 已装 SKILL: $skill_count 个${NC}"
cmd_count=$(ls "$COMMANDS_DIR"/tyc-*.md 2>/dev/null | wc -l | tr -d ' ')
echo -e "${GREEN}  ✓ 已装命令: $cmd_count 个${NC}"

# ============ 后续 ============
echo ""
echo "=========================================="
echo "  ⚠️  下一步必须重启 Claude Code"
echo "  ⚠️  IMPORTANT: Restart Claude Code"
echo "=========================================="
echo ""
echo "1. 完全退出 Claude Code"
echo "2. 确保环境变量已生效 / Ensure env var loaded:"
echo "     source $SHELL_RC"
echo "3. 重启 Claude Code 后试用："
echo "     /tyc-<command>"
echo ""
echo "申请 API Key：https://agent.tianyancha.com"
echo "项目主页：$REPO_URL"
echo ""
echo -e "${GREEN}🎉 安装完成 / Installation complete!${NC}"

# 清理临时目录
if [ "$INSTALL_MODE" == "curl" ]; then
    rm -rf "$TEMP_DIR"
fi
