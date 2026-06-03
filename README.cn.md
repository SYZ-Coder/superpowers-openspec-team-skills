# Superpowers + OpenSpec Team Skills

这是一套面向 AI 编程助手的带有记忆和自主学工作流技能库，目标很直接：让智能体按流程做事，而不是一上来就直接写代码。用户可以按需组合Superpowers + OpenSpec使用

现在仓库分成两层：

- `team-skills/`：项目维护的源码级 workflow 定义
- `dist/`：面向具体工具的可安装 bundle

如果你是使用者，请优先使用 `dist/` 和 `scripts/`。不要再像以前那样，直接从 `team-skills/` 里复制单个入口 workflow 到目标工具目录，否则很容易因为依赖不完整而无法使用。

`team-skills/` 下的源码 workflow 和 `dist/` 下的工具分发 bundle，在写法和结构上可以不同，但功能上应该保持一致。前者面向维护者，后者面向具体工具运行时。

重要说明：这些 workflow 都是“显式启用型”流程，不应该变成 AI 工具的默认后台行为。只有当用户明确要求、明确点名某个 workflow，或者仓库策略明确要求时，才应该启用。

如果你希望 Codex 默认忽略这些 workflow，那就只安装 bundle，但只有在对话中明确点名 workflow 时才调用它。

例如：

```text
Use $superpowers-openspec-execution-workflow for this feature.
```

## 开始前先看

### 这套技能库的价值

这个仓库适合希望 AI 编程工具别一上来就直接写代码，而是按更稳的交付路径做事的团队：

- 先澄清，再实现
- 先确认行为，再改动代码
- 实现时带上测试和验证
- 完成后有清晰的归档收尾
- 把项目上下文持续记在仓库里，让新会话不是从空白开始

### 项目记忆

这个仓库现在额外支持一套可选的、持久化到仓库里的 Superpowers 记忆模式。

当目标项目中存在 `.superpowers-memory/` 时，Superpowers workflow 应该：

- 先读取 `PROJECT_CONTEXT.md`，了解稳定的项目背景
- 读取 `CURRENT_STATE.md`，了解当前工作状态
- 阅读 `session-journal/` 里的最近记录
- 在会话结束前更新 `CURRENT_STATE.md`，并补一条新的 session journal

这样不用单独部署记忆服务，也能让 AI 在跨会话时接上之前的上下文。

默认推荐用法很简单：让工具在新会话开始时先读取 repo memory，平时至少保持 `PROJECT_CONTEXT.md` 和 `CURRENT_STATE.md` 基本可用、基本最新；做完一轮有意义的工作后，用 `superpowers-learning` 作为默认记忆收尾入口。不要期待普通聊天自动把内容写回 memory 文件；如果想更轻量一点，可以改用 `scripts/run-superpowers-memory-closeout.ps1`。

### 运行要求

- 使用 OpenSpec 相关 workflow 时，需要安装 OpenSpec CLI
- 需要一个实际项目仓库来保存设计文档、计划、OpenSpec change、代码、测试和验证结果
- 如果想启用跨会话记忆，目标项目里还需要有 `.superpowers-memory/` 目录

### 推荐入口

- `openspec-superpowers`：完整功能交付流程
- `superpowers-openspec-execution`：先 Superpowers 探索，再 OpenSpec 固化，再回到 Superpowers 实现验证，最后归档 OpenSpec change
- `superpowers-feature`：不生成 OpenSpec 产物，只做设计、计划、TDD、验证
- `superpowers-learning`：在重要工作结束后沉淀项目记忆、会话结论和可复用经验
- `openspec-feature`：只做 OpenSpec proposal、design、specs、tasks

### 怎么选择

