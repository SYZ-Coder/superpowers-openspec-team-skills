# Superpowers Memory Guide

This document explains how the optional Superpowers memory feature works, how to enable it, how to use it, and how to turn it off.

## What It Is

Superpowers memory is a repo-persisted context layer for Superpowers-based workflows.

Instead of relying on a single chat session to remember project details, it stores useful context in the repository itself:

- stable project facts
- current working state
- key decisions
- known failure patterns
- verification expectations
- reusable lessons
- short session summaries

That lets later sessions recover context from the repository instead of starting from blank context every time.

## Default Behavior

This feature is not enabled by default.

Installing this repository or its workflow bundles does not automatically turn on:

- Superpowers memory
- memory file reads
- memory file writes
- learning capture
- workflow auto-activation

Memory only becomes active when:

1. the project has `.superpowers-memory/`
2. the relevant integration files are installed, or the workflow explicitly reads memory
3. the user explicitly invokes the related workflow when workflow activation is required

In other words:

- install makes the capability available
- explicit setup enables memory
- explicit invocation enables workflows

## What Gets Stored

When memory is enabled, the project can use this structure:

```text
.superpowers-memory/
  PROJECT_CONTEXT.md
  CURRENT_STATE.md
  DECISIONS.md
  KNOWN_FAILURES.md
  VERIFICATION_BASELINE.md
  TEAM_PREFERENCES.md
  LEARNING_BACKLOG.md
  memory-index.yaml
  session-journal/
```

### `PROJECT_CONTEXT.md`

Use this file for long-lived information:

- what the project does
- architecture notes
- working agreements
- known constraints

This file should change slowly.

### `CURRENT_STATE.md`

Use this file for the latest working context:

- what is in progress
- recent decisions
- open questions
- the next recommended step

This file should be updated when the current focus changes.

### `DECISIONS.md`

Use this file for important design or process decisions that should stay visible across sessions.

### `KNOWN_FAILURES.md`

Use this file for repeated failure modes, environment pitfalls, and recurring process traps.

### `VERIFICATION_BASELINE.md`

Use this file for verification commands or methods the team considers trustworthy.

### `TEAM_PREFERENCES.md`

Use this file for durable collaboration preferences and working agreements that future sessions should follow.

### `LEARNING_BACKLOG.md`

Use this file for reusable lessons that may deserve a future workflow, skill, checklist, project rule, or validation script.

This file is for patterns that look reusable across future sessions, not for one-off notes.

### `memory-index.yaml`

Use this file for memory health metadata and lightweight indexing such as freshness, stale counts, and backlog status.

### `session-journal/`

Use this folder for one short markdown note per meaningful session.

Typical journal entries should capture:

- what changed
- what was decided
- what was verified
- what should happen next

## How It Works

When a Superpowers-related workflow sees `.superpowers-memory/`, it should:

1. read `PROJECT_CONTEXT.md`
2. read `CURRENT_STATE.md`
3. read `DECISIONS.md` and `KNOWN_FAILURES.md` when they exist
4. read the newest session journal entries
5. use that context before asking the user to repeat project background
6. update the relevant memory files before ending a meaningful session
7. run memory validation before claiming completion when the workflow depends on memory quality

This applies to the Superpowers-related workflows in this repository, including:

- `superpowers-feature`
- `superpowers-openspec-execution`
- `openspec-superpowers`
- `superpowers-learning`

## Rules

Use these rules to keep memory useful instead of noisy.

### Rule 1: Keep stable facts separate from session notes

- put long-lived project knowledge in `PROJECT_CONTEXT.md`
- put current work state in `CURRENT_STATE.md`
- put lasting decisions in `DECISIONS.md`
- put repeated failure patterns in `KNOWN_FAILURES.md`
- put per-session notes in `session-journal/`

Do not mix all of them into one file.

### Rule 2: Keep journal entries short

