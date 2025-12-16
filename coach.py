#!/usr/bin/env python3
"""
Prompt Coach CLI - 命令行集成示例

这个脚本展示如何将Prompt Coach集成到你的工作流中
"""

import sys
import json
import subprocess
from pathlib import Path

COACH_PATH = Path.home() / ".claude" / "subagents" / "prompt-coach"

def realtime_optimize(prompt: str) -> None:
    """实时优化模式"""
    coach_prompt = f"""
作为Prompt Coach,分析并优化以下prompt:

{prompt}

请按照realtime模式输出格式提供:
1. 质量评分
2. 问题诊断
3. 3个优化方案
"""
    
    # 调用Claude Code
    result = subprocess.run(
        ["claude", "-p", coach_prompt],
        capture_output=True,
        text=True
    )
    
    print(result.stdout)

def batch_analyze(count: int = 20) -> None:
    """批量分析模式"""
    coach_prompt = f"""
作为Prompt Coach,运行批量分析模式:

1. 分析我最近{count}条对话
2. 识别成功和失败模式
3. 生成个性化模板
4. 提供改进建议

请按照batch模式输出格式生成完整报告。
"""
    
    result = subprocess.run(
        ["claude", "-p", coach_prompt],
        capture_output=True,
        text=True
    )
    
    print(result.stdout)
    
    # 保存报告
    report_path = COACH_PATH / "data" / "reports" / f"analysis_{count}.md"
    report_path.parent.mkdir(exist_ok=True, parents=True)
    report_path.write_text(result.stdout)
    
    print(f"\n报告已保存到: {report_path}")

def quick_score(prompt: str) -> None:
    """快速评分(不提供优化建议)"""
    coach_prompt = f"""
作为Prompt Coach,快速评分这个prompt (只输出总分和1句关键建议):

{prompt}

格式: [分数]/100 - [一句话建议]
"""
    
    result = subprocess.run(
        ["claude", "-p", coach_prompt],
        capture_output=True,
        text=True
    )
    
    print(result.stdout.strip())

def main():
    if len(sys.argv) < 2:
        print("""
Prompt Coach CLI

用法:
  coach optimize "your prompt"     # 实时优化
  coach batch [count]              # 批量分析
  coach score "your prompt"        # 快速评分
  
示例:
  coach optimize "研究Twitter推文内容"
  coach batch 20
  coach score "帮我分析一下这个项目"
        """)
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "optimize":
        if len(sys.argv) < 3:
            print("错误: 请提供要优化的prompt")
            sys.exit(1)
        realtime_optimize(sys.argv[2])
    
    elif command == "batch":
        count = int(sys.argv[2]) if len(sys.argv) > 2 else 20
        batch_analyze(count)
    
    elif command == "score":
        if len(sys.argv) < 3:
            print("错误: 请提供要评分的prompt")
            sys.exit(1)
        quick_score(sys.argv[2])
    
    else:
        print(f"未知命令: {command}")
        sys.exit(1)

if __name__ == "__main__":
    main()