- `openspec-superpowers`：适合想要一个从需求澄清一路带到实现验证的统一入口，不想自己判断每一步先后顺序的场景。
- `superpowers-openspec-execution`：适合已经明确要按四步走的场景，也就是先 Superpowers 探索，再 OpenSpec 固化，再回到 Superpowers 执行实现验证，最后归档 OpenSpec change。
- `superpowers-feature`：适合只想使用 Superpowers 的设计、计划、TDD、验证纪律，不需要 OpenSpec change 产物的场景。
- `superpowers-learning`：适合重要工作结束后，把经验沉淀到仓库记忆里，并整理出后续可复用方法的场景。
- `openspec-feature`：适合只想先把 OpenSpec proposal、design、specs、tasks 补齐，再决定后续实现怎么推进的场景。

### 推荐收尾方式

对于持续协作的项目，比较推荐这样串起来：

1. 先用一个交付型 workflow
2. 完成实现和验证
3. 再用 `superpowers-learning` 保存稳定经验和当前状态

## 包含内容

源码层 workflow：

- [OpenSpec + Superpowers Workflow](team-skills/openspec-superpowers-workflow/readme_cn.md)
- [Superpowers -> OpenSpec -> Superpowers Workflow](team-skills/superpowers-openspec-execution-workflow/readme_cn.md)
- [Superpowers Feature Workflow](team-skills/superpowers-feature-workflow/readme_cn.md)
- [Superpowers Learning Workflow](team-skills/superpowers-learning-workflow/readme_cn.md)
- [OpenSpec Feature Workflow](team-skills/openspec-feature-workflow/readme_cn.md)

每个源码 workflow 现在都额外带有一个 `workflow.yaml`，用于描述依赖、支持的工具和运行要求。

## 仓库结构

```text
team-skills/   workflow 源定义
dist/          面向具体工具的分发包
scripts/       安装脚本
```

## 快速开始

本文里的 `<repo-root>`，指的是你把这个仓库 clone 下来或解压之后，它在你本机上的实际路径。

例如：

- macOS：`/Users/alex/projects/superpowers-openspec-team-skills`
- Linux：`/home/alex/projects/superpowers-openspec-team-skills`
- Windows：`D:\projects\superpowers-openspec-team-skills`

所以这条命令：

```bash
sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex"
```

实际可以写成：

```bash
sh "/Users/alex/projects/superpowers-openspec-team-skills/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex"
```

在运行安装脚本前，请先满足下面两种方式之一：

- 先切换到仓库根目录再执行
- 或者直接使用脚本的绝对路径执行

Windows PowerShell：

```powershell
cd <repo-root>
.\scripts\install-codex.ps1 -Bundle openspec-superpowers
```

Windows PowerShell 绝对路径方式：

```powershell
& "<repo-root>\scripts\install-codex.ps1" -Bundle openspec-superpowers
```

macOS / Linux 原生 shell 方式：

```bash
cd <repo-root>
sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex"
```

如果系统里已经安装了 PowerShell 7（`pwsh`），也可以直接运行脚本：

```bash
cd <repo-root>
pwsh -File ./scripts/install-codex.ps1 -Bundle openspec-superpowers -CodexHome "$HOME/.codex"
```

### Shell 安装脚本参数

原生 shell 安装脚本支持这些参数：

- `--bundle <name>`：选择要安装的 bundle
- `--project-root <path>`：为 Cursor、Claude Code 或记忆安装指定目标项目根目录
- `--codex-home <path>`：为 Codex 安装指定 Codex home 目录
- `--dry-run`：只预览将写入什么，不实际复制
- `--backup`：覆盖前先备份目标文件
- `--force`：跳过覆盖确认
- `--check-dependencies`：只检查运行时依赖，例如 `openspec`，不安装文件

当前可用的 shell 安装脚本：

- `scripts/install-codex.sh`
- `scripts/install-cursor.sh`
- `scripts/install-claude-code.sh`
- `scripts/install-superpowers-memory.sh`
- `scripts/install-superpowers-memory-integration.sh`

