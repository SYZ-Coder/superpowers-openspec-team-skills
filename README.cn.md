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

## 推荐入口

- 使用 `openspec-superpowers-workflow` 作为非平凡功能交付的完整入口。
- 使用 `superpowers-openspec-execution-workflow` 执行“先探索、再规范、后实现”的三段式流程。
- 使用 `superpowers-feature-workflow` 在不需要 OpenSpec 时保留设计、计划和验证纪律。
- 使用 `openspec-feature-workflow` 只补齐 OpenSpec change 产物。

## English Documentation

- [English README](README.md)
- [Team skills overview](team-skills/README.md)
- [Installation guide](team-skills/INSTALL.md)
