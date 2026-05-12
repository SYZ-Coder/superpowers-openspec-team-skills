# Superpowers 记忆指南

这份文档说明可选的 Superpowers 记忆能力如何工作、如何启用、如何使用，以及如何关闭。

## 它是什么

Superpowers 记忆是一层持久化到仓库中的上下文机制，服务于 Superpowers 相关 workflow。

它不是把项目背景只留在某一轮聊天里，而是把真正有价值的上下文写回仓库：

- 稳定的项目事实
- 当前工作状态
- 关键决策
- 已知失败模式
- 验证预期
- 可复用经验
- 简短会话摘要

这样后续会话可以直接从仓库恢复上下文，而不是每次都从空白开始。

## 默认行为

这个能力默认是不启用的。

安装本仓库或安装相关 workflow bundle，并不会自动开启下面这些行为：

- Superpowers 记忆
- 自动读取记忆文件
- 自动写回记忆文件
- 自动做 learning capture
- workflow 自动激活

只有在下面这些条件同时满足时，记忆能力才会真正参与：

1. 项目里存在 `.superpowers-memory/`
2. 已安装相应的工具级集成，或者 workflow 本身显式读取记忆
3. 在需要 workflow 的场景下，用户显式调用了相关 workflow

换句话说：

- 安装只是让能力可用
- 显式配置才会启用记忆
- 显式调用才会启用 workflow

## 会保存什么

启用后，项目可以使用下面这套结构：

```text
.superpowers-memory/
  PROJECT_CONTEXT.md
  CURRENT_STATE.md
  DECISIONS.md
  KNOWN_FAILURES.md
  VERIFICATION_BASELINE.md
  TEAM_PREFERENCES.md
  USER_PROFILE.md
  AGENT_NOTES.md
  LEARNING_BACKLOG.md
  SESSION_CLOSE_CHECKLIST.md
  memory-index.yaml
  session-journal/
```

### `PROJECT_CONTEXT.md`

用来保存长期稳定的信息：

- 项目是做什么的
- 架构说明
- 协作约定
- 已知约束

这个文件应当变化较慢。

### `CURRENT_STATE.md`

用来保存最新的工作现场：

- 当前在做什么
- 最近做了哪些决定
- 还有哪些开放问题
- 下一步建议是什么

当前焦点变化时应更新这个文件。

### `DECISIONS.md`

用来保存跨会话仍然重要的设计或流程决策。

### `KNOWN_FAILURES.md`

用来保存重复出现的失败模式、环境陷阱和流程坑。

### `VERIFICATION_BASELINE.md`

用来保存团队认为足够可信的验证命令或验证方法。

### `TEAM_PREFERENCES.md`

用来保存稳定的协作偏好和工作约定，供后续会话遵循。

### `USER_PROFILE.md`

用来保存稳定的用户偏好，例如沟通方式、输出习惯、协作边界，但这些内容不属于项目事实。

### `AGENT_NOTES.md`

用来保存与这个仓库相关的稳定执行提醒，例如反复出现的操作陷阱或 agent 侧质量提醒。

### `LEARNING_BACKLOG.md`

用来保存未来可能值得沉淀成 workflow、skill、checklist、项目规则或验证脚本的可复用经验。

这里记录的是“看起来可复用”的模式，不是一次性便签。

### `SESSION_CLOSE_CHECKLIST.md`

用来作为统一的会话收尾提醒，在宣称记忆相关工作完成前先检查一遍。

### `memory-index.yaml`

用来保存记忆健康度元数据和轻量索引，例如新鲜度、过期条目数量和 backlog 状态。

### `session-journal/`

用来为每次有意义的会话保留一条简短的 Markdown 记录。

典型 journal 应包含：

- 改了什么
- 决定了什么
- 验证了什么
- 下一步建议做什么

## 它怎么工作

当某个 Superpowers 相关 workflow 发现项目里有 `.superpowers-memory/` 时，它应当：

