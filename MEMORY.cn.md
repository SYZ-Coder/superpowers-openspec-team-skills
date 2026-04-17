# Superpowers 记忆指南

这份文档说明可选的 Superpowers 记忆功能是怎么工作的、怎么开启、怎么使用，以及怎么关闭。

## 这是什么

Superpowers 记忆是一层持久化到仓库里的上下文机制，服务于 Superpowers 相关 workflow。

它不是把上下文只留在某一次聊天里，而是把真正有价值的项目背景写回仓库：

- 稳定的项目事实
- 当前工作状态
- 简短的会话记录

这样下一次新会话就可以直接从仓库恢复上下文，而不是每次都从零开始解释。

## 会保存什么

启用后，项目会使用这套结构：

```text
.superpowers-memory/
  PROJECT_CONTEXT.md
  CURRENT_STATE.md
  session-journal/
```

### `PROJECT_CONTEXT.md`

这个文件用来保存长期稳定的信息：

- 项目是做什么的
- 架构说明
- 协作约定
- 已知约束

这个文件不应该频繁变动。

### `CURRENT_STATE.md`

这个文件用来保存当前最新的工作状态：

- 现在正在做什么
- 最近做了哪些决定
- 还有哪些开放问题
- 下一步建议做什么

这个文件应该随着当前焦点变化而更新。

### `session-journal/`

这个目录用来保存每次重要会话的一条简短记录。

每条 journal 通常记录：

- 这次改了什么
- 做了什么决定
- 验证了什么
- 下一步建议是什么

## 它怎么工作

当 Superpowers 相关 workflow 看到项目里存在 `.superpowers-memory/` 时，它应该：

1. 先读取 `PROJECT_CONTEXT.md`
2. 再读取 `CURRENT_STATE.md`
3. 再读取最近的 session journal
4. 在提问前先使用这些上下文，而不是让用户重复讲项目背景
5. 在会话结束前更新 `CURRENT_STATE.md`，并补一条新的 journal

这适用于本仓库里的 Superpowers 相关 workflow，包括：

- `superpowers-feature`
- `superpowers-openspec-execution`
- `openspec-superpowers`

## 使用规则

为了让记忆有用而不是越写越乱，建议遵守这些规则。

### 规则 1：稳定事实和会话记录分开写

- 长期稳定的项目知识写进 `PROJECT_CONTEXT.md`
- 当前工作状态写进 `CURRENT_STATE.md`
- 每次会话的记录写进 `session-journal/`

不要把三类内容混在一个文件里。

### 规则 2：journal 要短

session journal 不是完整复盘，重点是让下一次会话能快速接上。

### 规则 3：在关键节点更新记忆

比较适合更新记忆的时机：

- 设计确认之后
- 实现和验证完成之后
- 做出关键决策之后
- OpenSpec change 归档之后

### 规则 4：记忆不等于自动启用 workflow

记忆的作用是恢复上下文，不代表 Superpowers workflow 可以自动启用。

workflow 仍然是显式启用。

### 规则 5：发现过期内容就修正

如果旧记忆不准确，应该修正或替换，而不是不断叠加相互矛盾的内容。

## 如何开启

这套能力分两层开启。

### 1. 安装记忆骨架

这一步会在目标项目里创建 `.superpowers-memory/`：

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot <project-root>
```

### 2. 安装工具级记忆集成

这一步会更新项目级指令文件，让支持的工具在新会话开始时更自然地读取记忆：

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
4. 让 Superpowers 相关 workflow 在结束时补一条短 journal
5. 如果项目级指令文件更新了，重新打开你的工具

### 推荐第一次先填什么

建议先写这些内容：

- 一段项目简介
- 核心模块或边界
- 关键约束
- 当前在做的任务
- 下一步建议

只要这些信息在，下一次会话的体验通常就会明显提升。

## 如何关闭

关闭也分两层。

### 方式 1：不再使用记忆目录

如果项目里没有 `.superpowers-memory/`，workflow 就应该跳过记忆逻辑。

所以最简单的关闭方式就是移除或重命名：

```text
.superpowers-memory/
```

### 方式 2：移除项目级工具集成

如果你不再希望 Codex、Cursor、Claude Code 在项目指令里主动读取记忆，可以移除这些集成：

- 删除 `AGENTS.md` 里的 `superpowers-memory` 管理块
- 删除 `.cursor/rules/superpowers-memory.mdc`
- 删除 `CLAUDE.md` 里的 `superpowers-memory` 管理块

### 临时关闭

你也可以保留这些文件，但在当前任务里明确告诉工具不要依赖记忆。

## 如何验证

安装完成后，可以这样检查：

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

## 适合什么场景

这套记忆机制比较适合这些情况：

- 项目会持续几天到几周反复协作
- 团队希望 AI 记住架构和最近决策
- 团队希望记忆留在仓库里，而不是依赖私有外部系统

它是有意做得比较轻的，不追求变成完整任务系统，也不做隐藏的私有记忆服务。
