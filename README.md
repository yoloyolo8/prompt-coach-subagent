# Prompt Coach Subagent

一个智能prompt优化助手，支持实时优化和批量分析两种模式。

## 🎯 功能特性

### 实时模式
- 在写prompt前提供优化建议
- 分析当前prompt的质量（清晰度、结构、上下文、效率）
- 给出3-5个优化方案
- 学习并应用你的个人偏好（如"约束扫描"框架）

### 批量模式
- 分析最近N条历史对话
- 识别高效/低效模式
- 提取最佳实践模板
- 生成个性化学习报告
- 更新模式库供实时模式使用

## 📦 安装

### 方式1：全局安装（推荐）
```bash
# 复制到Claude Code配置目录
cp -r prompt-coach-subagent ~/.claude/subagents/

# 在 ~/.claude/CLAUDE.md 中添加：
# - 支持 `/coach` 命令调用Prompt Coach
```

### 方式2：项目级安装
```bash
# 复制到项目目录
cp -r prompt-coach-subagent .claude/subagents/

# 在项目 .claude/CLAUDE.md 中添加subagent声明
```

## 🚀 使用方法

### 实时优化模式

#### 方法1：直接询问
```bash
claude

# 然后在对话中：
"帮我优化这个prompt：研究Twitter推文内容"
# Coach会自动分析并给出优化建议
```

#### 方法2：使用命令
```bash
# 创建别名（添加到 ~/.bashrc 或 ~/.zshrc）
alias coach='claude -p "$(cat)" --subagent prompt-coach'

# 使用
echo "你的prompt" | coach
```

#### 方法3：交互式
```bash
claude --subagent prompt-coach --mode realtime

# 进入交互式优化会话
# 输入prompt，获得实时建议
```

### 批量分析模式

```bash
# 分析最近20条对话
claude --subagent prompt-coach --mode batch --recent 20

# 分析特定日期范围
claude --subagent prompt-coach --mode batch --from 2024-12-01 --to 2024-12-16

# 生成月度报告
claude --subagent prompt-coach --mode batch --monthly
```

## 📊 输出示例

### 实时模式输出
```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Prompt质量分析
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

原始Prompt:
"研究Twitter推文内容"

质量评分: 42/100
├─ 清晰度: 8/25  (目标模糊)
├─ 结构化: 10/25 (无结构)
├─ 上下文: 12/25 (缺少背景)
└─ 效率性: 12/25 (预计需多轮澄清)

❌ 主要问题:
1. 未明确研究目的
2. 缺少输出要求
3. 无约束条件

💡 优化方案:

【方案1】结构化版本 (推荐)
"分析Twitter推文 [链接]：
1. 项目基本信息（功能、技术栈）
2. 传播数据（浏览量、互动数）
3. 病毒式传播的3个关键因素
输出：800字以内的Markdown分析报告"

质量预估: 85/100 ⬆️ +43

【方案2】约束扫描版本
"用约束扫描框架分析这条推文项目：
<context>推文链接：[URL]</context>
<task>
1. 建模：产品传播的系统模型
2. 主约束：用户参与度的关键限制
3. 极端化分析：0参与 vs 病毒式传播的差异
4. 决策区间：可复制的临界点在哪
</task>
<output>
- 核心约束列表（3-5个）
- 每个约束的作用机制
- 可迁移的设计原则
</output>"

质量预估: 92/100 ⬆️ +50
(匹配你的"约束扫描"思维框架)

【方案3】目标导向版本
"我想了解这个Twitter项目为何突然火爆：
- 目标：提取可复用的创意方法
- 背景：我在做类似的产品设计
- 输出：3个最关键的病毒式传播要素 + 各附1个实施建议"

质量预估: 78/100 ⬆️ +36

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 批量模式输出
```markdown
# Prompt质量分析报告
生成时间: 2024-12-16
分析范围: 最近20条对话

## 📈 总体统计
- 平均质量分: 67/100
- 优秀 (80+): 3条 (15%)
- 良好 (60-80): 9条 (45%)
- 待优化 (<60): 8条 (40%)

