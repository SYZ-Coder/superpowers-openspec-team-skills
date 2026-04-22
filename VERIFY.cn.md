# 验证已安装的 Bundle

这份文档说明如何验证某个 bundle 是否真的安装成功，以及它是否真的影响了工具行为。

如果你只想快速查看 Windows / Linux / macOS 的脚本验证矩阵，请先看 [docs/CROSS_PLATFORM_TESTING.cn.md](/D:/spring_AI/superpowers-openspec-team-skills/docs/CROSS_PLATFORM_TESTING.cn.md)。

验证应分成两层：

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
5. 检查目标文件是否存在：  
   `test -f "$HOME/.codex/skills/openspec-superpowers-workflow/SKILL.md" && echo OK`

其他工具也可以按同样思路验证：

- Cursor：  
  `sh "<repo-root>/scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root> --dry-run`
- Claude Code：  
  `sh "<repo-root>/scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --dry-run`
- 记忆脚手架：  
  `sh "<repo-root>/scripts/install-superpowers-memory.sh" --project-root <project-root> --dry-run`
- 记忆集成：  
  `sh "<repo-root>/scripts/install-superpowers-memory-integration.sh" --tool all --project-root <project-root> --dry-run`

## 1. 验证记忆脚手架

安装：

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot <project-root>
```

检查增强后的记忆结构：

```powershell
Test-Path "<project-root>\\.superpowers-memory\\PROJECT_CONTEXT.md"
Test-Path "<project-root>\\.superpowers-memory\\CURRENT_STATE.md"
Test-Path "<project-root>\\.superpowers-memory\\DECISIONS.md"
Test-Path "<project-root>\\.superpowers-memory\\KNOWN_FAILURES.md"
Test-Path "<project-root>\\.superpowers-memory\\VERIFICATION_BASELINE.md"
Test-Path "<project-root>\\.superpowers-memory\\TEAM_PREFERENCES.md"
Test-Path "<project-root>\\.superpowers-memory\\USER_PROFILE.md"
Test-Path "<project-root>\\.superpowers-memory\\AGENT_NOTES.md"
Test-Path "<project-root>\\.superpowers-memory\\LEARNING_BACKLOG.md"
Test-Path "<project-root>\\.superpowers-memory\\SESSION_CLOSE_CHECKLIST.md"
Test-Path "<project-root>\\.superpowers-memory\\memory-index.yaml"
Test-Path "<project-root>\\.superpowers-memory\\session-journal"
```

预期结果：

```text
True
True
True
True
True
True
True
True
True
True
True
True
```

然后运行记忆校验：

```powershell
.\scripts\validate-superpowers-memory.ps1 -ProjectRoot <project-root>
```

macOS / Linux 原生 shell 方式：

```bash
sh "<repo-root>/scripts/validate-superpowers-memory.sh" --project-root <project-root>
```

预期行为：

- 对一个刚安装的 scaffold，脚本不应报 error
- 如果项目还没有真实 journal 历史，少量 warning 是合理的
- 输出应能清楚指出缺失项或过期项
- `memory-index.yaml` 会被刷新为当前健康摘要
- durable entry 会检查 `id`、`source`、`review_after` 以及是否已过复查时间

跨平台校验命令：

- Windows PowerShell：  
  `.\scripts\validate-superpowers-memory.ps1 -ProjectRoot <project-root>`
- Linux 或 macOS：  
  `sh "<repo-root>/scripts/validate-superpowers-memory.sh" --project-root <project-root>`
- 只做检查、不回写索引时：  
  `sh "<repo-root>/scripts/validate-superpowers-memory.sh" --project-root <project-root> --skip-index-write`

跨平台说明：

- shell 脚本是原生 `sh` 实现，不依赖 `pwsh`
- 文件时间戳同时兼容 GNU `stat -c` 和 BSD `stat -f`
- 日期解析兼容 GNU `date -d` 与 BSD `date -j` / `date -v`
- 建议在真实 macOS / Linux 机器，或 Windows 下的 POSIX 兼容 shell 中执行 shell 脚本

如果要验证晋升草案生成，可以先在 `LEARNING_BACKLOG.md` 里添加一个候选，并满足：

- `status: ready_for_promotion`
- `suggested_artifact: checklist` 或 `rule` 或 `skill draft`

然后运行：

```powershell
.\scripts\generate-superpowers-promotion-drafts.ps1 -ProjectRoot <project-root>
```

macOS / Linux 原生 shell 方式：

```bash
sh "<repo-root>/scripts/generate-superpowers-promotion-drafts.sh" --project-root <project-root>
```

预期行为：

- `.superpowers-memory/promotion-drafts/` 下会出现对应草案文件
- 如果草案已存在，默认不会覆盖，除非加 `-Force`

跨平台草案生成命令：

- Windows PowerShell：  
  `.\scripts\generate-superpowers-promotion-drafts.ps1 -ProjectRoot <project-root>`
- Linux 或 macOS：  
  `sh "<repo-root>/scripts/generate-superpowers-promotion-drafts.sh" --project-root <project-root>`
- 如需覆盖已有草案：  
  `sh "<repo-root>/scripts/generate-superpowers-promotion-drafts.sh" --project-root <project-root> --force`

如需验证本地记忆检索，可运行：

```powershell
.\scripts\search-superpowers-memory.ps1 -ProjectRoot <project-root> -Query "decision" -Type decisions
```

macOS / Linux 原生 shell 方式：

```bash
sh "<repo-root>/scripts/search-superpowers-memory.sh" --project-root <project-root> --query "decision" --type decisions
```

预期行为：

- 会列出命中的条目和文件路径
- `--type` 可以缩小到某一类记忆面
- `--status` 可以进一步筛选 decisions、backlog 这类 entry 型文件
- `-RecentFirst` 可以让结果更偏最近更新的 durable entry 或 journal
- `-SinceDays` 可以把结果限制在最近的时间窗口内
- `-Summary` 可以在详细结果前先输出按 kind / status 汇总的简要视图

如需验证记忆更新建议脚本，可运行：

```powershell
.\scripts\suggest-superpowers-memory-updates.ps1 -ProjectRoot <project-root> -ChangedPaths "scripts/validate-superpowers-memory.ps1","docs/memory-enhancement-design.cn.md" -Signals "decision","validation","reusable"
```

macOS / Linux 原生 shell 方式：

```bash
sh "<repo-root>/scripts/suggest-superpowers-memory-updates.sh" --project-root <project-root> --changed-paths "scripts/validate-superpowers-memory.sh,docs/memory-enhancement-design.cn.md" --signals "decision,validation,reusable"
```

预期行为：

- 建议结果会包含 `CURRENT_STATE.md` 和 `session-journal/`
- 当信号明确时，会附带 `DECISIONS.md`、`VERIFICATION_BASELINE.md`、`LEARNING_BACKLOG.md` 等目标
- 它只是收尾提示脚本，不会自动写记忆文件

如需验证记忆收尾助手，可运行：

```powershell
.\scripts\run-superpowers-memory-closeout.ps1 -ProjectRoot <project-root> -ChangedPaths "scripts/validate-superpowers-memory.ps1","docs/memory-learning-dialogue.cn.md" -Signals "decision","validation","reusable" -RunValidator
```

macOS / Linux 原生 shell 方式：

```bash
sh "<repo-root>/scripts/run-superpowers-memory-closeout.sh" --project-root <project-root> --changed-paths "scripts/validate-superpowers-memory.sh,docs/memory-learning-dialogue.cn.md" --signals "decision,validation,reusable" --run-validator
```

预期行为：

- 先显示 checklist 路径
- 再显示 memory update suggestion
- 如果要求校验，会继续输出 validator 结果
- 结尾会输出一段 closeout summary
- 它只是把收尾动作串起来，不会自动改写记忆文件

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

对依赖 OpenSpec 的 bundle，运行：

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

安装：

```powershell
.\scripts\install-codex.ps1 -Bundle superpowers-learning
```

然后调用：

```text
Use $superpowers-learning-workflow to capture what this session taught us and update the project memory.
```

预期行为：

- Codex 会先反思最近工作，而不是开始新实现
- 在启用记忆时，会更新正确的记忆面
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

- 智能体呈现出明确的分阶段 workflow
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
- 在启用记忆时，会先读取仓库记忆再做重复背景发现

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

## 6. 什么才算真正生效

不能只看文件是否存在。

真正算生效，应同时满足：

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
2. 安装 bundle 或记忆脚手架
3. 检查目标文件是否存在
4. 重启或刷新工具
5. 发起一次明确的 workflow 调用
6. 如果启用了记忆，再运行 `validate-superpowers-memory.ps1`
7. 观察工具行为是否符合 workflow 分阶段要求
8. 再发一次不点名 workflow 的普通请求
9. 确认 workflow 不会自动启用