如果你还想给目标项目安装 Superpowers 记忆骨架，可以运行：

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot <project-root>
```

macOS / Linux 原生 shell 方式：

```bash
sh "<repo-root>/scripts/install-superpowers-memory.sh" --project-root <project-root>
```

如果系统里已经安装了 PowerShell 7（`pwsh`），也可以直接运行脚本：

```bash
pwsh -File ./scripts/install-superpowers-memory.ps1 -ProjectRoot <project-root>
```

如果你还想把这套记忆接到 Codex、Cursor、Claude Code 的项目级指令里，可以继续运行：

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool all -ProjectRoot <project-root>
```

macOS / Linux 原生 shell 方式：

```bash
sh "<repo-root>/scripts/install-superpowers-memory-integration.sh" --tool all --project-root <project-root>
```

如果系统里已经安装了 PowerShell 7（`pwsh`），也可以直接运行脚本：

```bash
pwsh -File ./scripts/install-superpowers-memory-integration.ps1 -Tool all -ProjectRoot <project-root>
```

安装完成后，记得重开或刷新项目，再新开一个会话，让工具先读取 repo memory；一轮有意义的工作结束后，优先用 `superpowers-learning` 来沉淀当前状态和可复用经验。

### Codex

不要再手动复制源码 workflow，直接安装 Codex bundle。

PowerShell：

```powershell
.\scripts\install-codex.ps1 -Bundle openspec-superpowers
```

macOS / Linux 原生 shell 方式：

```bash
sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex"
```

macOS / Linux 使用 `pwsh`：

```bash
pwsh -File ./scripts/install-codex.ps1 -Bundle openspec-superpowers -CodexHome "$HOME/.codex"
```

常用参数：

```powershell
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -DryRun
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -Backup
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -Backup -Force
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -CheckDependencies
```

macOS / Linux 原生 shell 示例：

```bash
sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --dry-run
sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --backup
sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --backup --force
sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --check-dependencies
```

macOS / Linux `pwsh` 示例：

```bash
pwsh -File ./scripts/install-codex.ps1 -Bundle openspec-superpowers -CodexHome "$HOME/.codex" -DryRun
pwsh -File ./scripts/install-codex.ps1 -Bundle openspec-superpowers -CodexHome "$HOME/.codex" -Backup
pwsh -File ./scripts/install-codex.ps1 -Bundle openspec-superpowers -CodexHome "$HOME/.codex" -Backup -Force
pwsh -File ./scripts/install-codex.ps1 -Bundle openspec-superpowers -CodexHome "$HOME/.codex" -CheckDependencies
```

- `-DryRun`：只预览将安装什么，不实际复制
- `-Backup`：覆盖前先备份同名 skill 目录
- `-Force`：跳过覆盖确认
- `-CheckDependencies`：只检查运行时依赖，例如 `openspec`，不安装文件

然后重启或刷新 Codex，再调用：

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

如果用户没有明确要求某个 workflow，Codex 应该保持正常默认行为，而不是自动假设要使用 Superpowers 或 OpenSpec 流程。

当前可用的 Codex bundle：

- `openspec-superpowers`
- `superpowers-openspec-execution`
- `superpowers-feature`
- `superpowers-learning`
- `openspec-feature`

### Cursor

将 Cursor bundle 安装到目标项目根目录：

```powershell
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
```

macOS / Linux 原生 shell 方式：

```bash
sh "<repo-root>/scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root>
```

macOS / Linux 使用 `pwsh`：

```bash
pwsh -File ./scripts/install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
```

这会写入 `.cursor/rules/` 和 `AGENTS.md`。

重要说明：对 Cursor 来说，这些 workflow bundle 也应该按“显式启用”来使用。可以安装到项目里，但只有在对话中明确点名 workflow 时，才让 Cursor 按它执行。

常用参数：

```powershell
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -DryRun
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup -Force
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -CheckDependencies
```

macOS / Linux 原生 shell 示例：

```bash
sh "<repo-root>/scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root> --dry-run
sh "<repo-root>/scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root> --backup
sh "<repo-root>/scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root> --backup --force
sh "<repo-root>/scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root> --check-dependencies
```

