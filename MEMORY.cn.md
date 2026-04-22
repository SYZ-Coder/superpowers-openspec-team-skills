# Superpowers 记忆指南

这份文档说明可选的 Superpowers 记忆功能是怎么工作的、怎么开启、怎么使用，以及怎么关闭。

## 这是什么

Superpowers 记忆是一层持久化到仓库里的上下文机制，服务于 Superpowers 相关 workflow。

它不是把上下文只留在某一次聊天里，而是把真正有价值的项目背景写回仓库：

- 稳定的项目事实
- 当前工作状态
- 关键决策
- 已知失败模式
- 验证基线
- 可复用经验
- 简短会话记录

这样下一次新会话就可以直接从仓库恢复上下文，而不是每次都从零开始解释。

## 默认行为

这项能力默认是不启用的。

安装本仓库或安装 workflow bundle，并不会自动开启下面这些行为：

- Superpowers 记忆
- 自动读取记忆文件
- 自动写回记忆文件
- 自动学习沉淀
- workflow 自动启用

只有在下面这些条件满足时，记忆能力才会真正参与：

1. 目标项目里存在 `.superpowers-memory/`
2. 已安装对应的项目级集成，或者 workflow 明确会读取记忆
3. 在需要 workflow 的场景下，用户明确调用了相关 workflow

也就是说：

- 安装只是让能力可用
- 显式配置才会启用记忆
- 显式调用才会启用 workflow

## 会保存什么

启用后，项目可以使用这套结构：

```text
.superpowers-memory/
  PROJECT_CONTEXT.md
  CURRENT_STATE.md
  DECISIONS.md
  KNOWN_FAILURES.md
  VERIFICATION_BASELINE.md
  TEAM_PREFERENCES.md
  LEARNING_BACKLOG.md
  memory-index.yaml
  session-journal/
```

### `PROJECT_CONTEXT.md`

这个文件用来保存长期稳定的信息：

- 项目是做什么的
- 架构说明
- 协作约定
- 已知约束

### `CURRENT_STATE.md`

这个文件用来保存当前最新的工作状态：

- 现在正在做什么
- 最近做了哪些决定
- 还有哪些开放问题
- 下一步建议做什么

### `DECISIONS.md`

这个文件用来保存跨会话仍然重要的设计或流程决策。

### `KNOWN_FAILURES.md`

这个文件用来保存重复出现的失败模式、环境坑、流程陷阱和常见误判。

### `VERIFICATION_BASELINE.md`

这个文件用来保存团队认为足够可信的验证命令或验证方法。

### `TEAM_PREFERENCES.md`

这个文件用来保存稳定的协作偏好、沟通边界和团队约定。

### `LEARNING_BACKLOG.md`

这个文件用来保存未来可能值得沉淀成 workflow、skill、checklist、项目规则或校验脚本的可复用经验。

### `memory-index.yaml`

这个文件用来保存记忆健康度和轻量索引元数据，例如新鲜度、过期条目数量和 backlog 状态。

### `session-journal/`

这个目录用来保存每次重要会话的一条简短记录。

## 它怎么工作

当 Superpowers 相关 workflow 看到项目里存在 `.superpowers-memory/` 时，它应该：

1. 先读取 `PROJECT_CONTEXT.md`
2. 再读取 `CURRENT_STATE.md`
3. 如果存在，也读取 `DECISIONS.md` 和 `KNOWN_FAILURES.md`
4. 再读取最新的 session journal
5. 在提问前先使用这些上下文，而不是让用户重复讲项目背景
6. 在一次有意义的会话结束前更新对应的记忆文件
7. 当 workflow 依赖记忆质量时，在宣称完成前运行记忆校验

## 使用规则

### 规则 1：把不同类型的记忆分开放