A session journal is not a full retrospective. Keep it concise and useful for the next session.

### Rule 3: Capture sources and confidence for important entries

For durable entries, prefer recording:

- source
- status
- confidence
- last updated date

### Rule 4: Update memory after meaningful work

Good times to update memory:

- after a design is approved
- after implementation and verification
- after a major decision
- after discovering a repeated failure pattern
- after confirming a verification baseline
- after archiving a completed OpenSpec change

### Rule 5: Do not use memory as auto-activation permission

Memory helps restore context. It does not mean Superpowers workflows should auto-activate.

Workflow activation is still explicit opt-in.

### Rule 6: Prefer correction over accumulation

If old memory is wrong, fix or replace it. Do not keep piling contradictory notes on top of each other.

### Rule 7: Treat backlog items as candidates, not automatic rules

A reusable lesson should usually show repeated value before it becomes a permanent rule, checklist, workflow step, or skill.

## How To Enable It

There are two layers you can enable.

### 1. Install the memory scaffold

This creates the `.superpowers-memory/` folder in the target project:

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot <project-root>
```

### 2. Install tool-level memory integration

This updates project-level instruction files so supported tools read memory more naturally at session start:

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool all -ProjectRoot <project-root>
```

Or per tool:

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool codex -ProjectRoot <project-root>
.\scripts\install-superpowers-memory-integration.ps1 -Tool cursor -ProjectRoot <project-root>
.\scripts\install-superpowers-memory-integration.ps1 -Tool claude-code -ProjectRoot <project-root>
```

## How Users Should Use It

The simplest flow is:

1. install the memory scaffold
2. fill in `PROJECT_CONTEXT.md`
3. keep `CURRENT_STATE.md` current
4. add decisions, failure patterns, and verification rules when they become durable
5. let Superpowers-related workflows add short session notes
6. run `scripts/validate-superpowers-memory.ps1` after meaningful updates
7. reopen the project in your tool when instruction files change

## How To Turn It Off

You can disable memory at two levels as well.

### Option 1: Stop using the memory files

If `.superpowers-memory/` does not exist in the project, the workflows should simply skip memory behavior.

So the simplest disable path is to remove or rename:

```text
.superpowers-memory/
```

### Option 2: Remove project-level tool integration

If you no longer want Codex, Cursor, or Claude Code to read memory automatically from project instructions, remove the installed integration:

- remove the `superpowers-memory` block from `AGENTS.md`
- remove `.cursor/rules/superpowers-memory.mdc`
- remove the `superpowers-memory` block from `CLAUDE.md`

### Temporary off switch

You can also keep the files in the repo but stop using them operationally by telling the tool not to rely on memory for the current task.

## How To Verify It

After installation, verify:

### Memory scaffold

```powershell
Test-Path "<project-root>\\.superpowers-memory\\PROJECT_CONTEXT.md"
Test-Path "<project-root>\\.superpowers-memory\\CURRENT_STATE.md"
Test-Path "<project-root>\\.superpowers-memory\\session-journal"
```

### Codex integration

```powershell
Select-String -Path "<project-root>\\AGENTS.md" -Pattern "superpowers-memory:start"
```

### Cursor integration

```powershell
Test-Path "<project-root>\\.cursor\\rules\\superpowers-memory.mdc"
```

### Claude Code integration

```powershell
Select-String -Path "<project-root>\\CLAUDE.md" -Pattern "superpowers-memory:start"
```

### Memory validation

```powershell
.\scripts\validate-superpowers-memory.ps1 -ProjectRoot <project-root>
```

## Best Fit

This memory model works best when:

- the project has repeated sessions over days or weeks
- the team wants AI to remember architecture and recent decisions
- the team wants memory stored in the repository, not in a private external system
- the team wants durable lessons to evolve into explicit reusable artifacts over time

It is intentionally lightweight. It does not try to be a full task system or a hidden proprietary memory store.