macOS / Linux `pwsh` 示例：

```bash
pwsh -File ./scripts/install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -DryRun
pwsh -File ./scripts/install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup
pwsh -File ./scripts/install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup -Force
pwsh -File ./scripts/install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -CheckDependencies
```

如果你想使用“三段式流程 + OpenSpec 归档”，也可以安装：

```powershell
.\scripts\install-cursor.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

macOS / Linux 原生 shell 方式：

```bash
sh "<repo-root>/scripts/install-cursor.sh" --bundle superpowers-openspec-execution --project-root <project-root>
```

macOS / Linux 使用 `pwsh`：

```bash
pwsh -File ./scripts/install-cursor.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

推荐显式启用方式：

```text
Use the superpowers-openspec-execution workflow for this feature.
```

### Claude Code

将 Claude Code bundle 安装到目标项目根目录：

```powershell
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
```

macOS / Linux 原生 shell 方式：

```bash
sh "<repo-root>/scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root>
```

macOS / Linux 使用 `pwsh`：

```bash
pwsh -File ./scripts/install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
```

这会写入 `.claude/commands/` 和 `CLAUDE.md`。

重要说明：对 Claude Code 来说，安装 bundle 以后，请优先用生成的 slash command 启用 workflow，不建议只靠自然语言描述来触发。这样 Claude Code 会读取命令文件，并稳定应用 workflow 门禁。

常用参数：

```powershell
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -DryRun
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup -Force
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -CheckDependencies
```

macOS / Linux 原生 shell 示例：

```bash
sh "<repo-root>/scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --dry-run
sh "<repo-root>/scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --backup
sh "<repo-root>/scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --backup --force
sh "<repo-root>/scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --check-dependencies
```

macOS / Linux `pwsh` 示例：

```bash
pwsh -File ./scripts/install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -DryRun
pwsh -File ./scripts/install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup
pwsh -File ./scripts/install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup -Force
pwsh -File ./scripts/install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -CheckDependencies
```

如果你想使用“三段式流程 + OpenSpec 归档”，也可以安装：

```powershell
.\scripts\install-claude-code.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

macOS / Linux 原生 shell 方式：

```bash
sh "<repo-root>/scripts/install-claude-code.sh" --bundle superpowers-openspec-execution --project-root <project-root>
```

macOS / Linux 使用 `pwsh`：

```bash
pwsh -File ./scripts/install-claude-code.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

推荐显式启用方式：

```text
Use the superpowers-openspec-execution workflow for this feature.
```

或

```text
Use $superpowers-openspec-execution-workflow for this feature.
```

对 Cursor 来说，请使用这种显式文本请求方式。上面的自然语言写法是主示例。这个 bundle 安装的是仓库规则和 `AGENTS.md` 指引，不会注册原生 slash command。

任务确认控制：

- `task_confirmation_mode` 用来控制 OpenSpec `tasks.md` 生成后，到进入实现计划之前，这个 workflow 应该如何处理任务清单确认。
- `required`：每次都必须停下来展示任务清单，等待用户确认后才能进入实现阶段。
- `optional`：默认展示任务清单并等待确认；但如果用户在本次提示词里明确要求“直接执行”，就可以跳过确认暂停。
- `off`：不等待任务确认，`tasks.md` 生成后直接进入实现计划。
- 当前默认模式是 `optional`。
- 在 `optional` 模式下，OpenSpec `tasks.md` 生成后会先展示任务清单，并等待你确认后再进入实现阶段，除非你明确要求直接执行。
- 如果你想明确要求先确认，再加一句：`OpenSpec tasks 生成后先给我看，我确认后再进入实现。`
- 如果你想直接执行，再加一句：`OpenSpec tasks 生成后直接进入实现，不用等我确认任务清单。`

例如：

```text
Use the superpowers-openspec-execution workflow for this feature.

增加点评门店信息
```

示例：

