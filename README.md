# Superpowers + OpenSpec Team Skills

## Chinese Docs

Chinese readers can start here:

- [README.cn.md](README.cn.md)
- [MEMORY.cn.md](MEMORY.cn.md)
- [VERIFY.cn.md](VERIFY.cn.md)
- [team-skills/INSTALL.cn.md](team-skills/INSTALL.cn.md)
- [team-skills/README.cn.md](team-skills/README.cn.md)

This is a skill library with memory and autonomous learning workflows designed for AI programming assistants. The goal is straightforward: enable agents to follow structured processes rather than jumping straight into writing code.Users can combine Superpowers and OpenSpec as needed.

This repository now has two layers:

- `team-skills/`: source workflow definitions maintained by the project
- `dist/`: pre-adapted bundles for specific tools such as Codex, Cursor, and Claude Code

If you are a user of this repository, start with `dist/` and `scripts/`. Do not copy a single orchestrator workflow from `team-skills/` unless you are intentionally extending or adapting the source definitions yourself.

Source workflows under `team-skills/` and tool bundles under `dist/` may differ in wording and structure, but they should remain functionally aligned. Source workflows are maintainer-facing definitions; distributed bundles are tool-adapted runtime forms of the same workflow.

Important: these workflows are explicit opt-in workflows. They are not intended to become the default background behavior of your AI tool. Users should turn them on by explicit request, by naming the workflow, or because a repository policy explicitly requires them.

If you want Codex to ignore these workflows unless explicitly invoked, install the bundle and only activate it by workflow name in the conversation.

Example:

```text
Use $superpowers-openspec-execution-workflow for this feature.
```

## Start Here

### Why This Skill Pack Exists

This repository is for teams that want AI coding tools to stop jumping straight into code and instead follow a clearer delivery path:

- clarify before implementation
- lock agreed behavior before risky changes
- implement with tests and verification
- keep a clean closeout path for completed work
- preserve project context in the repository so new sessions do not start from scratch

### Project Memory

This repository now includes an optional repo-persisted memory pattern for Superpowers-based workflows.

When a project contains `.superpowers-memory/`, Superpowers workflows should:

- read `PROJECT_CONTEXT.md` for stable project facts
- read `CURRENT_STATE.md` for the latest working context
- read `DECISIONS.md` and `KNOWN_FAILURES.md` when they exist
- read recent entries under `session-journal/`
- update the relevant memory files before ending the session
- run `scripts/validate-superpowers-memory.ps1` when memory quality matters for the workflow

This gives AI a lightweight cross-session memory without requiring a separate memory service.

### Requirements

- OpenSpec CLI when using workflows that create or inspect OpenSpec changes
- A real project repository where the agent can write design docs, plans, OpenSpec changes, code, tests, and verification output
- Optional for cross-session memory: a `.superpowers-memory/` folder in the target project

### Recommended Entry Points

- `openspec-superpowers`: full feature flow from clarification through verification
- `superpowers-openspec-execution`: Superpowers exploration, OpenSpec locking, Superpowers execution and verification, then OpenSpec archive
- `superpowers-feature`: design, planning, TDD, and verification without OpenSpec artifact generation
- `superpowers-learning`: reflective capture of durable project knowledge, session outcomes, and reusable lessons
- `openspec-feature`: OpenSpec proposal, design, specs, and tasks before implementation

### How To Choose

- Use `openspec-superpowers` when you want one end-to-end entry point and do not want to decide the step order yourself. It is the general full-flow option from clarification through verification.
- Use `superpowers-openspec-execution` when you want a fixed four-step path: Superpowers exploration, OpenSpec locking, Superpowers execution, and OpenSpec archive.
- Use `superpowers-feature` when you only want the Superpowers engineering discipline without OpenSpec change artifacts.
- Use `superpowers-learning` when meaningful work has finished and you want to preserve what the session taught the team.
- Use `openspec-feature` when you only want to create or complete OpenSpec change artifacts before implementation.