1. 读取 `PROJECT_CONTEXT.md`
2. 读取 `CURRENT_STATE.md`
3. 如果存在，再读取 `DECISIONS.md`、`KNOWN_FAILURES.md`、`VERIFICATION_BASELINE.md`、`TEAM_PREFERENCES.md`、`USER_PROFILE.md`、`AGENT_NOTES.md`
4. 读取最新的 session journal
5. 在向用户追问背景前，先使用这些上下文
6. 在一次有意义的会话结束前更新相关记忆文件
7. 当 workflow 依赖记忆质量时，在宣称完成前运行记忆校验

这适用于本仓库里的 Superpowers 相关 workflow，包括：

- `superpowers-feature`
- `superpowers-openspec-execution`
- `openspec-superpowers`
- `superpowers-learning`

## 规则

下面这些规则用来保证记忆有用，而不是变成噪音。

### 规则 1：把稳定事实和会话笔记分开存

- 长期项目知识放进 `PROJECT_CONTEXT.md`
- 当前工作状态放进 `CURRENT_STATE.md`
- 长期决策放进 `DECISIONS.md`
- 重复失败模式放进 `KNOWN_FAILURES.md`
- 持久用户偏好放进 `USER_PROFILE.md`
- agent 执行提醒放进 `AGENT_NOTES.md`
- 每次会话笔记放进 `session-journal/`

不要把它们全都混进一个文件里。

### 规则 2：journal 要短

session journal 不是完整复盘，重点是让下一次会话能快速接上。

### 规则 3：重要条目要带来源和置信度

对 durable entry，至少要求：

- `id`
- `review_after`
- `source`
- `status`
- `confidence`
- `last_updated`

如果 `source` 为空，就不应把条目标成 `verified`。

### 规则 4：在关键节点更新记忆

比较适合更新记忆的时机：

- 设计确认后
- 实现和验证完成后
- 做出重大决策后
- 发现重复失败模式后
- 确认新的验证基线后
- OpenSpec change 归档后
- 一次修改了 durable memory 的会话结束前

### 规则 5：记忆不等于自动启用 workflow

记忆的作用是恢复上下文，不代表 Superpowers workflow 可以自动激活。

workflow 仍然必须显式 opt-in。

### 规则 6：优先修正，而不是不断堆叠

如果旧记忆不准确，应修正或替换，而不是不断叠加相互矛盾的内容。

### 规则 7：把 backlog 项看作候选，不是自动规则

一条经验通常应先证明自己在多次会话中都真的有价值，再升级成长期规则、checklist、workflow step 或 skill。

### 规则 8：在宣称记忆工作完成前先过一遍 session-close checklist

在结束一次有意义的会话前，先看 `SESSION_CLOSE_CHECKLIST.md`，至少确认：

- current state 已更新
- 需要时已有 journal
- durable entry 带了必填元数据
- promotion candidate 的证据足够
- 记忆有变化时已经跑过 validator

## 如何启用

你可以分两层启用。

### 1. 安装记忆脚手架

这一步会在目标项目里创建 `.superpowers-memory/`：

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot <project-root>
```

### 2. 安装工具级记忆集成

这一步会更新项目级指令文件，让支持的工具在会话开始时更自然地读取记忆：

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool all -ProjectRoot <project-root>
```

