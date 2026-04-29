#!/usr/bin/env python3
"""
TYC 开源仓评估 runner 起步模板（v1.0）

用法：
    cd <repo>
    python evals/run.py

依赖：
    pip install pyyaml requests

功能：
    1. 从 evals/cases.yaml 读取用例
    2. 调用 TYC MCP endpoint 测试每个 SKILL
    3. 校验预期关键字
    4. 打印摘要 + 失败详情
"""
from __future__ import annotations

import os
import sys
from pathlib import Path

try:
    import yaml  # type: ignore
except ImportError:
    print("请先 pip install pyyaml", file=sys.stderr)
    sys.exit(1)


def load_cases(cases_file: Path) -> list[dict]:
    with cases_file.open("r", encoding="utf-8") as f:
        data = yaml.safe_load(f)
    return data.get("cases", [])


def main() -> int:
    repo_root = Path(__file__).resolve().parent.parent
    cases_file = repo_root / "evals" / "cases.yaml"

    if not cases_file.exists():
        print(f"未找到 {cases_file}", file=sys.stderr)
        return 1

    api_key = os.environ.get("TYC_MCP_API_KEY")
    if not api_key:
        print("请先设置 TYC_MCP_API_KEY 环境变量", file=sys.stderr)
        return 1

    cases = load_cases(cases_file)
    print(f"加载 {len(cases)} 个用例")

    # TODO: 调用 Claude Code MCP 客户端执行每个 case
    # 当前仅打印用例列表，作为起步模板
    for i, case in enumerate(cases, 1):
        print(f"  [{i}] {case.get('name')} - {case.get('skill')}")

    print("\n(runner 逻辑待完善，当前仅加载用例)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