- 长期稳定的项目知识写到 `PROJECT_CONTEXT.md`
- 当前工作状态写到 `CURRENT_STATE.md`
- 仍然重要的决策写到 `DECISIONS.md`
- 重复出现的失败模式写到 `KNOWN_FAILURES.md`
- 每次会话的摘要写到 `session-journal/`

### 规则 2：journal 要短

session journal 不是完整复盘，重点是让下一次会话能快速接上。

### 规则 3：重要条目尽量写来源和置信度

对于长期有效的条目，建议补充：

- source
- status
- confidence
- last_updated

### 规则 4：在关键节点更新记忆

比较适合更新记忆的时机：

- 设计确认之后
- 实现和验证完成之后
- 做出关键决策之后
- 发现重复失败模式之后
- 确认新的验证基线之后
- OpenSpec change 归档之后

### 规则 5：记忆不等于自动启用 workflow

记忆的作用是恢复上下文，不代表 Superpowers workflow 可以自动启用。

### 规则 6：发现旧内容不准确就修正

如果旧记忆不准确，应该修正或替换，而不是不断叠加相互矛盾的内容。

### 规则 7：backlog 里的经验只是候选，不是自动升级规则

一条经验通常应该在多次出现、确实有复用价值后，才考虑升级成长期规则、checklist、workflow 步骤或 skill。

## 如何开启

### 1. 安装记忆骨架

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot <project-root>
```

### 2. 安装工具级记忆集成

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool all -ProjectRoot <project-root>
```

也可以按单个工具安装：

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool codex -ProjectRoot <project-root>
.\scripts\install-superpowers-memory-integration.ps1 -Tool cursor -ProjectRoot <project-root>
.\scripts\install-superpowers-memory-integration.ps1 -Tool claude-code -ProjectRoot <project-root>
```

## 用户如何使用

最简单的使用方式就是：

1. 先安装记忆骨架
2. 先把 `PROJECT_CONTEXT.md` 填一版
3. 保持 `CURRENT_STATE.md` 是最新的
4. 当新的稳定决策、失败模式或验证规则出现时，写入对应文件
5. 让 Superpowers 相关 workflow 在结束时补一条短 journal
6. 在关键更新后运行 `scripts/validate-superpowers-memory.ps1`
7. 如果项目级指令文件更新了，重新打开你的工具

## 如何关闭

### 方式 1：不再使用记忆目录

如果项目里没有 `.superpowers-memory/`，workflow 就应该跳过记忆逻辑。

### 方式 2：移除项目级工具集成

- 删除 `AGENTS.md` 里的 `superpowers-memory` 管理块
- 删除 `.cursor/rules/superpowers-memory.mdc`
- 删除 `CLAUDE.md` 里的 `superpowers-memory` 管理块

## 如何验证

### 记忆骨架

```powershell
Test-Path "<project-root>\\.superpowers-memory\\PROJECT_CONTEXT.md"
Test-Path "<project-root>\\.superpowers-memory\\CURRENT_STATE.md"
Test-Path "<project-root>\\.superpowers-memory\\session-journal"
```

### Codex 集成

```powershell
Select-String -Path "<project-root>\\AGENTS.md" -Pattern "superpowers-memory:start"
```

### Cursor 集成

```powershell
Test-Path "<project-root>\\.cursor\\rules\\superpowers-memory.mdc"
```

### Claude Code 集成

```powershell
Select-String -Path "<project-root>\\CLAUDE.md" -Pattern "superpowers-memory:start"
```

### 记忆校验

```powershell
.\scripts\validate-superpowers-memory.ps1 -ProjectRoot <project-root>
```

## 适合什么场景

这套记忆机制比较适合这些情况：

- 项目会持续几天到几周反复协作
- 团队希望 AI 记住架构、决策和失败经验
- 团队希望记忆留在仓库里，而不是依赖私有外部系统
- 团队希望可复用经验最终能沉淀成显式规则或工具

它是有意做得比较轻的，不追求变成完整任务系统，也不做隐藏的私有记忆服务。