也可以按工具分别安装：

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool codex -ProjectRoot <project-root>
.\scripts\install-superpowers-memory-integration.ps1 -Tool cursor -ProjectRoot <project-root>
.\scripts\install-superpowers-memory-integration.ps1 -Tool claude-code -ProjectRoot <project-root>
```

## 用户如何使用

最简单的使用方式是：

1. 安装记忆脚手架
2. 先填好 `PROJECT_CONTEXT.md`
3. 保持 `CURRENT_STATE.md` 是最新的
4. 当新的长期决策、失败模式、验证规则出现时，写入对应文件
5. 让 Superpowers 相关 workflow 补一条短 journal
6. 在宣称记忆更新完成前先看 `SESSION_CLOSE_CHECKLIST.md`
7. 在关键更新后运行 `scripts/validate-superpowers-memory.ps1`
8. 用 `scripts/search-superpowers-memory.ps1` 确认某个决策、失败模式或经验是否已经存在
9. 在收尾时拿不准该更新哪类记忆，就运行 `scripts/suggest-superpowers-memory-updates.ps1`
10. 如果想把 checklist、建议和可选校验串成一次收尾动作，就运行 `scripts/run-superpowers-memory-closeout.ps1`
11. 如果项目级指令文件更新了，重新打开工具项目

### 安装完成后，下一步应该做什么

安装好记忆集成，并不等于已经“有明显效果地使用上了记忆”。更实用的下一步是：

1. 确认目标项目里已经有 `.superpowers-memory/`
2. 确认当前工具对应的集成文件已经存在
3. 重新打开或刷新工具项目，让新的项目级指令生效
4. 至少给 `PROJECT_CONTEXT.md` 和 `CURRENT_STATE.md` 补几行内容
5. 新开一个会话
6. 在新会话里正常开始工作，让工具先读取 repo memory

如果记忆文件是空的，也可以算“已经启用”，但效果通常会比较弱，因为工具读不到多少上下文。

### 第一次使用时，最小要补什么

不需要一开始就把所有记忆文件写满。只要先补一点最关键的内容，后续会话就能明显更顺：

`PROJECT_CONTEXT.md`

```md
# Project Context
- hobby-map 是一个地图类兴趣发现项目。
- 主要技术栈：Vue 3 + Spring Boot + MySQL。
- 核心模块：地图视图、点位管理、用户收藏。
```

`CURRENT_STATE.md`

```md
# Current State
- 当前重点：修复地图 marker 聚合和详情面板行为。
- 最近完成：接通基础点位列表和详情查询接口。
- 下一步：验证 marker 点击链路和移动端布局。
```

哪怕只有这几行，也已经足够让后续会话少问很多重复背景。

### 怎么判断自己已经真正开始使用记忆

安装之后，通常满足下面这些条件，才算进入“日常可用”的状态：

1. 项目里存在 `.superpowers-memory/`
2. 对应工具的集成文件已经写入
3. 安装后已经重新打开或刷新过项目
4. 已经新开了一个会话
5. 记忆文件里已经有可读的内容

常见表现包括：

- 工具减少了重复询问项目背景
- 工具能根据 `CURRENT_STATE.md` 接上当前工作现场
- 工具能引用已存在的长期决策、约束或失败经验

需要注意：记忆开始生效，不等于 workflow 自动启用。很多场景下，工具会先读取记忆，但 workflow 仍然需要你显式调用。

### 面向开源用户的默认推荐用法

跨工具来看，最实用的模式其实很简单：让工具在新会话开始时先读取 repo memory，把“写回记忆”当成一次显式收尾动作，而不是期待普通聊天自动写入。

对大多数开源用户来说，最推荐的默认方式是：

1. 平时正常开发
2. 让工具在新会话开始时先读取 repo memory
3. 做完一轮有意义的工作后，显式做一次记忆收尾

默认最推荐的收尾入口是 `superpowers-learning-workflow`。原因是它比完整交付 workflow 更轻，更容易落地，而且它的目标就是沉淀当前状态、可复用经验和简短会话结论。

推荐提示词：

```text
Use $superpowers-learning-workflow to capture what this session taught us and update the project memory.
```

这套默认方式可以跨工具使用：

- 在 Cursor 里，可以在一轮工作结束后直接在聊天里使用 workflow 名称
- 在 Codex 里，也可以在一轮工作结束后直接在聊天里使用 workflow 名称
- 在 Claude Code 里，如果安装了对应 workflow bundle，更推荐优先使用生成出来的 slash command

如果当前没有安装 `superpowers-learning-workflow`，或者你想要一个更轻量的备选方式，可以改用 closeout helper：

```powershell
.\scripts\run-superpowers-memory-closeout.ps1 -ProjectRoot <project-root> -ChangedPaths "src","docs" -Signals "decision","validation" -RunValidator
```

更大的几个 workflow 只适合“除了记忆，还想一起使用设计、计划、验证纪律”的场景，而不适合仅仅为了记忆沉淀就默认启用：

- `superpowers-feature-workflow`
- `openspec-superpowers-workflow`
- `superpowers-openspec-execution-workflow`

### 推荐的三种使用模式

你可以把记忆使用方式分成三档，选一种长期坚持即可。

#### 模式 1：轻量默认模式

最适合大多数开源用户。

1. 保持 `PROJECT_CONTEXT.md` 和 `CURRENT_STATE.md` 基本最新
2. 新会话正常开始，让工具先读取 memory
3. 一轮有意义的工作结束后，运行 `superpowers-learning-workflow`
4. 如果 memory 变了，再跑校验

#### 模式 2：脚本辅助收尾模式

适合想要提醒式支持，但又不想引入完整 workflow 的用户。

1. 平时正常工作
2. 收尾时运行 `scripts/run-superpowers-memory-closeout.ps1`
3. 按建议更新对应 memory 文件
4. 运行 `scripts/validate-superpowers-memory.ps1`

这个模式更轻，但它不会自己写入 memory。

#### 模式 3：完整 workflow 交付模式

适合不仅想用记忆，还想把设计门禁、计划、验证纪律和 memory 对齐一起带起来的团队。

典型选择包括：

- `superpowers-feature-workflow`
- `openspec-superpowers-workflow`
- `superpowers-openspec-execution-workflow`

如果你的目标只是“让工具记住这次会话发生了什么”，不建议默认上这一档。

### 一个更直观的 Cursor 使用示例

假设你的项目路径是 `D:\ys\ysProjects\Hobby\hobby-map`，一个典型流程可以是：

1. 安装记忆脚手架

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot D:\ys\ysProjects\Hobby\hobby-map
```

