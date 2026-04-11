# Superpowers + OpenSpec Team Skills

这是一组可移植的团队 workflow skills，用于把 Superpowers 的探索、设计、计划、TDD、验证纪律，与 OpenSpec 的变更产物组合起来。

本仓库以文档和 skill 包为主，包含可复用的 `SKILL.md` 工作流、轻量 agent 元数据，以及可复制到 Codex 等运行环境中的使用说明。

## 包含内容

- [OpenSpec + Superpowers Workflow](team-skills/openspec-superpowers-workflow/readme_cn.md)：从需求澄清到验证完成的完整功能交付流程。
- [Superpowers -> OpenSpec -> Superpowers Workflow](team-skills/superpowers-openspec-execution-workflow/readme_cn.md)：先探索，再用 OpenSpec 固化规范，最后执行和归档。
- [Superpowers Feature Workflow](team-skills/superpowers-feature-workflow/readme_cn.md)：不创建 OpenSpec 产物，只覆盖设计、计划、worktree、TDD 和验证。
- [OpenSpec Feature Workflow](team-skills/openspec-feature-workflow/readme_cn.md)：创建并补齐 OpenSpec proposal、design、specs 和 tasks。

每个 workflow 目录中也提供英文版 `README.md`。

## 快速开始

1. 阅读技能包总览：[team-skills/README.cn.md](team-skills/README.cn.md)
2. 阅读安装说明：[team-skills/INSTALL.cn.md](team-skills/INSTALL.cn.md)
3. 将需要的 workflow 目录复制到运行时 skill 目录，例如 `.codex/skills/`
4. 在智能体提示词中调用：

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

## 仓库结构

```text
team-skills/
  README.md
  README.cn.md
  INSTALL.md
  INSTALL.cn.md
  openspec-superpowers-workflow/
  superpowers-openspec-execution-workflow/
  superpowers-feature-workflow/
  openspec-feature-workflow/
```

## 使用前提

- 支持 skill 的智能体运行环境，例如 Codex。
- 使用 OpenSpec 相关 workflow 时，需要安装 OpenSpec CLI。
- 一个可以保存设计文档、实现计划、OpenSpec change、代码、测试和验证结果的项目仓库。

## 在不同工具中如何使用这套技能库

不同的 AI 编程工具，对“可复用指令”的支持方式不一样。有的原生支持 skills，有的更适合用仓库规则、命令文件或代理说明文件来适配。

### Codex

Codex 原生支持 skills，这也是本仓库最适合的运行方式。

典型使用步骤：

1. 将 `team-skills/` 下需要的 workflow 目录复制到 Codex 的 skill 目录，例如 `.codex/skills/`
2. 重启或刷新 Codex
3. 在对话中显式调用 workflow

例如：

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

Codex app、CLI 和 IDE 扩展都适合这种方式。如果是团队协作，也可以把 skill 目录纳入仓库，通过团队配置统一分发。

### Claude Code

Claude Code 不直接使用 Codex 风格的 skills，但很适合通过项目命令和项目说明文件来适配。

推荐方式：

1. 把本仓库作为 workflow 的源定义
2. 将需要的 workflow 转成 `.claude/commands/` 下的命令文件
3. 再把高层约束同步到 `CLAUDE.md`

建议映射方式：

- `team-skills/` 下一个 workflow 目录 -> `.claude/commands/` 下一个命令文件
- `SKILL.md` 的正文 -> 命令文件中的提示词主体
- workflow 名称 -> slash command 名称

例如：

```text
.claude/commands/openspec-superpowers-workflow.md
```

调用时可以使用：

```text
/openspec-superpowers-workflow
```

如果你的团队希望把 workflow 固定在仓库里，而不是依赖某个本地技能目录，这种方式很合适。

### Cursor

Cursor 目前没有把 Codex 式 skills 作为一等能力直接暴露出来，更适合用项目规则和 agent 指令文件来适配。