```text
Use the superpowers-openspec-execution workflow for this feature.

现在需要根据 2026-06-02_drift-bottle_create-and-audit-rating-full-chain.md 梳理的内容改造漂流瓶审核功能。
要求：
1. 目前没有审核人员，去掉人审功能。
2. 如果自动审核已经支持，则保留，不要退化。
3. 启用自动审核流程。
4. 用户最终发布漂流瓶时，如果自动评级没有给出更具体结果，则默认按“优”处理，不需要人为评级。
请严格按这个 workflow 执行：先做 Superpowers exploration，不要先进入 openspec-propose，不要先枚举 OpenSpec 技能。
```

安装后请确认目标项目里存在：

```text
CLAUDE.md
.claude/commands/superpowers-openspec-execution-workflow.md
```

如果某个 bundle 依赖 OpenSpec，脚本现在会在安装前做提示；你也可以先用 `-CheckDependencies` 单独检查环境是否满足。

## Bundle 分发模型

这个仓库现在按 bundle 分发，而不是按单个源码目录分发。

当前 bundle 目录：

- `dist/codex/bundles/`
- `dist/cursor/bundles/`
- `dist/claude-code/bundles/`

每个 bundle 只包含目标工具真正需要的文件结构。

## Build 和 Install 的区别

现在仓库里的脚本分成两类：

- `install-*.ps1`：给最终用户安装 bundle 到 Codex、Cursor、Claude Code
- `build-dist.ps1`：给维护者刷新和校验 `dist/` 分发层

维护者命令示例：

```powershell
.\scripts\build-dist.ps1
```

当你修改了 `team-skills/` 下的源码 workflow、`workflow.yaml` 元数据，或者调整了 bundle 结构时，就应该运行 `build-dist.ps1`。它不是给最终用户安装 skill 用的，而是维护和发版流程的一部分。

## 为什么要这样改

原来的 `team-skills/` 适合维护，但不适合直接分发给最终用户。因为部分入口 workflow 本身会依赖其他 workflow 或外部 skills。

所以现在明确区分：

- 源码层：给维护者用
- bundle 层：给安装和使用者用

## 工具支持

### Codex

Codex 目前是最适合的目标工具，因为它原生支持 skills。推荐使用 `dist/codex/bundles/` 下的 bundle，或者直接运行 `scripts/install-codex.ps1`。

### Cursor

Cursor 更适合使用仓库规则和 agent 指令文件，因此请使用 `dist/cursor/bundles/` 下的适配包。

### Claude Code

Claude Code 更适合使用命令文件和项目说明，因此请使用 `dist/claude-code/bundles/` 下的适配包。

### 其他工具

这个仓库后续可以继续扩展其他适配层，只需要在 `dist/` 下增加新的工具 bundle 即可。

## 显式启用规则

这些 workflow 只应在下面几种情况下启用：

- 用户明确点名某个 workflow
- 用户明确要求按这种流程来做
- 仓库策略文件明确要求必须使用该 workflow

它们不应该被当成所有编码任务的默认后台流程。

对于 Codex 用户，最稳妥的使用方式是：

1. 先安装 bundle
2. 平时保持正常的编码提问方式
3. 只有在你真的想启用该流程时，才明确点名 workflow

对于 Cursor 和 Claude Code 用户，也建议使用同样的原则：

1. 先把 bundle 安装到项目里
2. 平时保持正常提问
3. 只有在你确实想启用该流程时，才明确点名 workflow

## 相关文档

- [English README](README.md)
- [记忆指南](MEMORY.cn.md)
- [English memory guide](MEMORY.md)
- [验证指南](VERIFY.md)
- [中文验证指南](VERIFY.cn.md)
- [源码层 workflow 总览](team-skills/README.cn.md)
- [源码层安装说明](team-skills/INSTALL.cn.md)
## 增强文档

- [增强功能总览](docs/enhancement-overview.cn.md)
- [分层采用模型](docs/layered-adoption-model.cn.md)
