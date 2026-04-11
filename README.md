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

## Using This Skill Pack In Different Tools

Different coding agents expose reusable instructions in different ways. Some support skills directly, while others use repository rules, command files, or agent instruction files.

### Codex

Codex has native support for skills. This is the best fit for this repository.

Typical setup:

1. Copy one or more workflow folders from `team-skills/` into your Codex skill directory, such as `.codex/skills/`
2. Restart or reload Codex
3. Invoke the workflow explicitly in chat

Example:

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

Codex can use skills in the app, CLI, and IDE extension. For team usage, you can also check skill folders into a repository and share them through team config.

### Claude Code

Claude Code does not use Codex-style skills directly, but it supports reusable project commands and project instructions.

Recommended setup:

1. Keep this repository as the source of truth for workflow definitions
2. Convert the workflow you need into a project command under `.claude/commands/`
3. Optionally mirror high-level workflow rules into `CLAUDE.md`

Suggested mapping:

- One workflow directory in `team-skills/` -> one command file in `.claude/commands/`
- `SKILL.md` content -> command prompt body
- Workflow name -> slash command name

Example command:

```text
.claude/commands/openspec-superpowers-workflow.md
```

Then invoke:

```text
/openspec-superpowers-workflow
```

This works especially well when your team wants shared, repo-local commands without requiring Codex.

### Cursor

Cursor does not currently expose Codex-style skills as a first-class feature. The closest equivalent is project rules plus agent instructions.

Recommended setup:

1. Put stable workflow guidance into `.cursor/rules/`
2. Add a top-level `AGENTS.md` for agent-oriented instructions
3. Keep this repository's workflow docs as the canonical source, and adapt the chosen workflow into Cursor rules

Suggested mapping:

- Workflow overview and guardrails -> `.cursor/rules/<workflow-name>.mdc` or project rule file
- Repo-wide behavior -> `AGENTS.md`
- Prompt examples from this repo -> reusable chat starters in Cursor

Good fit in Cursor:

- `superpowers-feature-workflow` as a design-and-verify rule
- `openspec-feature-workflow` as an OpenSpec change-management rule

### GitHub Copilot

GitHub Copilot does not use Codex skills directly, but it supports repository custom instructions and agent instruction files.

Recommended setup:

1. Add repository-wide guidance in `.github/copilot-instructions.md`
2. Add path-specific instructions in `.github/instructions/*.instructions.md` if needed
3. Add `AGENTS.md` for agent-style workflows
4. Port the workflow steps from this repository into those instruction files

Suggested mapping:

- General workflow expectations -> `.github/copilot-instructions.md`
- Path- or stack-specific workflow rules -> `.github/instructions/`
- Long-form agent workflow -> `AGENTS.md`

This works well if your team already uses Copilot in VS Code, JetBrains, GitHub, or Copilot CLI.

### Gemini CLI

Gemini CLI is another good candidate, but it uses a different extension model.

Recommended setup:

1. Put persistent repository behavior into `GEMINI.md`
2. Convert frequently-used workflows into custom slash commands under `.gemini/commands/`
3. Use this repository as the source material for those commands and instructions

Suggested mapping:

- Workflow policy and behavioral rules -> `GEMINI.md`
- Reusable workflow entrypoints -> `.gemini/commands/<workflow-name>.toml`

This is a practical way to reuse the same workflow ideas without rewriting them from scratch every session.

### Other Agent Runtimes

If a tool supports any of the following, you can usually adapt this skill pack successfully:

- repository instruction files
- reusable slash commands
- agent memory files such as `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md`
- MCP prompts or prompt libraries

The main idea is consistent:

1. keep `team-skills/*/SKILL.md` as the source workflow
2. map each workflow into the tool's native instruction format
3. preserve the same stage order, guardrails, and prompt examples

### Portability Recommendation

For the least duplication, use this repository as the canonical workflow source and maintain thin adapters for each tool:

- Codex: copy workflow folders as skills
- Claude Code: create `.claude/commands/` wrappers
- Cursor: create `.cursor/rules/` plus `AGENTS.md`
- GitHub Copilot: create `.github/copilot-instructions.md` plus `AGENTS.md`
- Gemini CLI: create `GEMINI.md` plus `.gemini/commands/`

## Recommended Entry Points

- Use `openspec-superpowers-workflow` when you want one complete workflow for non-trivial feature delivery.
- Use `superpowers-openspec-execution-workflow` when the team wants exploration before formal OpenSpec artifacts.
- Use `superpowers-feature-workflow` when OpenSpec is unnecessary but disciplined planning and verification still matter.
- Use `openspec-feature-workflow` when you only need OpenSpec change artifacts before implementation.

## Chinese Documentation

- [中文首页](README.cn.md)
- [团队技能包说明](team-skills/README.cn.md)
- [安装与使用说明](team-skills/INSTALL.cn.md)
