# Prompt Coach - 快速开始

## 5分钟快速开始

### 步骤1: 安装
```bash
# 克隆或复制subagent到Claude配置目录
cp -r prompt-coach-subagent ~/.claude/subagents/prompt-coach

# 或者放在项目目录
cp -r prompt-coach-subagent .claude/subagents/prompt-coach
```

### 步骤2: 配置Claude Code识别
在 `~/.claude/CLAUDE.md` (全局) 或 `.claude/CLAUDE.md` (项目级) 添加:

```markdown
## Available Subagents

### Prompt Coach
Location: `~/.claude/subagents/prompt-coach/COACH.md`
Purpose: Analyze and optimize prompts in real-time or batch mode
Invoke with: "优化这个prompt: ..." or "分析我最近的对话"
```

### 步骤3: 首次使用
```bash
# 启动Claude Code
claude

# 在对话中使用:
```

**实时模式**:
```
优化这个prompt: 研究Twitter推文内容
```

**批量模式**:
```
分析我最近20条对话,找出可以优化的模式
```

---

## 使用方式

### 方式1: 自然对话 (推荐)
直接在Claude对话中:
```
"帮我优化这个prompt: [你的prompt]"
"我想看看最近的对话有哪些可以改进的"
"生成一些我常用的prompt模板"
```

Coach会自动识别意图并切换到相应模式。

### 方式2: 命令行快捷方式

创建别名 (添加到 `~/.bashrc` 或 `~/.zshrc`):
```bash
# 实时优化
alias coach='claude -p "作为Prompt Coach,分析并优化以下prompt:"'

# 批量分析
alias coach-batch='claude -p "作为Prompt Coach,运行批量分析模式,分析最近20条对话"'
```

使用:
```bash
# 实时
echo "研究Twitter推文内容" | coach

# 批量
coach-batch
```

### 方式3: 集成到工作流

**Claude Code Hook** (写prompt前自动检查):
```bash
# 在项目 .claude/hooks/pre-prompt.sh
#!/bin/bash
PROMPT="$1"
LENGTH=${#PROMPT}

# 只检查复杂prompt (>100字符)
if [ $LENGTH -gt 100 ]; then
    echo "🤔 检测到复杂prompt,运行快速分析..."
    claude -p "Prompt Coach: 快速评分这个prompt (只输出分数和1句建议): $PROMPT"
fi
```

**N8N集成**:
```json
{
  "nodes": [
    {
      "name": "Prompt Quality Check",
      "type": "HTTP Request",
      "parameters": {
        "url": "https://api.anthropic.com/v1/messages",
        "method": "POST",
        "body": {
          "model": "claude-sonnet-4-20250514",
          "system": "{{$node['Load Coach'].json.coach_prompt}}",
          "messages": [
            {
              "role": "user",
              "content": "分析: {{$json.user_prompt}}"
            }
          ]
        }
      }
    }
  ]
}
```

---

## 典型使用场景

### 场景1: 写复杂技术分析prompt

**之前**:
```
我: "分析一下这个GitHub项目"
Claude: "请问你想了解项目的哪些方面?"
我: "就是...它是干什么的,怎么用"
Claude: "好的,你能提供项目链接吗?"
[... 3-4轮澄清]
```

**使用Coach后**:
```
我: "优化这个prompt: 分析一下这个GitHub项目"
Coach: [提供3个优化方案]
我: [选择方案2,一次性得到完整分析]
```

### 场景2: 周末回顾本周对话

```bash
# 每周日晚上运行
coach-batch

# 得到:
# - 本周平均质量分
# - 发现的低效模式
# - 3-5个可复用模板
# - 下周改进建议
```

### 场景3: 建立团队最佳实践

```bash
# 分析最近50条高质量对话
claude -p "Prompt Coach批量模式: 分析最近50条对话,只保留80分以上的,提取成5个团队模板"

# 输出模板分享给团队
# 建立团队prompt规范
```

---

## 高级用法

### 自定义分析维度

编辑 `config.json`:
```json
{
  "analysis_dimensions": {
    "clarity": { "weight": 0.3 },  // 增加清晰度权重
    "structure": { "weight": 0.2 },
    "context": { "weight": 0.2 },
    "efficiency": { "weight": 0.3 }
  }
}
```

### 添加个人框架

编辑 `config.json`:
```json
{
  "personal_frameworks": [
    {
      "name": "我的框架名称",
      "structure": "步骤1 → 步骤2 → 步骤3",
      "keywords": ["关键词1", "关键词2"],
      "enabled": true,
      "priority": 3
    }
  ]
}
```

Coach会自动识别并在优化建议中应用你的框架。

### 持续学习模式

启用自动学习:
```json
{
  "learning": {
    "auto_learn": true,
    "update_frequency": "after_batch"
  }
}
```

每次批量分析后,Coach会:
1. 更新个人模式库
2. 优化评分标准
3. 生成新模板
4. 改进实时建议

---

## 查看学习成果

```bash
# 查看已学习的模式
cat ~/.claude/subagents/prompt-coach/data/patterns.json

# 查看生成的模板
cat ~/.claude/subagents/prompt-coach/templates/prompt-templates.md

# 查看分析历史
ls ~/.claude/subagents/prompt-coach/data/history/
```

---

## 常见问题

**Q: Coach没有响应?**
A: 检查CLAUDE.md中是否正确配置了subagent路径。用 `claude -v` 查看是否识别到subagent。

**Q: 批量模式说无法访问历史对话?**
A: 确保在claude.ai环境中使用,API模式下无法访问past chats。

**Q: 实时建议不够个性化?**
A: 先运行一次批量分析建立基线。Coach需要学习你的模式。

**Q: 想要更详细/更简洁的分析?**
A: 在prompt中明确说明: "给我详细分析" 或 "只要简短建议"

**Q: 如何让Coach学习新的成功模式?**
A: Coach会自动从批量分析中学习。你也可以手动编辑 `data/patterns.json` 添加模式。

---

## 进阶技巧

### 1. 建立个人prompt风格指南
```bash
# 分析最近100条对话
claude -p "Prompt Coach: 分析最近100条,提取我的写作风格特征,生成一份'个人prompt风格指南'"
```

### 2. A/B测试prompt版本
```bash
# 比较两个版本
claude -p "Prompt Coach: 比较这两个prompt的质量:
版本A: [prompt A]
版本B: [prompt B]
哪个更好?为什么?"
```

### 3. 领域专用模板
```bash
# 为特定领域生成模板
claude -p "Prompt Coach: 分析我所有关于[N8N自动化]的对话,生成3个领域专用模板"
```

### 4. 质量趋势追踪
```bash
# 每月运行
claude -p "Prompt Coach: 对比本月和上月的批量分析,我的prompt质量有提升吗?"
```

---

## 最佳实践

1. **首次使用**: 先运行批量分析(20-50条)建立基线
2. **日常使用**: 遇到复杂任务时,先优化prompt再执行
3. **定期回顾**: 每周/月运行批量分析,追踪改进
4. **模板迭代**: 将成功的prompt抽象为模板,持续优化
5. **团队共享**: 把优秀模板分享给团队,建立标准

---

## 下一步

- [ ] 运行首次批量分析: `分析我最近20条对话`
- [ ] 查看生成的模板: `templates/prompt-templates.md`
- [ ] 在下个复杂任务前使用实时优化
- [ ] 一周后再次批量分析,对比改进

Happy prompting! 🚀
