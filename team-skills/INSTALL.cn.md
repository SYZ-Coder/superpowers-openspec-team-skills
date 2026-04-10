# Team Skills 安装与使用说明

这份文档说明如何安装并运行本仓库中的 workflow skills。

如果只是阅读、评审或维护文档，不需要安装 OpenSpec，也不需要安装 Superpowers。下面的运行时环境只在智能体需要真正执行这些流程时才需要准备。

## 包列表

本仓库的 workflow 包统一放在 `team-skills/` 下：

- [openspec-superpowers-workflow](openspec-superpowers-workflow/README.md)
- [superpowers-openspec-execution-workflow](superpowers-openspec-execution-workflow/README.md)
- [superpowers-feature-workflow](superpowers-feature-workflow/README.md)
- [openspec-feature-workflow](openspec-feature-workflow/README.md)

每个包包含：

- `SKILL.md`：可被运行时调用的 workflow 指令。
- `README.md`：英文介绍。
- `readme_cn.md`：中文介绍。
- `agents/openai.yaml`：轻量 agent UI 元数据。

## 运行时依赖

真正执行这套流程时，需要准备：

- 一个支持 skill 的智能体运行环境，例如 Codex。
- 一个项目仓库，用于保存设计文档、实现计划、OpenSpec change、代码、测试和验证输出。
- OpenSpec CLI，供 OpenSpec 相关 workflow 使用。
- Superpowers 基础 skills，供 Superpowers 相关 workflow 使用。
- 本仓库中的团队 workflow skills，需要复制到运行时 skill 目录。

本仓库的 workflow skills 是编排入口。它们会调用底层 OpenSpec 和 Superpowers skills，因此运行环境中也需要能找到这些底层 skills。

## 安装 OpenSpec CLI

以下 workflow 需要 OpenSpec：

- `openspec-superpowers-workflow`
- `superpowers-openspec-execution-workflow`
- `openspec-feature-workflow`

使用 npm 安装：

```bash
npm install -g @fission-ai/openspec@latest
```

验证安装：

```bash
openspec --version
```

如果提示找不到 `openspec`，检查 npm 全局可执行目录是否已经加入 `PATH`。

在 Windows PowerShell 中，通常可以用下面的命令查看 npm 全局可执行目录：

```powershell
npm bin -g
```

## 安装 Superpowers 基础 Skills

以下 workflow 需要 Superpowers：

- `openspec-superpowers-workflow`
- `superpowers-openspec-execution-workflow`
- `superpowers-feature-workflow`

这些 workflow 会引用 Superpowers skills，例如：

- `brainstorming`
- `writing-plans`
- `using-git-worktrees`
- `test-driven-development`
- `verification-before-completion`
- `finishing-a-development-branch`

请按照你的智能体运行环境说明安装 Superpowers skill 集合。对 Codex 风格的环境来说，关键结果是这些 Superpowers skill 目录能够被运行时发现，例如放在：

```text
~/.codex/skills/
```

Windows 上通常是：

```text
%USERPROFILE%\.codex\skills\
```

如果你的运行环境使用其他 skill 目录，请以实际目录为准。

## 安装本仓库 Team Skills

将本仓库中的 workflow 目录复制到运行时 skill 目录。

### macOS / Linux

在仓库根目录执行：

```bash
mkdir -p ~/.codex/skills
cp -R team-skills/openspec-superpowers-workflow ~/.codex/skills/
cp -R team-skills/superpowers-openspec-execution-workflow ~/.codex/skills/
cp -R team-skills/superpowers-feature-workflow ~/.codex/skills/
cp -R team-skills/openspec-feature-workflow ~/.codex/skills/
```

### Windows PowerShell

在仓库根目录执行：

```powershell
$skillDir = Join-Path $env:USERPROFILE ".codex\skills"
New-Item -ItemType Directory -Force -Path $skillDir
Copy-Item -Recurse -Force team-skills\openspec-superpowers-workflow $skillDir
Copy-Item -Recurse -Force team-skills\superpowers-openspec-execution-workflow $skillDir
Copy-Item -Recurse -Force team-skills\superpowers-feature-workflow $skillDir
Copy-Item -Recurse -Force team-skills\openspec-feature-workflow $skillDir
```

## 验证 Skill 是否可用

复制完成后，重启或刷新你的智能体运行环境。

然后在提示词中显式调用一个 workflow：

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

如果运行时提示找不到 skill：

- 确认目录名和 `SKILL.md` 中的 `name` 字段一致。
- 确认 `SKILL.md` 直接位于复制后的 workflow 目录下。
- 确认目录复制到了运行时正在使用的 skill 目录。
- 重启运行时，让它重新发现 skills。

## 验证 OpenSpec 是否可用

在使用 OpenSpec 的项目中执行：

```bash
openspec status
```

针对具体 change，workflow 会依赖类似命令：

```bash
openspec status --change "<change-name>" --json
openspec instructions apply --change "<change-name>" --json
```

如果这些命令失败，请先安装或更新 OpenSpec，再执行 OpenSpec 相关 workflow。

## 推荐调用方式

完整 OpenSpec + Superpowers 流程：

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

三段式流程：

```text
Use $superpowers-openspec-execution-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```

只走 Superpowers 功能流程：

```text
Use $superpowers-feature-workflow to drive the Superpowers stages for this feature request.
```

只生成 OpenSpec 产物：

```text
Use $openspec-feature-workflow to create and complete the OpenSpec change for this feature.
```

## 维护建议

- 保持 workflow 目录可移植，不要写入本机绝对路径。
- `SKILL.md` 只放可执行的 workflow 指令。
- `README.md` 和 `readme_cn.md` 只放面向读者的介绍说明。
- 修改本仓库后，需要重新复制更新后的 workflow 目录到运行时 skill 目录。
