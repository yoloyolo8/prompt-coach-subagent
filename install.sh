#!/bin/bash
# Prompt Coach Subagent - 安装脚本

set -e

echo "🚀 安装 Prompt Coach Subagent..."

# 检测安装位置
if [ -d ".claude" ]; then
    INSTALL_PATH=".claude/subagents/prompt-coach"
    SCOPE="项目级"
else
    INSTALL_PATH="$HOME/.claude/subagents/prompt-coach"
    SCOPE="全局"
fi

echo "📁 安装位置: $INSTALL_PATH ($SCOPE)"

# 创建目录
mkdir -p "$INSTALL_PATH"

# 复制文件
echo "📦 复制文件..."
cp -r ./* "$INSTALL_PATH/" 2>/dev/null || true

# 创建必要的数据目录
mkdir -p "$INSTALL_PATH/data/reports"
mkdir -p "$INSTALL_PATH/data/history"

# 检查CLAUDE.md
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
if [ "$SCOPE" == "项目级" ]; then
    CLAUDE_MD=".claude/CLAUDE.md"
fi

echo "⚙️  配置 Claude Code..."

# 检查是否已经配置
if grep -q "Prompt Coach" "$CLAUDE_MD" 2>/dev/null; then
    echo "✅ Prompt Coach 已在 CLAUDE.md 中配置"
else
    echo "
## Available Subagents

### Prompt Coach
Location: \`$INSTALL_PATH/COACH.md\`
Purpose: Analyze and optimize prompts in real-time or batch mode
Invoke with: \"优化这个prompt: ...\" or \"分析我最近的对话\"
" >> "$CLAUDE_MD"
    echo "✅ 已添加配置到 CLAUDE.md"
fi

# 添加CLI命令到PATH (可选)
echo ""
echo "🔧 可选: 添加CLI命令到PATH"
echo "运行以下命令以使用 'coach' 命令:"
echo ""
echo "  echo 'export PATH=\"$INSTALL_PATH:\$PATH\"' >> ~/.bashrc"
echo "  source ~/.bashrc"
echo ""
echo "  # 或者创建符号链接:"
echo "  ln -s $INSTALL_PATH/coach.py /usr/local/bin/coach"
echo ""

# 创建示例配置
if [ ! -f "$INSTALL_PATH/config.local.json" ]; then
    cp "$INSTALL_PATH/config.json" "$INSTALL_PATH/config.local.json"
    echo "📝 已创建本地配置文件: config.local.json"
fi

echo ""
echo "✨ 安装完成!"
echo ""
echo "📚 下一步:"
echo "  1. 查看快速开始: cat $INSTALL_PATH/QUICKSTART.md"
echo "  2. 运行首次分析: claude -p \"分析我最近20条对话\""
echo "  3. 查看生成的模板: cat $INSTALL_PATH/templates/prompt-templates.md"
echo ""
echo "💡 使用示例:"
echo "  # 实时优化"
echo "  claude"
echo "  > 优化这个prompt: 研究Twitter推文内容"
echo ""
echo "  # 批量分析"
echo "  claude -p \"分析我最近20条对话\""
echo ""
echo "Happy prompting! 🚀"
