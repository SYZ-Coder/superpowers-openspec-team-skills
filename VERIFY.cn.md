# 验证已安装的 Bundle

这份文档说明如何验证 bundle 是否真的安装成功，以及它是否真的影响了工具行为。

验证应该分两层：

1. 安装验证：预期文件是否落到了预期位置
2. 运行验证：工具是否真的加载了 workflow，并按预期行为执行

本文中的 `<repo-root>` 指的是这个仓库在你机器上的实际路径。

## macOS / Linux 快速检查

如果你是在 macOS / Linux 上验证 shell 安装脚本，建议先按下面顺序做：

1. 确认脚本存在：
   `ls "<repo-root>/scripts/install-codex.sh"`
2. 用绝对路径先跑一次 dry run：
   `sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --dry-run`
3. 对依赖 OpenSpec 的 bundle 先检查依赖：
   `sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --check-dependencies`
4. 正式安装：
   `sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex"`
5. 检查目标文件：
   `test -f "$HOME/.codex/skills/openspec-superpowers-workflow/SKILL.md" && echo OK`

其他工具也可按同样思路验证：

- Cursor：
  `sh "<repo-root>/scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root> --dry-run`
- Claude Code：
  `sh "<repo-root>/scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --dry-run`
- 记忆骨架：
  `sh "<repo-root>/scripts/install-superpowers-memory.sh" --project-root <project-root> --dry-run`
- 记忆集成：
  `sh "<repo-root>/scripts/install-superpowers-memory-integration.sh" --tool all --project-root <project-root> --dry-run`

## 1. 验证记忆骨架

安装：

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot <project-root>
```

检查增强后的记忆骨架：

```powershell
Test-Path "<project-root>\\.superpowers-memory\\PROJECT_CONTEXT.md"
Test-Path "<project-root>\\.superpowers-memory\\CURRENT_STATE.md"
Test-Path "<project-root>\\.superpowers-memory\\DECISIONS.md"
Test-Path "<project-root>\\.superpowers-memory\\KNOWN_FAILURES.md"
Test-Path "<project-root>\\.superpowers-memory\\VERIFICATION_BASELINE.md"
Test-Path "<project-root>\\.superpowers-memory\\TEAM_PREFERENCES.md"
Test-Path "<project-root>\\.superpowers-memory\\LEARNING_BACKLOG.md"
Test-Path "<project-root>\\.superpowers-memory\\memory-index.yaml"
Test-Path "<project-root>\\.superpowers-memory\\session-journal"
```

然后运行记忆校验：

```powershell
.\scripts\validate-superpowers-memory.ps1 -ProjectRoot <project-root>
```

预期行为：

- 对一个刚安装的 scaffold，脚本不应报 error
- 如果项目还没有真实 journal 历史，出现少量 warning 是合理的
- 输出应该能清楚指出缺失项或过期项

## 2. 验证记忆集成

安装：

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool all -ProjectRoot <project-root>
```

检查：

```powershell
Select-String -Path "<project-root>\\AGENTS.md" -Pattern "superpowers-memory:start"
Test-Path "<project-root>\\.cursor\\rules\\superpowers-memory.mdc"
Select-String -Path "<project-root>\\CLAUDE.md" -Pattern "superpowers-memory:start"
```

预期行为：

- Codex 项目指令里出现托管记忆块
- Cursor 出现专用记忆规则文件
- Claude Code 项目指令里出现托管记忆块

## 3. Codex

### 第一步：检查依赖

```powershell
.\scripts\install-codex.ps1 -Bundle superpowers-openspec-execution -CheckDependencies
```

### 第二步：安装 bundle

```powershell
.\scripts\install-codex.ps1 -Bundle superpowers-openspec-execution
```

### 第三步：检查安装结果

```powershell
Test-Path "$env:USERPROFILE\.codex\skills\superpowers-openspec-execution-workflow\SKILL.md"
```

如果还安装了 Codex 的记忆集成，也检查：

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
- 会先探索需求
- 会先进入 OpenSpec 阶段，再进入实现阶段
- 在启用记忆时，会先读取仓库记忆再提问重复背景

### 也验证 `superpowers-learning`

调用：

```text
Use $superpowers-learning-workflow to capture what this session taught us and update the project memory.
```

预期行为：

- Codex 会先反思最近工作，而不是继续实现
- 在启用记忆时，会更新正确的记忆文件
- 会给出 backlog 晋升建议
- 如果更新了记忆，会运行记忆校验