## 🎯 个人模式识别

### ✅ 你的成功模式
1. **结构化 + 约束明确** (92分均值)
   - 案例: "60分钟快速入门学习框架"
   - 特征: 明确的5部分结构 + 具体要求
   - 使用频率: 15%
   
2. **约束扫描框架应用** (88分均值)
   - 案例: "思想实验的四步方法论"
   - 特征: 建模→约束→参数化→极端化
   - 使用频率: 25%
   - 💡 建议: 可扩大应用范围

### ❌ 常见低效模式
1. **目标模糊型** (45分均值, 40%占比)
   - 典型: "研究一下...", "帮我看看..."
   - 问题: 需要2-3轮澄清
   - 优化: 明确"研究什么方面"+"需要什么输出"

2. **上下文缺失型** (52分均值, 30%占比)
   - 典型: 直接贴链接/代码，无说明
   - 问题: Claude需要猜测意图
   - 优化: 添加"为什么需要"+"期望什么"

## 📚 为你生成的模板库

### 模板1: 技术分析类
```markdown
分析 [技术/项目]：
<context>
- 背景: [为什么研究]
- 目标: [想解决什么问题]
</context>
<task>
1. [具体分析维度1]
2. [具体分析维度2]
3. [具体分析维度3]
</task>
<output>
- 格式: [Markdown/JSON/代码]
- 长度: [字数/代码行数]
- 重点: [最关心的点]
</output>
```

### 模板2: 约束扫描类
[... 更多模板]

## 💡 改进建议
1. **立即可用**: 将"约束扫描"模板添加到快捷命令
2. **短期优化**: 技术查询时主动提供上下文
3. **长期培养**: 在开放式探索前先定义"成功标准"
```

## ⚙️ 配置

编辑 `config.json` 自定义：
```json
{
  "analysis_dimensions": {
    "clarity": { "weight": 0.25, "enabled": true },
    "structure": { "weight": 0.25, "enabled": true },
    "context": { "weight": 0.25, "enabled": true },
    "efficiency": { "weight": 0.25, "enabled": true }
  },
  "personal_frameworks": [
    "约束扫描 (constraint scanning)",
    "分层模块化"
  ],
  "batch_analysis": {
    "default_count": 20,
    "max_count": 100,
    "generate_templates": true,
    "update_patterns": true
  },
  "realtime_suggestions": 3,
  "auto_learn": true
}
```

## 🔄 工作流集成

### 与Claude Code集成
```bash
# 在编写复杂prompt前
coach-check

# 周末批量回顾
cron: 0 20 * * 0 claude --subagent prompt-coach --mode batch --weekly
```

### 与N8N集成
- 可通过webhook接收prompt
- 返回优化建议
- 记录到数据库供分析

## 📁 文件结构
```
prompt-coach-subagent/
├── README.md              # 本文件
├── COACH.md              # Subagent主prompt
├── config.json           # 配置文件
├── modes/
│   ├── realtime.md      # 实时模式prompt
│   └── batch.md         # 批量模式prompt
├── templates/
│   ├── analysis.md      # 分析输出模板
│   ├── report.md        # 报告输出模板
│   └── patterns.json    # 模式库模板
└── data/
    ├── patterns.json    # 学习到的个人模式
    └── history.jsonl    # 优化历史记录
```

## 🎓 最佳实践

1. **首次使用**: 先运行批量模式建立基线
2. **日常使用**: 遇到复杂prompt时调用实时模式
3. **定期回顾**: 每周/月运行批量分析，更新模式库
4. **持续优化**: 让subagent学习你的反馈

## 🐛 故障排查

**Q: Subagent无响应**
A: 检查 CLAUDE.md 中是否正确声明了subagent路径

**Q: 批量模式报错"无法访问对话历史"**
A: 确保有conversation_search和recent_chats工具权限

**Q: 实时建议不够个性化**
A: 运行批量模式累积更多学习数据

## 📝 更新日志

- v1.0.0 (2024-12-16): 初始版本，支持实时和批量模式
