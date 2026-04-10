# Superpowers + OpenSpec Team Skills

Portable workflow skills for teams that want to combine Superpowers-style discovery and disciplined implementation with OpenSpec change artifacts.

This repository is documentation-first: it packages reusable `SKILL.md` workflows, lightweight agent metadata, and usage guides that can be copied into a Codex-compatible skill runtime.

## What Is Included

- [OpenSpec + Superpowers Workflow](team-skills/openspec-superpowers-workflow/README.md): full feature flow from clarification to verified delivery.
- [Superpowers -> OpenSpec -> Superpowers Workflow](team-skills/superpowers-openspec-execution-workflow/README.md): explore first, formalize with OpenSpec, then execute and archive.
- [Superpowers Feature Workflow](team-skills/superpowers-feature-workflow/README.md): design, plan, worktree, TDD, and verification without OpenSpec artifacts.
- [OpenSpec Feature Workflow](team-skills/openspec-feature-workflow/README.md): create and complete OpenSpec proposal, design, specs, and tasks.

Chinese workflow introductions are available next to each package as `readme_cn.md`.

## Quick Start

1. Read the package overview: [team-skills/README.md](team-skills/README.md)
2. Read installation guidance: [team-skills/INSTALL.md](team-skills/INSTALL.md)
3. Copy the workflow folder you need into your runtime skill directory, such as `.codex/skills/`
4. Invoke the workflow in your agent prompt:

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

## Repository Layout

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

## Requirements

- A skill-capable agent runtime, such as Codex.
- OpenSpec CLI when using workflows that create or inspect OpenSpec changes.
- A repository where generated design docs, plans, OpenSpec changes, code, tests, and verification output can be stored.

## Recommended Entry Points

- Use `openspec-superpowers-workflow` when you want one complete workflow for non-trivial feature delivery.
- Use `superpowers-openspec-execution-workflow` when the team wants exploration before formal OpenSpec artifacts.
- Use `superpowers-feature-workflow` when OpenSpec is unnecessary but disciplined planning and verification still matter.
- Use `openspec-feature-workflow` when you only need OpenSpec change artifacts before implementation.

## Chinese Documentation

- [中文首页](README.cn.md)
- [团队技能包说明](team-skills/README.cn.md)
- [安装与使用说明](team-skills/INSTALL.cn.md)