2. 安装 Cursor 记忆集成

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool cursor -ProjectRoot D:\ys\ysProjects\Hobby\hobby-map
```

3. 检查关键文件是否存在

```powershell
Test-Path "D:\ys\ysProjects\Hobby\hobby-map\.superpowers-memory\PROJECT_CONTEXT.md"
Test-Path "D:\ys\ysProjects\Hobby\hobby-map\.cursor\rules\superpowers-memory.mdc"
```

4. 给 `PROJECT_CONTEXT.md` 和 `CURRENT_STATE.md` 先补一个最小版本
5. 重开 Cursor 或刷新项目
6. 新开一个聊天会话
7. 直接开始提真实需求，例如：

```text
请先基于 repo memory 理解 hobby-map 当前上下文，再帮我判断下一步优先做什么。
```

到这里，才算真正进入“日常使用记忆”的状态。

### 一个更直观的 Codex 使用示例

对 Codex 来说，主要差异是项目级指令来自 `AGENTS.md`。如果你刚安装了记忆集成，或者更新了项目级技能/指令，最好重开或刷新项目，让 Codex 重新发现这些内容。

一个典型流程可以是：

1. 安装记忆脚手架

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot D:\ys\ysProjects\Hobby\hobby-map
```

2. 安装 Codex 记忆集成

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool codex -ProjectRoot D:\ys\ysProjects\Hobby\hobby-map
```

3. 检查关键文件是否存在

```powershell
Test-Path "D:\ys\ysProjects\Hobby\hobby-map\.superpowers-memory\PROJECT_CONTEXT.md"
Select-String -Path "D:\ys\ysProjects\Hobby\hobby-map\AGENTS.md" -Pattern "superpowers-memory:start"
```

4. 给 `PROJECT_CONTEXT.md` 和 `CURRENT_STATE.md` 先补一个最小版本
5. 重开或刷新 Codex 项目
6. 新开一个会话
7. 直接开始提真实需求，例如：

```text
请先读取 repo memory，再帮我继续 hobby-map 当前这轮工作。
```

对 Codex 来说，这里的“重开或刷新项目”比较关键，因为它需要先加载更新后的项目级指令，再在新会话开始时使用记忆。

### 一个更直观的 Claude Code 使用示例

对 Claude Code 来说，记忆集成可以和 workflow bundle 一起工作，但如果你要启用某个 workflow，通常更建议优先使用生成出来的 slash command，而不是只靠自然语言描述。

一个典型流程可以是：

1. 安装记忆脚手架

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot D:\ys\ysProjects\Hobby\hobby-map
```

