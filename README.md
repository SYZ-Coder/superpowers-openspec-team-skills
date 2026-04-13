# Superpowers + OpenSpec Team Skills

Portable workflow packs for teams that want AI coding agents to follow a disciplined path instead of jumping straight into code.

This repository now has two layers:

- `team-skills/`: source workflow definitions maintained by the project
- `dist/`: pre-adapted bundles for specific tools such as Codex, Cursor, and Claude Code

If you are a user of this repository, start with `dist/` and `scripts/`. Do not copy a single orchestrator workflow from `team-skills/` unless you are intentionally extending or adapting the source definitions yourself.

Important: these workflows are explicit opt-in workflows. They are not intended to become the default background behavior of your AI tool. Users should turn them on by explicit request, by naming the workflow, or because a repository policy explicitly requires them.

If you want Codex to ignore these workflows unless explicitly invoked, install the bundle and only activate it by workflow name in the conversation.

Example:

```text
Use $superpowers-openspec-execution-workflow for this feature.
```

## What Is Included

Source workflows:

- [OpenSpec + Superpowers Workflow](team-skills/openspec-superpowers-workflow/README.md)
- [Superpowers -> OpenSpec -> Superpowers Workflow](team-skills/superpowers-openspec-execution-workflow/README.md)
- [Superpowers Feature Workflow](team-skills/superpowers-feature-workflow/README.md)
- [OpenSpec Feature Workflow](team-skills/openspec-feature-workflow/README.md)

Each source workflow now also includes a machine-readable `workflow.yaml` file for dependency and tool metadata.

## Repository Layout

```text
team-skills/   source workflow definitions
dist/          prebuilt bundles for specific tools
scripts/       install scripts for supported tools
```

## Quick Start

Before running any install script, either:

- change into the repository root first, or
- invoke the script by absolute path

Example:

```powershell
cd <repo-root>
.\scripts\install-codex.ps1 -Bundle openspec-superpowers
```

or:

```powershell
& "<repo-root>\scripts\install-codex.ps1" -Bundle openspec-superpowers
```

### Codex

Install a prebuilt Codex bundle instead of copying a source workflow manually.

PowerShell:

```powershell
.\scripts\install-codex.ps1 -Bundle openspec-superpowers
```

Useful options:

```powershell
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -DryRun
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -Backup
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -Backup -Force
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -CheckDependencies
```

- `-DryRun`: show what would be installed without copying files
- `-Backup`: back up existing same-name skill directories before overwrite
- `-Force`: skip overwrite confirmation
- `-CheckDependencies`: check runtime requirements such as `openspec` without installing files

Then restart or refresh Codex and invoke:

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

If you do not explicitly ask for one of these workflows, Codex should continue behaving normally and should not assume Superpowers or OpenSpec workflow usage by default.

Available Codex bundles:

- `openspec-superpowers`
- `superpowers-openspec-execution`
- `superpowers-feature`
- `openspec-feature`

### Cursor

Install a Cursor bundle into the target repository root:

```powershell
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
```

This writes `.cursor/rules/` files plus an `AGENTS.md` workflow guide.

Important: for Cursor, these workflow bundles are also intended to be explicit opt-in. Install them into the project, but only ask Cursor to follow them when you explicitly name the workflow in chat.

Useful options:

```powershell
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -DryRun
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup -Force
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -CheckDependencies
```

You can also install the three-stage execution bundle:

```powershell
.\scripts\install-cursor.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

Recommended explicit activation pattern:

```text
Use the superpowers-openspec-execution workflow for this feature.
```

### Claude Code

Install a Claude Code bundle into the target repository root:

```powershell
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
```

This writes `.claude/commands/` files plus a `CLAUDE.md` project guide.

Important: for Claude Code, install the bundle but only activate the workflow when you explicitly invoke the command or explicitly ask for the workflow style.

Useful options:

```powershell
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -DryRun
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup -Force
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -CheckDependencies
```

You can also install the three-stage execution bundle:

```powershell
.\scripts\install-claude-code.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

Recommended explicit activation pattern:

```text
/superpowers-openspec-execution-workflow
```

Bundles that rely on OpenSpec will install even if `openspec` is missing, but the scripts now warn you before install and can explicitly check dependencies first.

## Bundle Model

This repository distributes user-facing workflow packs as bundles, not as single folders copied from the source tree.

Current bundle families:

- `dist/codex/bundles/`
- `dist/cursor/bundles/`
- `dist/claude-code/bundles/`

Each bundle contains only the files that the target tool expects.

## Build vs Install

There are now two different script roles in this repository:

- `install-*.ps1`: for end users installing a bundle into Codex, Cursor, or Claude Code
- `build-dist.ps1`: for maintainers refreshing and validating the distributable layer under `dist/`

Example maintainer command:

```powershell
.\scripts\build-dist.ps1
```

Use `build-dist.ps1` after changing source workflows in `team-skills/`, metadata in `workflow.yaml`, or bundle structure conventions. It does not install anything into an AI tool. It is part of the release and maintenance workflow.

## Why This Changed

The original source workflows are modular and reusable, but some entry workflows depend on other workflows or external skills. That is good for maintenance, but it is not a good installation experience.

The new structure fixes that by making a clear distinction:

- source workflows are for maintainers
- bundles are for end users

## Tool Support

### Codex

Codex is the best current fit because it supports skills directly. Use the prebuilt bundle under `dist/codex/bundles/` or the installer script under `scripts/install-codex.ps1`.

### Cursor

Cursor uses repository rules and agent instructions rather than Codex-style skills. Use the bundles under `dist/cursor/bundles/`.

### Claude Code

Claude Code uses command files and project instructions rather than Codex-style skills. Use the bundles under `dist/claude-code/bundles/`.

### Other Tools

The repository is designed so that other agent runtimes can be supported later by adding new bundle adapters under `dist/`.

## Requirements

- OpenSpec CLI when using workflows that create or inspect OpenSpec changes
- A project repository where the agent can write design docs, plans, OpenSpec changes, code, tests, and verification output

## Recommended Entry Points

- `openspec-superpowers`: full feature flow from clarification through verification
- `superpowers-openspec-execution`: Superpowers exploration, OpenSpec locking, Superpowers execution and verification, then OpenSpec archive
- `superpowers-feature`: design, planning, TDD, and verification without OpenSpec artifact generation
- `openspec-feature`: OpenSpec proposal, design, specs, and tasks before implementation

## Explicit Activation

These workflows should only activate when one of the following is true:

- the user explicitly names the workflow
- the user explicitly asks for the workflow style
- the repository policy explicitly requires the workflow

They should not be treated as default background behavior for every coding request.

For Codex users, the safest pattern is:

1. install the bundle
2. keep normal coding prompts unchanged
3. explicitly name the workflow only when you want it

For Cursor and Claude Code users, follow the same rule:

1. install the bundle into the project
2. keep normal prompts unchanged
3. explicitly ask for the workflow by name only when you want it

## Documentation

- [Chinese README](README.cn.md)
- [Verification guide](VERIFY.md)
- [Chinese verification guide](VERIFY.cn.md)
- [Source workflow overview](team-skills/README.md)
- [Source workflow installation notes](team-skills/INSTALL.md)
