# Superpowers + OpenSpec Team Skills

面向 AI 编程助手的结构化工作流技能库，也是一套带有会话记忆、项目记忆和自主学习能力的 AI 协作技能库。

这个仓库的目标很直接：不要让智能体一上来就直接写代码，而是先澄清、再定规格、再实现、再验证，并在需要时沉淀项目记忆，把一次性回答升级成可持续协作的 AI 编程能力。

重要说明：这些 workflow 都是“显式启用型”。只有当用户明确点名 workflow，或仓库策略明确要求时，才应该启用。

English version: [English README](README.md)

## 先看这里

这份 README 建议按三层来读：

1. 先判断这个仓库是不是你要的协作方式。
2. 再选一条 workflow 和一个目标工具。
3. 最后按对应的安装和触发方式落地。

如果你只想最快看懂，优先看这几节：

- [这是什么仓库](#这是什么仓库)
- [包含哪些工作流](#包含哪些工作流)
- [怎么选择](#怎么选择)
- [快速开始](#快速开始)
- [任务确认与续接命令](#任务确认与续接命令)
- [多 Bundle 安装说明](#多-bundle-安装说明)

## 一眼看懂

| 你的目标 | 推荐使用 |
| --- | --- |
| 想要一条完整交付 workflow | `openspec-superpowers` |
| 想先探索、再锁规格、再实现 | `superpowers-openspec-superpowers` |
| 只想要 Superpowers 的工程纪律 | `superpowers-feature` |
| 只想生成 OpenSpec 产物 | `openspec-feature` |
| 工作结束后想沉淀经验、更新项目记忆、让下次会话直接接上 | `superpowers-learning` |

## 按工具选择

| 工具 | 安装形态 | 推荐触发方式 | 主要注意点 |
| --- | --- | --- | --- |
| Codex | `.codex/skills/` | 显式点名 skill，例如 `$openspec-superpowers-workflow` | 多 bundle 共存通常问题不大 |
| Cursor | 目标仓库里的 `AGENTS.md` + `.cursor/rules/` | 在对话里显式文本触发 | 多 bundle 混装时最容易出现路由歧义 |
| Claude Code | 目标仓库里的 `CLAUDE.md` + `.claude/commands/` | 显式 slash command | `CLAUDE.md` 以后一次安装为准 |

## 按目标选择

如果你当前最关心的是：

- 用一条 workflow 完成交付：先看 [包含哪些工作流](#包含哪些工作流)
- 先探索再锁规格：优先看 `superpowers-openspec-superpowers`
- 想在工作结束后把经验写回项目记忆、让下次会话直接接上：看 [需要跨会话记忆时再安装 memory](#4-需要跨会话记忆时再安装-memory) 和 `superpowers-learning`
- 想看不同工具安装差异：看 [不同工具的启用方式](#不同工具的启用方式)
- 想避免 bundle 和 workflow 错配：看 [安装与触发对照](#安装与触发对照) 和 [多 Bundle 安装说明](#多-bundle-安装说明)

## 先避坑

在安装和测试前，先记住这几条：

- 这些 workflow 不是默认常驻流程，必须显式启用。
- 安装的 bundle 必须和你准备触发的 workflow 对应一致。
- 对 Cursor 来说，仓库规则本身就是运行时的一部分，安装后最好重新打开项目。
- 对两个组合 workflow 来说，`tasks.md` 确认后不等于回落到 OpenSpec apply，而是应该按定义进入后续续接阶段。

## 这是什么仓库

这不是一个“只会给提示词模板”的仓库，而是一套面向 AI 编程助手的工作流技能系统。

它的核心价值是把 AI 编程从“临时对话”提升为“可重复、可追踪、可继承”的协作流程：

- 有工作流：让 AI 先理解问题，再进入实现，而不是直接开始改代码
- 有记忆：让 AI 能跨会话继承项目背景、当前状态、关键决策和已知问题
- 有学习：让 AI 在任务完成后沉淀经验，把可复用模式保留下来
- 有协作边界：让个人开发者和项目团队都能更稳定地与 AI 分工合作

如果你希望 AI 不只是“帮你写几段代码”，而是成为能持续参与需求澄清、规格收敛、实现、验证、归档和知识沉淀的工程协作者，这个仓库就是为这类使用方式设计的。

这个项目分成两层：

- `team-skills/`：项目维护的源码级 workflow 定义
- `dist/`：面向 Codex、Cursor、Claude Code 的可安装 bundle

如果你是使用者，请优先从 `dist/` 和 `scripts/` 开始。
除非你是在扩展源码 workflow，否则不要直接从 `team-skills/` 复制单个入口流程到目标工具里。

## 适合谁使用

这个仓库同时适合个人开发者和项目团队：

- 个人开发者：希望 AI 记住项目上下文，减少每次重新解释背景的成本
- 小团队：希望多人和 AI 协作时，有一致的工作流、术语和交付边界
- 持续演进的项目：希望 AI 不只是当前会话可用，而是能继承历史决策和阶段状态

如果你希望 AI 编程工具具备下面这些工作方式，这个仓库就很适合你：

- 先澄清需求，再开始实现
- 先锁定行为，再进行高风险改动
- 实现时带上测试和验证
- 完成后有明确的归档或收尾步骤
- 让跨会话协作可以继承稳定上下文
- 让 AI 逐步形成对项目的“长期记忆”和“复用经验”

## 典型使用场景

- 个人项目开发：希望 AI 能持续记住项目背景、当前阶段和上次做到哪里
- 新功能交付：希望 AI 先把需求和规格理顺，再开始编码和验证
- 老项目维护：希望 AI 在复杂仓库里少走弯路，先理解再修改
- 团队协作开发：希望不同成员调用 AI 时，得到更一致的工作方式和输出结构
- 知识沉淀：希望把关键决策、经验教训和稳定模式留下，供后续会话复用

## 包含哪些工作流

仓库当前提供 5 类工作流：

- `openspec-superpowers`：一个从澄清到验证的完整统一入口
- `superpowers-openspec-superpowers`：先用 Superpowers 把问题想透，再用 OpenSpec 把事实锁准，最后回到 Superpowers 把实现、验证和归档做稳
- `superpowers-feature`：只使用 Superpowers 的设计、计划、TDD、验证纪律
- `superpowers-learning`：不是主交付流程，而是其他 workflow 完成后的增强收尾层，用来更新项目记忆、沉淀经验，并让下一次会话可以直接接上当前成果
- `openspec-feature`：先完成 OpenSpec proposal、design、specs、tasks，再进入实现

源码层文档入口：

- [OpenSpec + Superpowers Workflow](team-skills/openspec-superpowers-workflow/readme_cn.md)
- [Superpowers -> OpenSpec -> Superpowers Workflow](team-skills/superpowers-openspec-superpowers-workflow/readme_cn.md)
- [Superpowers Feature Workflow](team-skills/superpowers-feature-workflow/readme_cn.md)
- [Superpowers Learning Workflow](team-skills/superpowers-learning-workflow/readme_cn.md)
- [OpenSpec Feature Workflow](team-skills/openspec-feature-workflow/readme_cn.md)

每个源码 workflow 也都带有一个 `workflow.yaml`，用于描述依赖与工具信息。

## 怎么选择

- 想要一个统一入口处理完整功能交付，用 `openspec-superpowers`
- 想要“先想透、再锁准、最后做稳”的四阶段节奏，用 `superpowers-openspec-superpowers`
- 只想要 Superpowers 工程纪律，不需要 OpenSpec change 产物，用 `superpowers-feature`
- 工作已经做完，想把这次经验、状态和可复用知识沉淀下来，并让下一次会话直接接上，用 `superpowers-learning`
- 只想先补齐 OpenSpec 变更文档，用 `openspec-feature`

其中 `superpowers-learning` 需要特别注意：它更像其他 workflow 的“增强收尾层”，不是一条替代开发流程的主入口。通常是在 `superpowers-feature`、`superpowers-openspec-superpowers`、`openspec-superpowers` 这类交付型 workflow 完成之后，再用它把本次会话里真正值得长期保留的内容写回 `.superpowers-memory/`，包括稳定项目事实、当前状态、简短会话记录，以及后续可沉淀成 skill、checklist 或知识库条目的经验。

对持续协作的项目，推荐这样串联：

1. 先运行一个交付型 workflow
2. 完成实现与验证
3. 再运行 `superpowers-learning`，把这次工作的稳定事实、当前状态、会话记录和可复用经验写回项目记忆

## 显式启用规则

这些 workflow 只应在以下情况启用：

- 用户明确点名某个 workflow
- 用户明确要求按这种 workflow 风格执行
- 仓库策略明确要求使用该 workflow

它们不应该成为 AI 工具的默认后台流程。

示例：

```text
请使用 $superpowers-openspec-superpowers-workflow 处理这个功能。
```

## 快速开始

### 1. 先选安装目标

- Codex：安装到 `.codex/skills/`
- Cursor：安装到目标项目，写入规则文件和 `AGENTS.md`
- Claude Code：安装到目标项目，写入命令文件和 `CLAUDE.md`

### 2. 安装 bundle

Windows PowerShell 示例：

```powershell
.\scripts\install-codex.ps1 -Bundle openspec-superpowers
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
```

macOS / Linux 示例：

```bash
sh "./scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex"
sh "./scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root>
sh "./scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root>
```

### 3. 显式启用 workflow

- Codex：

```text
请使用 $openspec-superpowers-workflow 处理这个功能，从需求澄清一直推进到验证完成。
```

- Cursor：

```text
请按 superpowers-openspec-superpowers 工作流处理这个功能。
```

- Claude Code：

```text
/superpowers-openspec-superpowers-workflow
<请描述你的功能需求>
```

### 4. 需要跨会话记忆时再安装 memory

可选记忆骨架：

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot <project-root>
```

可选工具级接入：

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool all -ProjectRoot <project-root>
```

当目标项目存在 `.superpowers-memory/` 时，workflow 可以读取和更新这些内容：

- `PROJECT_CONTEXT.md`
- `CURRENT_STATE.md`
- `DECISIONS.md`
- `KNOWN_FAILURES.md`
- `session-journal/`

如果你希望在工作结束后把这次会话真正值得保留的内容写回项目记忆，并让下一次会话可以直接接上当前经验与状态，完成后运行 `superpowers-learning`。

## 运行要求

- 使用会创建或检查 OpenSpec change 的 workflow 时，需要安装 OpenSpec CLI
- 需要一个真实项目仓库来保存文档、计划、代码、测试和验证结果
- 可选：若要启用仓库持久化记忆，目标项目需要 `.superpowers-memory/`

## 仓库结构

```text
team-skills/   workflow 源定义
dist/          面向具体工具的分发 bundle
scripts/       安装与维护脚本
templates/     memory 模板与辅助内容
docs/          补充文档
```

## Build 和 Install 的区别

这个仓库里的脚本分成两类：

- `install-*`：给最终用户安装 bundle 或 memory
- `build-dist.ps1`：给维护者刷新并校验 `dist/`

如果你修改了 workflow 源码或 bundle 结构，请运行：

```powershell
.\scripts\build-dist.ps1
```

## 工具支持

- Codex：最适合原生 skills 方式
- Cursor：通过仓库规则和 `AGENTS.md` 使用
- Claude Code：通过命令文件和 `CLAUDE.md` 使用
- 其他工具：后续可以在 `dist/` 下继续增加新适配层

## 进阶使用

### 安装脚本补充说明

原生 shell 安装脚本支持这些常用参数：

- `--bundle <name>`：选择要安装的 bundle
- `--project-root <path>`：为 Cursor、Claude Code 或 memory 安装指定目标项目根目录
- `--codex-home <path>`：为 Codex 安装指定 Codex home 目录
- `--dry-run`：只预览将写入什么，不实际复制
- `--backup`：覆盖前先备份目标文件
- `--force`：跳过覆盖确认
- `--check-dependencies`：只检查运行时依赖，例如 `openspec`

PowerShell 版本安装脚本提供同样的能力，对应参数通常是 `-Bundle`、`-ProjectRoot`、`-CodexHome`、`-DryRun`、`-Backup`、`-Force`、`-CheckDependencies`。

当前可用安装脚本：

- `scripts/install-codex.sh`
- `scripts/install-codex.ps1`
- `scripts/install-cursor.sh`
- `scripts/install-cursor.ps1`
- `scripts/install-claude-code.sh`
- `scripts/install-claude-code.ps1`
- `scripts/install-superpowers-memory.sh`
- `scripts/install-superpowers-memory.ps1`
- `scripts/install-superpowers-memory-integration.sh`
- `scripts/install-superpowers-memory-integration.ps1`

### 不同工具的启用方式

- Codex 会把 bundle 安装到 `.codex/skills/`，最接近原生 skill 体验。
- Cursor 会安装仓库规则和 `AGENTS.md`，因此应在对话里用显式文本请求启用 workflow，而不是期待原生 slash command。
- Claude Code 会安装 `.claude/commands/` 和 `CLAUDE.md`，推荐优先使用生成的 slash command，确保命令文件被稳定应用。

推荐启用示例：

- Codex：`请使用 $openspec-superpowers-workflow 处理这个功能，从需求澄清一直推进到验证完成。`
- Cursor：`请按 superpowers-openspec-superpowers 工作流处理这个功能。`
- Claude Code：`/superpowers-openspec-superpowers-workflow`

### 任务确认与续接命令

`openspec-superpowers-workflow` 和 `superpowers-openspec-superpowers-workflow` 这两个组合流程，都支持在 OpenSpec `tasks.md` 生成后进入分阶段续接。

`task_confirmation_mode` 用来控制 `tasks.md` 生成后的行为：

- `required`：必须停下并等待用户确认
- `optional`：默认展示任务清单并等待确认；如果用户明确要求直接执行，也可以继续
- `off`：不暂停，直接进入实现计划

默认模式是 `optional`。

默认流转大致如下：

1. 生成并确认 OpenSpec 产物
2. 展示 `tasks.md`，等待用户确认
3. 确认后再次暂停，询问是否继续开发执行
4. 执行和验证完成后，可再进入审查或归档续接

常用续接命令：

- `continue-dev`
- `continue-review`
- `continue-archive`

如果你的环境支持中文触发词，也可能支持对应中文口令；但为了跨环境稳定，README 里保留英文命令作为主示例。

推荐提示语：

```text
在 OpenSpec 的 tasks 生成后，先展示给我，并等待我确认后再进入实现。
```

```text
在我确认 OpenSpec tasks 之后，再询问我是否继续进入开发执行阶段。
```

### Bundle 分发模型

这个仓库现在按 bundle 分发，而不是直接把源码目录复制给最终用户。

当前 bundle 目录：

- `dist/codex/bundles/`
- `dist/cursor/bundles/`
- `dist/claude-code/bundles/`

每个 bundle 只包含目标工具真正需要的文件。

### 给维护者的说明

`team-skills/` 下的源码 workflow 会比可安装 bundle 更模块化。

这样拆分的原因是：

- 源码 workflow 面向维护者
- bundle 面向最终使用者

如果你修改了源码 workflow、元数据或 bundle 结构约定，请重新构建 `dist/`：

```powershell
.\scripts\build-dist.ps1
```

## 相关文档

- [English README](README.md)
- [中文 README](README.cn.md)
- [English Memory Guide](MEMORY.md)
- [中文记忆指南](MEMORY.cn.md)
- [English Verification Guide](VERIFY.md)
- [中文验证指南](VERIFY.cn.md)
- [English Source Workflow Overview](team-skills/README.md)
- [中文源码工作流总览](team-skills/README.cn.md)
- [English Source Workflow Install Notes](team-skills/INSTALL.md)
- [中文源码工作流安装说明](team-skills/INSTALL.cn.md)
- [English Source Workflow Usage Guide](team-skills/USAGE.md)
- [中文源码工作流使用指南](team-skills/USAGE.cn.md)

## 社区与维护

- [CONTRIBUTING.md](CONTRIBUTING.md)
- [SECURITY.md](SECURITY.md)
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
- [CHANGELOG.md](CHANGELOG.md)

## 安装与触发对照

如果你在 Cursor、Codex 或 Claude Code 里要使用某条 workflow，安装的 bundle 和触发的 workflow 名称必须对应一致。

- 想走 `openspec-superpowers-workflow`
  - 安装：`openspec-superpowers`
  - 触发：`$openspec-superpowers-workflow`、`Use the openspec-superpowers workflow for this feature.`
- 想走 `superpowers-openspec-superpowers-workflow`
  - 安装：`superpowers-openspec-superpowers`
  - 触发：`$superpowers-openspec-superpowers-workflow`、`Use the superpowers-openspec-superpowers workflow for this feature.`

不要安装 `openspec-superpowers`，却去触发 `superpowers-openspec-superpowers`。这会让工具命中另一套路由规则，常见表现就是：

- 先去列 `openspec-propose`、`opsx:propose` 之类的 OpenSpec 命令
- `tasks.md` 生成后提示 `/opsx:apply`
- 没有按组合 workflow 回到 Superpowers 继续执行

对 Cursor 来说，`superpowers-openspec-superpowers` 不是原生 slash command，而是依赖目标项目里的 `AGENTS.md` 和 `.cursor/rules` 生效。所以推荐顺序是：

1. 先安装 `superpowers-openspec-superpowers` bundle
2. 确认目标项目里的 `AGENTS.md` 和 `.cursor/rules/` 已被覆盖到最新版本
3. 重新打开项目
4. 再输入：`请按 superpowers-openspec-superpowers 工作流处理这个功能。`

## 多 Bundle 安装说明

多个 bundle 可以安装，但三种工具的行为不一样。

- Codex：风险最低。bundle 会以独立 skill 目录并存，比如 `openspec-superpowers-workflow` 和 `superpowers-openspec-superpowers-workflow` 可以同时存在。主要要求只是触发时明确点名你要的 workflow。
- Claude Code：中等风险。`.claude/commands/` 下的命令文件可以并存，但顶层 `CLAUDE.md` 是共享文件，最后一次安装的 bundle 会覆盖它。
- Cursor：风险最高。安装 bundle 时会把 `AGENTS.md` 和 `.cursor/rules/` 复制到目标项目里。`AGENTS.md` 会被最后一次安装覆盖，而 `.cursor/rules/` 里的规则文件可能会并存叠加，所以最终行为取决于项目里实际落下来的文件组合。

推荐做法：

1. Codex：可以比较放心地安装多个 bundle，但触发时要明确点名 workflow。
2. Claude Code：可以安装多个 bundle，但最好主要依赖显式 slash command，并接受 `CLAUDE.md` 以后安装者为准。
3. Cursor：普通用户最好一个项目只保留一套主 workflow bundle；如果要混装，就需要自己确认最终的 `AGENTS.md` 和 `.cursor/rules/` 内容。