2. 安装 Claude Code 记忆集成

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool claude-code -ProjectRoot D:\ys\ysProjects\Hobby\hobby-map
```

3. 检查关键文件是否存在

```powershell
Test-Path "D:\ys\ysProjects\Hobby\hobby-map\.superpowers-memory\PROJECT_CONTEXT.md"
Select-String -Path "D:\ys\ysProjects\Hobby\hobby-map\CLAUDE.md" -Pattern "superpowers-memory:start"
```

4. 给 `PROJECT_CONTEXT.md` 和 `CURRENT_STATE.md` 先补一个最小版本
5. 重开或刷新 Claude Code 项目
6. 新开一个会话
7. 如果要启用 bundle 里的 workflow，优先使用生成的 slash command，让 Claude Code 读取命令文件并稳定应用 workflow 门禁
8. 再开始提真实需求，例如：

```text
/superpowers-feature
请基于现有 repo memory 和当前项目状态继续推进 hobby-map。
```

如果你只是想让 Claude Code 在新会话里读取项目记忆，而不是启用某个 workflow bundle，那么普通新会话也可以；这里推荐 slash command，主要是为了更稳定地启用 workflow。

### 推荐的收尾习惯

做完一轮有意义的工作后，建议顺手做这几件事：

1. 如果当前工作重点变了，更新 `CURRENT_STATE.md`
2. 如果出现了长期有效的决策、坑点、验证规则，更新对应 durable memory 文件
3. 在 `session-journal/` 下补一条简短记录
4. 运行校验

```powershell
.\scripts\validate-superpowers-memory.ps1 -ProjectRoot <project-root>
```

如果你不想手动分开做，也可以直接运行：

```powershell
.\scripts\run-superpowers-memory-closeout.ps1 -ProjectRoot <project-root> -ChangedPaths "src","docs" -Signals "decision","validation" -RunValidator
```

## 如何关闭

你也可以分两层关闭。

### 方式 1：停止使用记忆目录

如果项目里没有 `.superpowers-memory/`，workflow 就应当跳过记忆逻辑。

所以最直接的关闭方式是移除或重命名：

```text
.superpowers-memory/
```

### 方式 2：移除项目级工具集成

如果你不想让 Codex、Cursor 或 Claude Code 从项目指令里自动读记忆，可以移除安装过的集成：

- 删除 `AGENTS.md` 里的 `superpowers-memory` 管理块
- 删除 `.cursor/rules/superpowers-memory.mdc`
- 删除 `CLAUDE.md` 里的 `superpowers-memory` 管理块

### 临时关闭

你也可以保留仓库里的记忆文件，但在当前任务中明确告诉工具不要依赖记忆。

## 如何验证

安装后，可按下面方式验证：

### 记忆脚手架

```powershell
Test-Path "<project-root>\\.superpowers-memory\\PROJECT_CONTEXT.md"
Test-Path "<project-root>\\.superpowers-memory\\CURRENT_STATE.md"
Test-Path "<project-root>\\.superpowers-memory\\session-journal"
Test-Path "<project-root>\\.superpowers-memory\\USER_PROFILE.md"
Test-Path "<project-root>\\.superpowers-memory\\AGENT_NOTES.md"
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

### 记忆检索

```powershell
.\scripts\search-superpowers-memory.ps1 -ProjectRoot <project-root> -Query "validator" -Type decisions
```

### 记忆更新建议

```powershell
.\scripts\suggest-superpowers-memory-updates.ps1 -ProjectRoot <project-root> -ChangedPaths "scripts/validate-superpowers-memory.ps1","docs/memory-enhancement-design.cn.md" -Signals "decision","validation","reusable"
```

### 记忆收尾助手

```powershell
.\scripts\run-superpowers-memory-closeout.ps1 -ProjectRoot <project-root> -ChangedPaths "scripts/validate-superpowers-memory.ps1","docs/memory-learning-dialogue.cn.md" -Signals "decision","validation","reusable" -RunValidator
```

## 最适合什么场景

这套记忆模型最适合下面这些情况：

- 项目会在几天到几周内持续协作
- 团队希望 AI 记住架构、近期决策和失败经验
- 团队希望记忆保存在仓库里，而不是依赖私有外部系统
- 团队希望长期经验最终演化成显式可复用资产

它是刻意做得比较轻量的，不追求变成完整任务系统，也不做隐藏的私有记忆服务。