### Recommended Closure

For long-running projects, a good pattern is:

1. use one delivery workflow
2. finish implementation and verification
3. use `superpowers-learning` to preserve durable lessons and current state

## What Is Included

Source workflows:

- [OpenSpec + Superpowers Workflow](team-skills/openspec-superpowers-workflow/README.md)
- [Superpowers -> OpenSpec -> Superpowers Workflow](team-skills/superpowers-openspec-execution-workflow/README.md)
- [Superpowers Feature Workflow](team-skills/superpowers-feature-workflow/README.md)
- [Superpowers Learning Workflow](team-skills/superpowers-learning-workflow/README.md)
- [OpenSpec Feature Workflow](team-skills/openspec-feature-workflow/README.md)

Each source workflow now also includes a machine-readable `workflow.yaml` file for dependency and tool metadata.

## Repository Layout

```text
team-skills/   source workflow definitions
dist/          prebuilt bundles for specific tools
scripts/       install scripts for supported tools
```

## Quick Start

In this document, `<repo-root>` means the local filesystem path of this repository after you clone or unzip it.

Examples:

- macOS: `/Users/alex/projects/superpowers-openspec-team-skills`
- Linux: `/home/alex/projects/superpowers-openspec-team-skills`
- Windows: `D:\projects\superpowers-openspec-team-skills`

So this command:

```bash
sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex"
```

becomes, for example:

```bash
sh "/Users/alex/projects/superpowers-openspec-team-skills/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex"
```

Before running any install script, either:

- change into the repository root first, or
- invoke the script by absolute path

Windows PowerShell:

```powershell
cd <repo-root>
.\scripts\install-codex.ps1 -Bundle openspec-superpowers
```

Windows PowerShell with absolute path:

```powershell
& "<repo-root>\scripts\install-codex.ps1" -Bundle openspec-superpowers
```

macOS or Linux with native shell:

```bash
cd <repo-root>
sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex"
```

macOS or Linux with PowerShell 7 (`pwsh`) if available:

```bash
cd <repo-root>
pwsh -File ./scripts/install-codex.ps1 -Bundle openspec-superpowers -CodexHome "$HOME/.codex"
```

### Shell Installer Options

The native shell installers support these flags:

- `--bundle <name>`: choose which bundle to install
- `--project-root <path>`: set the target repository root for Cursor, Claude Code, or memory installation
- `--codex-home <path>`: set the Codex home directory for Codex installs
- `--dry-run`: preview what would be written without copying files
- `--backup`: back up existing target files before overwrite
- `--force`: skip overwrite confirmation
- `--check-dependencies`: check runtime requirements such as `openspec` without installing files

Available shell installers:

- `scripts/install-codex.sh`
- `scripts/install-cursor.sh`
- `scripts/install-claude-code.sh`
- `scripts/install-superpowers-memory.sh`
- `scripts/install-superpowers-memory-integration.sh`

Optional memory scaffold for any target project:

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot <project-root>
```

macOS or Linux with native shell:

```bash
sh "<repo-root>/scripts/install-superpowers-memory.sh" --project-root <project-root>
```

macOS or Linux with PowerShell 7 (`pwsh`) if available:

```bash
pwsh -File ./scripts/install-superpowers-memory.ps1 -ProjectRoot <project-root>
```

Optional project-level memory integration for Codex, Cursor, and Claude Code:

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool all -ProjectRoot <project-root>
```

macOS or Linux with native shell:

```bash
sh "<repo-root>/scripts/install-superpowers-memory-integration.sh" --tool all --project-root <project-root>
```

macOS or Linux with PowerShell 7 (`pwsh`) if available:

```bash
pwsh -File ./scripts/install-superpowers-memory-integration.ps1 -Tool all -ProjectRoot <project-root>
```

### Codex

Install a prebuilt Codex bundle instead of copying a source workflow manually.

PowerShell:

```powershell
.\scripts\install-codex.ps1 -Bundle openspec-superpowers
```