## 4. Cursor

### 第一步：检查依赖

```powershell
.\scripts\install-cursor.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root> -CheckDependencies
```

### 第二步：安装 bundle

```powershell
.\scripts\install-cursor.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

### 第三步：检查安装结果

```powershell
Test-Path "<project-root>\.cursor\rules\superpowers-openspec-execution-workflow.mdc"
Test-Path "<project-root>\AGENTS.md"
```

如果还安装了 Cursor 的记忆集成，也检查：

```powershell
Test-Path "<project-root>\.cursor\rules\superpowers-memory.mdc"
```

### 第四步：重新打开项目

Cursor 应重新加载项目规则。

### 第五步：验证运行行为

在 Cursor 中发送：

```text
Use the superpowers-openspec-execution workflow for this feature: first explore, then lock OpenSpec, then implement and verify, then archive the change.
```

预期行为：

- 智能体呈现出明显的分阶段 workflow
- 不会跳过探索和规范阶段直接实现
- 在启用记忆时，会先读取正确的记忆文件再追问背景

### 也验证 `superpowers-learning`

调用：

```text
Use the superpowers-learning workflow to capture what this session taught us and update the project memory.
```

预期行为：

- Cursor 会进入反思整理，而不是继续实现
- 在启用记忆时，会把学习结果写回扩展后的 `.superpowers-memory/`
- 会把长期事实和临时记录分开
- 如果更新了记忆，会运行记忆校验

## 5. Claude Code

### 第一步：检查依赖

```powershell
.\scripts\install-claude-code.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root> -CheckDependencies
```

### 第二步：安装 bundle

```powershell
.\scripts\install-claude-code.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

### 第三步：检查安装结果

```powershell
Test-Path "<project-root>\.claude\commands\superpowers-openspec-execution-workflow.md"
Test-Path "<project-root>\CLAUDE.md"
```

如果还安装了 Claude Code 的记忆集成，也检查：

```powershell
Select-String -Path "<project-root>\CLAUDE.md" -Pattern "superpowers-memory:start"
```

### 第四步：重新打开项目

Claude Code 应重新加载命令和项目说明。

### 第五步：验证运行行为

调用：

```text
/superpowers-openspec-execution-workflow
```

然后继续描述你的功能需求。

预期行为：

- 命令可用
- Claude Code 会按分阶段流程工作，而不是直接进入实现
- 在启用记忆时，会先读取仓库记忆再重复发现背景

### 也验证 `superpowers-learning`

调用：

```text
/superpowers-learning-workflow
```

预期行为：

- 命令可用
- Claude Code 会先反思最近工作，而不是重新开始实现
- 在启用记忆时，会更新扩展后的记忆结构
- 如果更新了记忆，会运行记忆校验

## 6. 什么才算真的生效

不能只看文件是否存在。

真正算生效，应该同时满足：

- 工具已识别安装的 bundle
- 工具行为明显受 workflow 影响
- 工具遵循设计、规范、验证和记忆这些门槛

如果文件在，但行为没变，那只是安装成功，不代表运行时真的启用了 workflow。

## 7. 验证默认不会自动启用

安装完成后，还要再验证反向场景：如果用户没有明确调用 workflow，它应该保持不启用。

### Codex

发送普通请求：

```text
Implement this small feature and keep the change minimal.
```

预期行为：

- Codex 按正常方式响应
- 不会自动宣布或假定进入 Superpowers / OpenSpec workflow
- 不会在用户没有明确要求时强行进入分阶段流程

### Cursor

发送普通请求：

```text
Please help implement this small change.
```

预期行为：

- Cursor 应表现得像普通编码助手
- 不应自动切换到已安装 workflow

### Claude Code

安装完成后打开项目，但不要调用任何 workflow 命令，然后发送：

```text
Help me make this small change.
```

预期行为：

- Claude Code 保持正常行为
- 不应像 `/superpowers-openspec-execution-workflow` 已被调用一样工作

## 8. 推荐验证顺序

对任何工具，都建议按这个顺序检查：

1. 先运行 `-CheckDependencies`
2. 安装 bundle 或记忆骨架
3. 检查目标文件是否存在
4. 重启或刷新工具
5. 发起一次明确的 workflow 调用
6. 如果启用了记忆，再运行 `validate-superpowers-memory.ps1`
7. 观察工具行为是否符合 workflow 分阶段要求
8. 再发一次不点名 workflow 的普通请求
9. 确认 workflow 不会自动启用
