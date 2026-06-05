# Superpowers + OpenSpec Team Skills

Structured workflow packs for AI coding assistants, with built-in conversation memory, project memory, and learning-oriented collaboration patterns.

This repository helps teams stop agents from jumping straight into code. It provides reusable workflows for clarification, spec writing, implementation, verification, archive, and optional repo-persisted memory, so AI coding support can become a durable collaboration capability instead of a one-off chat response.

Important: these workflows are explicit opt-in. They should run only when the user names the workflow or when repository policy requires it.

Chinese readers: [Chinese README](README.cn.md)

## Start Here

Use this README in three layers:

1. Decide whether you need this repository at all.
2. Choose one workflow family and one target tool.
3. Follow the matching install and activation path.

If you only need the fastest orientation, read these sections first:

- [What This Repository Is](#what-this-repository-is)
- [Workflow Packs](#workflow-packs)
- [How To Choose](#how-to-choose)
- [Quick Start](#quick-start)
- [Task Confirmation and Continuations](#task-confirmation-and-continuations)
- [Installing Multiple Bundles](#installing-multiple-bundles)

## At A Glance

| Need | Use |
| --- | --- |
| One end-to-end delivery workflow | `openspec-superpowers` |
| Explore first, spec second, build third | `superpowers-openspec-superpowers` |
| Superpowers-only implementation discipline | `superpowers-feature` |
| OpenSpec artifacts only | `openspec-feature` |
| After delivery, preserve lessons, update project memory, and help the next session resume cleanly | `superpowers-learning` |

## Choose By Tool

| Tool | Install shape | Best activation pattern | Main caveat |
| --- | --- | --- | --- |
| Codex | `.codex/skills/` | Explicit skill name such as `$openspec-superpowers-workflow` | Multiple bundles are usually safe |
| OpenCode | `.opencode/skills/` or `~/.config/opencode/skills/` | Explicit skill request such as `Use the openspec-superpowers-workflow skill` | Refresh OpenCode if newly installed skills do not appear immediately |
| Cursor | `AGENTS.md` + `.cursor/rules/` in the target repo | Explicit text request in chat | Mixed bundles can create routing ambiguity |
| Claude Code | `CLAUDE.md` + `.claude/commands/` in the target repo | Explicit slash command | `CLAUDE.md` follows the most recent install |

## Choose By Outcome

If your goal is primarily:

- shipping a feature with one workflow: go to [openspec-superpowers](#workflow-packs)
- exploring before locking requirements: go to [superpowers-openspec-superpowers](#workflow-packs)
- preserving session outcomes after delivery so the next session can resume with the right context: go to [Use memory when you need cross-session continuity](#4-use-memory-when-you-need-cross-session-continuity) and `superpowers-learning`
- understanding installation differences by tool: go to [Tool-Specific Behavior](#tool-specific-behavior)
- avoiding wrong bundle and workflow combinations: go to [Installing Multiple Bundles](#installing-multiple-bundles)

## Common Mistakes First

Before installing or testing a workflow, keep these rules in mind:

- Do not treat these workflows as always-on defaults. They are explicit opt-in.
- Install the bundle that matches the workflow you plan to trigger.
- In Cursor, repository rules are part of the runtime. Reopen the project after installing or replacing a bundle.
- In the two combined workflows, `tasks.md` confirmation is not the same thing as OpenSpec apply. The workflow should pause, wait for confirmation, then continue with the defined handoff.

## What This Repository Is

This is not just a prompt collection. It is a workflow skill system for AI coding assistants.

Its value is in turning AI coding from a temporary conversation into a repeatable, traceable, and reusable way of working:

- workflow: guide the assistant to understand first, then implement, instead of editing code immediately
- memory: carry project background, current state, key decisions, and known issues across sessions
- learning: capture lessons after meaningful work so useful patterns can be reused later
- collaboration boundaries: give both individual developers and project teams a more stable way to work with AI

If you want AI to do more than generate a few code snippets, and instead participate in clarification, specification, implementation, verification, archive, and knowledge capture, this repository is designed for that style of engineering collaboration.

This project has two layers:

- `team-skills/`: source workflow definitions maintained by the project
- `dist/`: installable bundles adapted for Codex, OpenCode, Cursor, and Claude Code

If you are using the project, start with `dist/` and `scripts/`.
Do not copy a single entry workflow out of `team-skills/` unless you are intentionally extending the source definitions.

## Who This Is For

This repository works for both individual developers and project teams:

- individual developers who want AI to remember project context instead of re-explaining everything every session
- small teams that want shared workflow discipline, consistent terminology, and clearer delivery boundaries with AI
- evolving codebases that need AI to inherit prior decisions and stage status across longer-running work

Use this repository if you want your AI coding tool to:

- clarify before implementation
- lock behavior before risky changes
- implement with tests and verification
- finish with a clean archive or closeout step
- preserve durable project context across sessions
- build up longer-term memory and reusable lessons over time

## Common Scenarios

- solo project work where you want AI to remember the project background, current phase, and latest progress
- feature delivery where you want AI to sort out requirements and specs before coding
- maintenance in older or more complex repositories where AI should understand first and modify second
- team collaboration where different people should get more consistent workflow behavior and output structure from AI
- knowledge capture where decisions, lessons learned, and stable patterns should remain available for future sessions

## Workflow Packs

Five workflow families are included:

- `openspec-superpowers`: one end-to-end flow from clarification through verification
- `superpowers-openspec-superpowers`: start wide with Superpowers, lock the agreed truth with OpenSpec, then come back to Superpowers to build, verify, and archive with confidence
- `superpowers-feature`: Superpowers-only design, planning, TDD, and verification
- `superpowers-learning`: not a primary delivery workflow, but a post-delivery enhancement layer used after other workflows to update project memory, preserve durable lessons, and help the next session pick up from the right state
- `openspec-feature`: create OpenSpec proposal, design, specs, and tasks before implementation

Source workflow docs:

- [OpenSpec + Superpowers Workflow](team-skills/openspec-superpowers-workflow/README.md)
- [Superpowers -> OpenSpec -> Superpowers Workflow](team-skills/superpowers-openspec-superpowers-workflow/README.md)
- [Superpowers Feature Workflow](team-skills/superpowers-feature-workflow/README.md)
- [Superpowers Learning Workflow](team-skills/superpowers-learning-workflow/README.md)
- [OpenSpec Feature Workflow](team-skills/openspec-feature-workflow/README.md)

Each source workflow also includes a machine-readable `workflow.yaml`.

## How To Choose

- Choose `openspec-superpowers` when you want one general workflow for non-trivial feature delivery.
- Choose `superpowers-openspec-superpowers` when you want to explore first, lock the truth second, then come back and build the change with more confidence and less chaos.
- Choose `superpowers-feature` when you want disciplined engineering without OpenSpec change artifacts.
- Choose `superpowers-learning` when delivery is already done and you want to write back the durable outcomes of this session so the next session can resume with the right context.
- Choose `openspec-feature` when you only want change artifacts before implementation begins.

`superpowers-learning` needs a different mental model from the delivery workflows above. It is best treated as an enhancement layer that follows `superpowers-feature`, `superpowers-openspec-superpowers`, or `openspec-superpowers` after meaningful work is finished. Its job is to review what happened in the session, separate stable project facts from temporary task noise, update `.superpowers-memory/`, and capture reusable lessons that may later become skills, checklists, or knowledge-base material.

Recommended long-running pattern:

1. Run one delivery workflow.
2. Finish implementation and verification.
3. Run `superpowers-learning` to write stable facts, current state, session notes, and reusable lessons back into project memory.

## Explicit Activation

These workflows should activate only when:

- the user explicitly names the workflow
- the user explicitly asks for this workflow style
- repository policy explicitly requires it

They should not become the default background behavior of your AI tool.

Example:

```text
Use $superpowers-openspec-superpowers-workflow for this feature.
```

## Quick Start

### 1. Pick the right install target

- Codex: install a bundle into `.codex/skills/`
- OpenCode: install a bundle into `.opencode/skills/` or your OpenCode config skill directory
- Cursor: install repository rules and `AGENTS.md` into the target project
- Claude Code: install command files and `CLAUDE.md` into the target project

### 2. Install a bundle

Match the installed bundle to the workflow you plan to activate. Do not install `openspec-superpowers` and then try to trigger `superpowers-openspec-superpowers`, or the runtime rules may not match the prompt.

If you want the single combined OpenSpec-first workflow, install `openspec-superpowers`.

Windows PowerShell examples:

```powershell
.\scripts\install-codex.ps1 -Bundle openspec-superpowers
.\scripts\install-opencode.ps1 -Bundle openspec-superpowers
.\scripts\install-cursor.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root>
```

macOS or Linux examples:

```bash
sh "./scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex"
sh "./scripts/install-opencode.sh" --bundle openspec-superpowers --opencode-home "$HOME/.config/opencode"
sh "./scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root>
sh "./scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root>
```

If the target project already has a `CLAUDE.md` and you want to merge the bundle instructions into it instead of replacing it, use:

```powershell
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -MergeClaudeMd
```

```bash
sh "./scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --merge-claude-md
```

If you want the Superpowers -> OpenSpec -> Superpowers workflow, install `superpowers-openspec-superpowers`.

Windows PowerShell examples:

```powershell
.\scripts\install-codex.ps1 -Bundle superpowers-openspec-superpowers
.\scripts\install-opencode.ps1 -Bundle superpowers-openspec-superpowers
.\scripts\install-cursor.ps1 -Bundle superpowers-openspec-superpowers -ProjectRoot <project-root>
.\scripts\install-claude-code.ps1 -Bundle superpowers-openspec-superpowers -ProjectRoot <project-root>
```

macOS or Linux examples:

```bash
sh "./scripts/install-codex.sh" --bundle superpowers-openspec-superpowers --codex-home "$HOME/.codex"
sh "./scripts/install-opencode.sh" --bundle superpowers-openspec-superpowers --opencode-home "$HOME/.config/opencode"
sh "./scripts/install-cursor.sh" --bundle superpowers-openspec-superpowers --project-root <project-root>
sh "./scripts/install-claude-code.sh" --bundle superpowers-openspec-superpowers --project-root <project-root>
```

If the target project already has a `CLAUDE.md` and you want to merge the bundle instructions into it instead of replacing it, use:

```powershell
.\scripts\install-claude-code.ps1 -Bundle superpowers-openspec-superpowers -ProjectRoot <project-root> -MergeClaudeMd
```

```bash
sh "./scripts/install-claude-code.sh" --bundle superpowers-openspec-superpowers --project-root <project-root> --merge-claude-md
```

### 3. Activate the workflow explicitly

Activate the same workflow family that you installed above.

- Codex:

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

- OpenCode:

```text
Use the openspec-superpowers-workflow skill to run this feature from clarification through verification.
```

- Cursor:

```text
Use the superpowers-openspec-superpowers workflow for this feature.
```

- Claude Code:

```text
/superpowers-openspec-superpowers-workflow
<describe the feature request>
```

For Cursor, `superpowers-openspec-superpowers` is routed by repository rules after installation. It is not a native slash command, so the project must already contain the matching `AGENTS.md` and `.cursor/rules` files from the `superpowers-openspec-superpowers` bundle.

### 4. Use memory when you need cross-session continuity

Optional memory scaffold:

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot <project-root>
```

Optional tool integration:

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool all -ProjectRoot <project-root>
```

When a project contains `.superpowers-memory/`, workflows can read and update files such as:

- `PROJECT_CONTEXT.md`
- `CURRENT_STATE.md`
- `DECISIONS.md`
- `KNOWN_FAILURES.md`
- `session-journal/`

Use `superpowers-learning` after meaningful work if you want to write back the durable outcomes of the session, update project memory, and make the next session easier to resume.

## Requirements

- OpenSpec CLI for workflows that create or inspect OpenSpec changes
- A real project repository where the agent can write docs, plans, code, tests, and verification output
- Optional: a `.superpowers-memory/` folder for repo-persisted memory

## Repository Layout

```text
team-skills/   source workflow definitions
dist/          tool-specific distributable bundles
scripts/       install and maintenance scripts
templates/     memory templates and helper content
docs/          supporting documentation
```

## Build vs Install

There are two kinds of scripts in this repository:

- `install-*`: for end users installing bundles into AI tools or target projects
- `build-dist.ps1`: for maintainers rebuilding and validating `dist/`

If you change workflow sources or bundle structure, run:

```powershell
.\scripts\build-dist.ps1
```

## Tool Support

- Codex: best fit for native skill-based usage
- OpenCode: native skill-style usage through `.opencode/skills/` or the configured OpenCode skills directory
- Cursor: uses repository rules and `AGENTS.md`
- Claude Code: uses command files and `CLAUDE.md`
- Other tools: can be added later by creating new adapters under `dist/`

## Advanced Usage

### Installer Notes

Native shell installers support these common flags:

- `--bundle <name>`: choose which bundle to install
- `--project-root <path>`: set the target repository root for Cursor, Claude Code, or memory installation
- `--codex-home <path>`: set the Codex home directory for Codex installs
- `--opencode-home <path>`: set the OpenCode config directory for OpenCode installs
- `--dry-run`: preview what would be written without copying files
- `--backup`: back up existing target files before overwrite
- `--merge-claude-md`: for Claude Code installs, merge the bundle `CLAUDE.md` into an existing project `CLAUDE.md` instead of replacing it
- `--force`: skip overwrite confirmation
- `--check-dependencies`: check runtime requirements such as `openspec` without installing files

PowerShell installers expose the same ideas through parameters such as `-Bundle`, `-ProjectRoot`, `-CodexHome`, `-OpenCodeHome`, `-DryRun`, `-Backup`, `-MergeClaudeMd`, `-Force`, and `-CheckDependencies`.

Available installer scripts:

- `scripts/install-codex.sh`
- `scripts/install-codex.ps1`
- `scripts/install-opencode.sh`
- `scripts/install-opencode.ps1`
- `scripts/install-cursor.sh`
- `scripts/install-cursor.ps1`
- `scripts/install-claude-code.sh`
- `scripts/install-claude-code.ps1`
- `scripts/install-superpowers-memory.sh`
- `scripts/install-superpowers-memory.ps1`
- `scripts/install-superpowers-memory-integration.sh`
- `scripts/install-superpowers-memory-integration.ps1`

### Tool-Specific Behavior

- Codex installs bundles into `.codex/skills/` and is the closest fit for native skill-style usage.
- OpenCode installs bundles into `.opencode/skills/` or the configured OpenCode skills directory and can load the same `SKILL.md` packages natively.
- Cursor installs repository rules plus `AGENTS.md`. Use explicit text requests in chat instead of expecting a native slash command.
- Claude Code installs `.claude/commands/` files plus `CLAUDE.md`. Prefer invoking the generated slash command so the command file is applied consistently.

### Installing Multiple Bundles

Multiple bundles are supported, but the behavior is different in each tool.

- Codex: lowest risk. Bundles install as separate skill directories, so `openspec-superpowers-workflow` and `superpowers-openspec-superpowers-workflow` can coexist. The main requirement is to explicitly name the workflow you want.
- Claude Code: medium risk. Slash-command files under `.claude/commands/` can coexist, but `CLAUDE.md` is a shared top-level file and the most recently installed bundle will overwrite it.
- Cursor: highest risk. Bundle installs copy both `AGENTS.md` and `.cursor/rules/` into the target project. `AGENTS.md` is overwritten by the last install, while rule files may accumulate side by side. That means multiple bundles can coexist, but routing behavior depends on the final combination of files in the project.

Recommended practice:

- For Codex, installing multiple bundles is generally fine.
- For Claude Code, multiple bundles are workable if you mainly rely on explicit slash commands and understand that `CLAUDE.md` follows the last installation.
- For Cursor, prefer one primary workflow bundle per project unless you are intentionally managing the final `AGENTS.md` and `.cursor/rules/` layout yourself.

Recommended activation examples:

- Codex: `Use $openspec-superpowers-workflow to run this feature from clarification through verification.`
- OpenCode: `Use the openspec-superpowers-workflow skill to run this feature from clarification through verification.`
- Cursor: `Use the superpowers-openspec-superpowers workflow for this feature.`
- Claude Code: `/superpowers-openspec-superpowers-workflow`

For Cursor, if the project has multiple workflow bundles, older rule files, or any routing ambiguity, use this stricter example:

```text
Use $superpowers-openspec-superpowers-workflow for this feature.

Start with Superpowers exploration first. Do not start with openspec-propose or the default OpenSpec workflow.
Then move to OpenSpec to generate proposal, design, spec, and tasks.
After OpenSpec tasks are generated, show them to me and wait for my confirmation before implementation.
Do not suggest /opsx:apply.
```

### Task Confirmation and Continuations

The two combined workflows, `openspec-superpowers-workflow` and `superpowers-openspec-superpowers-workflow`, support a staged handoff after OpenSpec task generation.

`task_confirmation_mode` controls what happens after OpenSpec `tasks.md` is generated:

- `required`: always stop and wait for user confirmation
- `optional`: show the task list and wait by default, unless the user explicitly asks for direct execution
- `off`: continue directly into implementation planning without pausing

Default behavior is `optional`.

In the default flow:

1. Generate and review OpenSpec artifacts.
2. Show `tasks.md` and wait for confirmation.
3. After confirmation, pause again and ask whether to continue execution development.
4. After execution and verification, optionally pause again for review or archive continuation.

Useful continuation commands:

- `continue-dev`
- `continue-review`
- `continue-archive`

If your environment supports Chinese trigger text, the corresponding shortcuts may also be available there, but the English commands above are the safest cross-environment examples.

Suggested prompts:

```text
After OpenSpec tasks are generated, show them to me and wait for my confirmation before implementation.
```

```text
After I confirm OpenSpec tasks, ask whether to continue execution development.
```

### Bundle Model

This repository distributes user-facing workflow packs as bundles, not as single folders copied out of the source tree.

Current bundle families:

- `dist/codex/bundles/`
- `dist/cursor/bundles/`
- `dist/claude-code/bundles/`

Each bundle contains only the files expected by the target tool.

### Maintainer Context

The source workflows under `team-skills/` are intentionally more modular than the installable bundles.

That distinction exists because:

- source workflows are for maintainers
- bundles are for end users

If you change source workflows, metadata, or bundle structure conventions, rebuild `dist/` with:

```powershell
.\scripts\build-dist.ps1
```

## Documentation

- [English README](README.md)
- [Chinese README](README.cn.md)
- [English Memory Guide](MEMORY.md)
- [Chinese Memory Guide](MEMORY.cn.md)
- [English Verification Guide](VERIFY.md)
- [Chinese Verification Guide](VERIFY.cn.md)
- [English Source Workflow Overview](team-skills/README.md)
- [Chinese Source Workflow Overview](team-skills/README.cn.md)
- [English Source Workflow Install Notes](team-skills/INSTALL.md)
- [Chinese Source Workflow Install Notes](team-skills/INSTALL.cn.md)
- [English Source Workflow Usage Guide](team-skills/USAGE.md)
- [Chinese Source Workflow Usage Guide](team-skills/USAGE.cn.md)

## Community

- [CONTRIBUTING.md](CONTRIBUTING.md)
- [SECURITY.md](SECURITY.md)
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
- [CHANGELOG.md](CHANGELOG.md)