macOS or Linux with native shell:

```bash
sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex"
```

macOS or Linux with PowerShell 7 (`pwsh`) if available:

```bash
pwsh -File ./scripts/install-codex.ps1 -Bundle openspec-superpowers -CodexHome "$HOME/.codex"
```

Useful options:

```powershell
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -DryRun
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -Backup
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -Backup -Force
.\scripts\install-codex.ps1 -Bundle openspec-superpowers -CheckDependencies
```

macOS or Linux native shell examples:

```bash
sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --dry-run
sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --backup
sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --backup --force
sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --check-dependencies
```

macOS or Linux PowerShell examples:

```bash
pwsh -File ./scripts/install-codex.ps1 -Bundle openspec-superpowers -CodexHome "$HOME/.codex" -DryRun
pwsh -File ./scripts/install-codex.ps1 -Bundle openspec-superpowers -CodexHome "$HOME/.codex" -Backup
pwsh -File ./scripts/install-codex.ps1 -Bundle openspec-superpowers -CodexHome "$HOME/.codex" -Backup -Force
pwsh -File ./scripts/install-codex.ps1 -Bundle openspec-superpowers -CodexHome "$HOME/.codex" -CheckDependencies
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
- `superpowers-learning`
- `openspec-feature`

### Cursor

Install a Cursor bundle into the target repository root:

```powershell
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
```

macOS or Linux with native shell:

```bash
sh "<repo-root>/scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root>
```

macOS or Linux with PowerShell 7 (`pwsh`) if available:

```bash
pwsh -File ./scripts/install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
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

macOS or Linux native shell examples:

```bash
sh "<repo-root>/scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root> --dry-run
sh "<repo-root>/scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root> --backup
sh "<repo-root>/scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root> --backup --force
sh "<repo-root>/scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root> --check-dependencies
```

macOS or Linux PowerShell examples:

```bash
pwsh -File ./scripts/install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -DryRun
pwsh -File ./scripts/install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup
pwsh -File ./scripts/install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup -Force
pwsh -File ./scripts/install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -CheckDependencies
```

You can also install the three-stage execution bundle:

```powershell
.\scripts\install-cursor.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

macOS or Linux with native shell:

```bash
sh "<repo-root>/scripts/install-cursor.sh" --bundle superpowers-openspec-execution --project-root <project-root>
```

macOS or Linux with PowerShell 7 (`pwsh`) if available:

```bash
pwsh -File ./scripts/install-cursor.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
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

macOS or Linux with native shell:

```bash
sh "<repo-root>/scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root>
```

macOS or Linux with PowerShell 7 (`pwsh`) if available:

```bash
pwsh -File ./scripts/install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
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

macOS or Linux native shell examples:

```bash
sh "<repo-root>/scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --dry-run
sh "<repo-root>/scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --backup
sh "<repo-root>/scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --backup --force
sh "<repo-root>/scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --check-dependencies
```

macOS or Linux PowerShell examples:

```bash
pwsh -File ./scripts/install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -DryRun
pwsh -File ./scripts/install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup
pwsh -File ./scripts/install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -Backup -Force
pwsh -File ./scripts/install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -CheckDependencies
```

You can also install the three-stage execution bundle:

```powershell
.\scripts\install-claude-code.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

macOS or Linux with native shell:

```bash
sh "<repo-root>/scripts/install-claude-code.sh" --bundle superpowers-openspec-execution --project-root <project-root>
```

macOS or Linux with PowerShell 7 (`pwsh`) if available:

```bash
pwsh -File ./scripts/install-claude-code.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
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
- [Memory guide](MEMORY.md)
- [Chinese memory guide](MEMORY.cn.md)
- [Verification guide](VERIFY.md)
- [Chinese verification guide](VERIFY.cn.md)
- [Source workflow overview](team-skills/README.md)
- [Source workflow installation notes](team-skills/INSTALL.md)