推荐方式：

1. 把稳定的 workflow 约束写到 `.cursor/rules/`
2. 在仓库根目录补充 `AGENTS.md`
3. 以本仓库文档为基准，将选中的 workflow 改写成 Cursor 可识别的规则

建议映射方式：

- workflow 的概览、门禁、守则 -> `.cursor/rules/<workflow-name>.mdc`
- 仓库级行为 -> `AGENTS.md`
- 调用示例 -> Cursor 中常用的对话起手提示

在 Cursor 中，比较适合先落地：

- `superpowers-feature-workflow`，用于设计、计划、TDD、验证纪律
- `openspec-feature-workflow`，用于 OpenSpec change 产物管理

### GitHub Copilot

GitHub Copilot 不直接使用 Codex skills，但可以通过仓库级自定义说明和代理指令文件承载同样的 workflow 思路。

推荐方式：

1. 将通用约束写入 `.github/copilot-instructions.md`
2. 将路径或栈相关规则写入 `.github/instructions/*.instructions.md`
3. 通过 `AGENTS.md` 保留更完整的 agent workflow
4. 将本仓库 workflow 的步骤映射到这些说明文件里

建议映射方式：

- 通用 workflow 约束 -> `.github/copilot-instructions.md`
- 路径级或技术栈级规则 -> `.github/instructions/`
- 长流程 agent 工作方式 -> `AGENTS.md`

如果你的团队本来就在 VS Code、JetBrains、GitHub 或 Copilot CLI 中使用 Copilot，这种适配方式会比较顺手。

### Gemini CLI

Gemini CLI 也适合接入这套 workflow，不过它采用的是另一套扩展方式。

推荐方式：

1. 把持久化的仓库行为写入 `GEMINI.md`
2. 把常用 workflow 改造成 `.gemini/commands/` 下的命令文件
3. 以本仓库为源材料，持续维护这些命令和规则

建议映射方式：

- workflow 的行为规则和守则 -> `GEMINI.md`
- 可复用 workflow 入口 -> `.gemini/commands/<workflow-name>.toml`

这样可以把同一套 workflow 思路复用到 Gemini CLI，而不用每次重新写一遍提示词。

### 其他可适配的 Agent 工具

如果一个工具支持下面任意一种能力，通常都可以接入这套技能库：

- 仓库级说明文件
- 可复用 slash commands
- `AGENTS.md`、`CLAUDE.md`、`GEMINI.md` 这类 agent memory 文件
- MCP prompt 库或 prompt 模板

核心思路是一样的：

1. 以 `team-skills/*/SKILL.md` 作为原始 workflow
2. 映射到目标工具自己的指令格式
3. 保留 workflow 的阶段顺序、控制点和提示词示例

### 可移植性的建议

如果你想尽量减少重复维护，最好的方式是把这个仓库当作 workflow 的唯一源头，再为不同工具做一层很薄的适配：

- Codex：直接复制 workflow 目录作为 skills
- Claude Code：封装为 `.claude/commands/`
- Cursor：改写为 `.cursor/rules/` 加 `AGENTS.md`
- GitHub Copilot：写入 `.github/copilot-instructions.md` 加 `AGENTS.md`
- Gemini CLI：写入 `GEMINI.md` 加 `.gemini/commands/`

## 推荐入口

- 使用 `openspec-superpowers-workflow` 作为非平凡功能交付的完整入口。
- 使用 `superpowers-openspec-execution-workflow` 执行“先探索、再规范、后实现”的三段式流程。
- 使用 `superpowers-feature-workflow` 在不需要 OpenSpec 时保留设计、计划和验证纪律。
- 使用 `openspec-feature-workflow` 只补齐 OpenSpec change 产物。

## English Documentation

- [English README](README.md)
- [Team skills overview](team-skills/README.md)
- [Installation guide](team-skills/INSTALL.md)
