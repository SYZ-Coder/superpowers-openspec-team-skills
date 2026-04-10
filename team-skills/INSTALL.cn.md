# Team Skills 安装与使用说明

这份文档说明如何把仓库里的 team skills 接入团队环境，以及日常如何调用和维护。

## 目录概览

当前 skill 包位于：

- [openspec-superpowers-workflow](openspec-superpowers-workflow/README.md)
- [superpowers-openspec-execution-workflow](superpowers-openspec-execution-workflow/README.md)
- [superpowers-feature-workflow](superpowers-feature-workflow/README.md)
- [openspec-feature-workflow](openspec-feature-workflow/README.md)

## 使用前需要满足的条件

只做文档维护、评审或开源整理时，不需要先安装 `OpenSpec`，也不需要单独安装 `Superpowers`。

如果要在运行时真正执行这套流程，需要：

- 一个支持 skill 自动发现或显式调用的运行环境，例如 Codex。
- 把目标 skill 复制到运行时 skill 目录，例如 `.codex/skills/`。
- 安装 `openspec` CLI，因为进入 OpenSpec 阶段的 skill 会调用 `openspec status` 和 `openspec instructions`。

## 推荐调用方式

一条完整流程：

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

三段式组合流程：

```text
Use $superpowers-openspec-execution-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```

## 统一 skill 目录

所有团队 skill 包都放在当前仓库的 `team-skills/` 下，方便团队统一查看、安装和分发。
