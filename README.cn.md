# Superpowers + OpenSpec Team Skills

这是一套面向 AI 编程助手的工作流技能库，目标很直接：让智能体按流程做事，而不是一上来就直接写代码。

现在仓库分成两层：

- `team-skills/`：项目维护的源码级 workflow 定义
- `dist/`：面向具体工具的可安装 bundle

如果你是使用者，请优先使用 `dist/` 和 `scripts/`。不要再像以前那样，直接从 `team-skills/` 里复制单个入口 workflow 到目标工具目录，否则很容易因为依赖不完整而无法使用。

## 包含内容

源码层 workflow：

- [OpenSpec + Superpowers Workflow](team-skills/openspec-superpowers-workflow/readme_cn.md)
- [Superpowers -> OpenSpec -> Superpowers Workflow](team-skills/superpowers-openspec-execution-workflow/readme_cn.md)
- [Superpowers Feature Workflow](team-skills/superpowers-feature-workflow/readme_cn.md)
- [OpenSpec Feature Workflow](team-skills/openspec-feature-workflow/readme_cn.md)

每个源码 workflow 现在都额外带有一个 `workflow.yaml`，用于描述依赖、支持的工具和运行要求。

## 仓库结构

```text
team-skills/   workflow 源定义
dist/          面向具体工具的分发包
scripts/       安装脚本
```

## 快速开始

在运行安装脚本前，请先满足下面两种方式之一：

- 先切换到仓库根目录再执行
- 或者直接使用脚本的绝对路径执行

例如：

```powershell
cd <repo-root>
.\scripts\install-codex.ps1 -Bundle openspec-superpowers
```

或者：

```powershell
& "<repo-root>\scripts\install-codex.ps1" -Bundle openspec-superpowers
```

### Codex

不要再手动复制源码 workflow，直接安装 Codex bundle。

PowerShell：

```powershell
.\scripts\install-codex.ps1 -Bundle openspec-superpowers
```

常用参数：

```powershell
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -DryRun
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -Backup
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -Backup -Force
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -CheckDependencies
```

- `-DryRun`：只预览将安装什么，不实际复制
- `-Backup`：覆盖前先备份同名 skill 目录
- `-Force`：跳过覆盖确认
- `-CheckDependencies`：只检查运行时依赖，例如 `openspec`，不安装文件

然后重启或刷新 Codex，再调用：

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

当前可用的 Codex bundle：

- `openspec-superpowers`
- `superpowers-openspec-execution`
- `superpowers-feature`
- `openspec-feature`

### Cursor

将 Cursor bundle 安装到目标项目根目录：

```powershell
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
```

这会写入 `.cursor/rules/` 和 `AGENTS.md`。

常用参数：

```powershell
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -DryRun
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup -Force
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -CheckDependencies
```

如果你想使用“三段式流程 + OpenSpec 归档”，也可以安装：

```powershell
.\scripts\install-cursor.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

### Claude Code

将 Claude Code bundle 安装到目标项目根目录：

```powershell
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
```

这会写入 `.claude/commands/` 和 `CLAUDE.md`。

常用参数：

```powershell
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -DryRun
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup -Force
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -CheckDependencies
```

如果你想使用“三段式流程 + OpenSpec 归档”，也可以安装：

```powershell
.\scripts\install-claude-code.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
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

## 运行要求

- 使用 OpenSpec 相关 workflow 时，需要安装 OpenSpec CLI
- 需要一个实际项目仓库来保存设计文档、计划、OpenSpec change、代码、测试和验证结果

## 推荐入口

- `openspec-superpowers`：完整功能交付流程
- `superpowers-openspec-execution`：先 Superpowers 探索，再 OpenSpec 固化，再回到 Superpowers 实现验证，最后归档 OpenSpec change
- `superpowers-feature`：不生成 OpenSpec 产物，只做设计、计划、TDD、验证
- `openspec-feature`：只做 OpenSpec proposal、design、specs、tasks

## 相关文档

- [English README](README.md)
- [验证指南](VERIFY.md)
- [中文验证指南](VERIFY.cn.md)
- [源码层 workflow 总览](team-skills/README.cn.md)
- [源码层安装说明](team-skills/INSTALL.cn.md)
