# 验证已安装的 Bundle

这份文档说明如何验证 bundle 是否真的安装成功，以及它是否真的影响了工具行为。

验证分两层：

1. 安装验证：文件是否落到了预期位置
2. 运行验证：工具是否真的加载了 workflow，并按预期行为执行

本文里的 `<repo-root>`，指的是这个仓库在你本机上的实际路径。

例如：

```bash
sh "/Users/alex/projects/superpowers-openspec-team-skills/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --dry-run
```

在执行本文中的脚本前，请先确认：

- 你已经切换到了仓库根目录，或者
- 你使用的是脚本的绝对路径

## macOS / Linux 快速验证清单

如果你是在 macOS / Linux 上验证 shell 安装脚本，建议先按这组最短路径检查：

1. 先确认脚本文件存在：
   `ls "<repo-root>/scripts/install-codex.sh"`
2. 用绝对路径先跑一次 dry run：
   `sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --dry-run`
3. 对依赖 OpenSpec 的 bundle，安装前先检查依赖：
   `sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --check-dependencies`
4. 正式安装：
   `sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex"`
5. 检查目标文件是否存在：
   `test -f "$HOME/.codex/skills/openspec-superpowers-workflow/SKILL.md" && echo OK`

其他工具也按同样思路验证：

- Cursor：
  `sh "<repo-root>/scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root> --dry-run`
- Claude Code：
  `sh "<repo-root>/scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --dry-run`
- 记忆骨架：
  `sh "<repo-root>/scripts/install-superpowers-memory.sh" --project-root <project-root> --dry-run`
- 记忆集成：
  `sh "<repo-root>/scripts/install-superpowers-memory-integration.sh" --tool all --project-root <project-root> --dry-run`

## 1. Codex

### 第一步：检查运行时依赖

对于依赖 OpenSpec 的 bundle，先执行：

```powershell
.\scripts\install-codex.ps1 -Bundle superpowers-openspec-execution -CheckDependencies
```

如果提示缺少 `openspec-cli`，说明 bundle 可以安装，但流程可能无法完整运行。

### 第二步：安装 bundle

```powershell
.\scripts\install-codex.ps1 -Bundle superpowers-openspec-execution
```

### 第三步：检查安装文件

```powershell
Test-Path "$env:USERPROFILE\.codex\skills\superpowers-openspec-execution-workflow\SKILL.md"
```

预期结果：

```text
True
```

如果你还安装了 Codex 的 Superpowers 记忆集成，也额外检查：

```powershell
Select-String -Path "<project-root>\AGENTS.md" -Pattern "superpowers-memory:start"
```

### 第四步：重启或刷新 Codex

Codex 需要重新发现刚安装的 skill。

### 第五步：验证运行行为

在 Codex 中发送：

```text
Use $superpowers-openspec-execution-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```

预期行为：

- 不会一上来直接写代码
- 会先探索需求和上下文
- 会先澄清范围或确认方案
- 会先进入 OpenSpec 阶段，再进入实现阶段
- 最后回到实现、验证和归档

如果它还是直接开始写生产代码，说明 workflow 没有真正生效。

### 也验证一下 `superpowers-learning`

安装：

```powershell
.\scripts\install-codex.ps1 -Bundle superpowers-learning
```

检查：

```powershell
Test-Path "$env:USERPROFILE\.codex\skills\superpowers-learning-workflow\SKILL.md"
```

然后调用：

```text
Use $superpowers-learning-workflow to capture what this session taught us and update the project memory.
```

预期行为：

- Codex 会先回顾最近工作，而不是重新开始实现
- 会把稳定事实、当前状态和会话记录分开处理
- 在启用记忆时，会更新 `.superpowers-memory/`
- 不会在用户没有明确要求时直接修改技能库

## 2. Cursor

### 第一步：检查运行时依赖

```powershell
.\scripts\install-cursor.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root> -CheckDependencies
```

### 第二步：安装 bundle

```powershell
.\scripts\install-cursor.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

### 第三步：检查安装文件

```powershell
Test-Path "<project-root>\.cursor\rules\superpowers-openspec-execution-workflow.mdc"
Test-Path "<project-root>\AGENTS.md"
```

预期结果：

```text
True
True
```

如果你还安装了 Cursor 的 Superpowers 记忆集成，也额外检查：

```powershell
Test-Path "<project-root>\.cursor\rules\superpowers-memory.mdc"
```

### 第四步：重新打开项目

让 Cursor 重新加载项目规则文件。

### 第五步：验证运行行为

在 Cursor 中发送类似请求：

```text
Use the superpowers-openspec-execution workflow for this feature: first explore, then lock OpenSpec, then implement and verify, then archive the change.
```

预期行为：

- 智能体表现出明显的分阶段流程
- 不会跳过探索和规范阶段直接进入实现
- 会把设计和 OpenSpec 产物当成明确步骤处理

### 也验证一下 `superpowers-learning`

安装：

```powershell
.\scripts\install-cursor.ps1 -Bundle superpowers-learning -ProjectRoot <project-root>
```

检查：

```powershell
Test-Path "<project-root>\.cursor\rules\superpowers-learning-workflow.mdc"
Test-Path "<project-root>\AGENTS.md"
```

然后调用：

```text
Use the superpowers-learning workflow to capture what this session taught us and update the project memory.
```

预期行为：

- Cursor 会进入反思整理，而不是继续实现
- 在启用记忆时，会把学习结果写回 `.superpowers-memory/`
- 会把稳定事实和临时记录分开

## 3. Claude Code

### 第一步：检查运行时依赖

```powershell
.\scripts\install-claude-code.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root> -CheckDependencies
```

### 第二步：安装 bundle

```powershell
.\scripts\install-claude-code.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

### 第三步：检查安装文件

```powershell
Test-Path "<project-root>\.claude\commands\superpowers-openspec-execution-workflow.md"
Test-Path "<project-root>\CLAUDE.md"
```

预期结果：

```text
True
True
```

如果你还安装了 Claude Code 的 Superpowers 记忆集成，也额外检查：

```powershell
Select-String -Path "<project-root>\CLAUDE.md" -Pattern "superpowers-memory:start"
```

### 第四步：重新打开项目

让 Claude Code 重新加载命令和项目说明文件。

### 第五步：验证运行行为

调用：

```text
/superpowers-openspec-execution-workflow
```

然后继续描述你的功能需求。

预期行为：

- 该命令可用
- Claude Code 会按分阶段流程工作，而不是直接进入实现

### 也验证一下 `superpowers-learning`

安装：

```powershell
.\scripts\install-claude-code.ps1 -Bundle superpowers-learning -ProjectRoot <project-root>
```

检查：

```powershell
Test-Path "<project-root>\.claude\commands\superpowers-learning-workflow.md"
Test-Path "<project-root>\CLAUDE.md"
```

然后调用：

```text
/superpowers-learning-workflow
```

预期行为：

- 该命令可用
- Claude Code 会先回顾最近工作，而不是重新开始实现
- 在启用记忆时，会更新 `.superpowers-memory/`

## 4. 什么才算“真的生效”

不能只看文件是否存在。

真正算生效，应该同时满足：

- 工具已经识别了安装的 bundle
- 工具的行为明显受 workflow 影响
- 工具遵循设计、规范、验证这些门禁

如果文件在，但行为没变，那只是安装成功了，不代表运行时真的启用了这个 workflow。

## 5. 验证“默认不会自动启用”

安装完成后，还要再验证反向场景：如果用户没有明确调用 workflow，它应该保持不启用。

### Codex

发一个普通的编码请求，不要点名任何 workflow，例如：

```text
Implement this small feature and keep the change minimal.
```

预期行为：

- Codex 按正常方式响应
- 不会自动宣布或默认进入 Superpowers / OpenSpec workflow
- 不会在用户没有明确要求时强行进入分阶段流程

### Cursor

发一个普通请求，不要点名 workflow：

```text
Please help implement this small change.
```

预期行为：

- Cursor 应该像普通编码助手一样工作
- 不应该自动切换到已安装的 workflow

### Claude Code

安装完成后，打开项目，但不要调用任何 workflow 命令。

然后发送一个普通请求，例如：

```text
Help me make this small change.
```

预期行为：

- Claude Code 应该保持正常行为
- 不应该像 `/superpowers-openspec-execution-workflow` 已经被调用了一样工作

如果工具在你没有明确要求的情况下，仍然表现得像 workflow 已经启用，那就说明“显式启用”规则还没有真正生效。

## 6. 推荐验证顺序

对任何工具，都推荐按这个顺序检查：

1. 先运行 `-CheckDependencies`
2. 安装 bundle
3. 检查目标文件是否存在
4. 重启或刷新工具
5. 发起一次明确的 workflow 调用
6. 如果需要，再在重要任务结束后发起一次明确的 `superpowers-learning` 调用
7. 观察工具行为是否符合 workflow 分阶段要求
8. 再发一次不点名 workflow 的普通请求
9. 确认 workflow 不会自动启用
