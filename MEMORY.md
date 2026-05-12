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
  USER_PROFILE.md
  AGENT_NOTES.md
  LEARNING_BACKLOG.md
  SESSION_CLOSE_CHECKLIST.md
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

### `USER_PROFILE.md`

Use this file for durable user preferences that affect how the assistant should communicate or collaborate, but that are not project facts.

### `AGENT_NOTES.md`

Use this file for durable execution reminders about this repository, such as repeated operational pitfalls or agent-side quality reminders.

### `LEARNING_BACKLOG.md`

Use this file for reusable lessons that may deserve a future workflow, skill, checklist, project rule, or validation script.

This file is for patterns that look reusable across future sessions, not for one-off notes.

### `SESSION_CLOSE_CHECKLIST.md`

Use this file as the standard session-close reminder before claiming memory work is complete.

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
3. read `DECISIONS.md`, `KNOWN_FAILURES.md`, `VERIFICATION_BASELINE.md`, `TEAM_PREFERENCES.md`, `USER_PROFILE.md`, and `AGENT_NOTES.md` when they exist
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
- put durable user preferences in `USER_PROFILE.md`
- put agent execution reminders in `AGENT_NOTES.md`
- put per-session notes in `session-journal/`

Do not mix all of them into one file.

### Rule 2: Keep journal entries short

A session journal is not a full retrospective. Keep it concise and useful for the next session.

### Rule 3: Capture sources and confidence for important entries

For durable entries, require:

- id
- review_after
- source
- status
- confidence
- last updated date

Do not mark an entry as `verified` if `source` is empty.

### Rule 4: Update memory after meaningful work

Good times to update memory:

- after a design is approved
- after implementation and verification
- after a major decision
- after discovering a repeated failure pattern
- after confirming a verification baseline
- after archiving a completed OpenSpec change
- before ending a session that changed durable memory

### Rule 5: Do not use memory as auto-activation permission

Memory helps restore context. It does not mean Superpowers workflows should auto-activate.

Workflow activation is still explicit opt-in.

### Rule 6: Prefer correction over accumulation

If old memory is wrong, fix or replace it. Do not keep piling contradictory notes on top of each other.

### Rule 7: Treat backlog items as candidates, not automatic rules

A reusable lesson should usually show repeated value before it becomes a permanent rule, checklist, workflow step, or skill.

### Rule 8: Use the session-close checklist before claiming memory work is done

Before ending a meaningful session, review `SESSION_CLOSE_CHECKLIST.md` and confirm:

- current state is current
- a journal entry exists when needed
- durable entries include required metadata
- any promotion candidate has enough evidence
- validator has been run when memory changed

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
6. review `SESSION_CLOSE_CHECKLIST.md` before claiming memory updates are complete
7. run `scripts/validate-superpowers-memory.ps1` after meaningful updates
8. use `scripts/search-superpowers-memory.ps1` to confirm whether a decision, failure pattern, or lesson already exists
9. use `scripts/suggest-superpowers-memory-updates.ps1` when the correct memory target is unclear at session close
10. use `scripts/run-superpowers-memory-closeout.ps1` as a standard closeout helper when you want checklist + suggestions + optional validation in one step
11. reopen the project in your tool when instruction files change

### What To Do Right After Installation

Installing memory integration does not mean memory is already being used in a meaningful way. A practical next step is:

1. confirm the project contains `.superpowers-memory/`
2. confirm the tool-level integration file exists for your tool
3. reopen or refresh the project in the tool so the new instruction files are loaded
4. add at least a few lines to `PROJECT_CONTEXT.md` and `CURRENT_STATE.md`
5. start a new session in the tool
6. begin work normally and let the tool read the repo memory first

If the memory files are empty, memory can still be considered enabled, but it will not help much yet because there is little context to recover.

### Minimal First-Time Setup Example

You do not need to fully document the project before memory becomes useful. A very small amount of content is enough to start:

`PROJECT_CONTEXT.md`

```md
# Project Context
- hobby-map is a map-based hobby discovery project.
- Main stack: Vue 3 + Spring Boot + MySQL.
- Core modules: map view, point management, user favorites.
```

`CURRENT_STATE.md`

```md
# Current State
- Current focus: fixing map marker clustering and detail panel behavior.
- Recently done: integrated the basic point list and detail fetch API.
- Next step: verify marker click behavior and mobile layout.
```

This is enough for later sessions to start with a real project summary instead of asking for all background again.

### How To Tell Memory Is Actually In Use

After installation, memory is being used more concretely when all of these are true:

1. `.superpowers-memory/` exists in the project
2. the tool integration file exists
3. the project has been reopened or refreshed after installation
4. a new session has started
5. the memory files contain useful content

Typical signs:

- the tool asks fewer repeated background questions
- it can refer to current project state from `CURRENT_STATE.md`
- it can pick up durable decisions or constraints from memory files

Memory enablement does not mean workflow auto-activation. The tool may read memory at session start while still requiring explicit workflow invocation where the workflow rules require it.

### Recommended Default For Open-Source Users

Across tools, the practical pattern is simple: let new sessions read repo memory first, and treat memory writes as an explicit closeout action rather than something ordinary chat does automatically.

For most open-source users, the best default is:

1. work normally in your tool
2. let the tool read repo memory at the start of a new session
3. after meaningful work, explicitly run a memory closeout step

The recommended default closeout entry is `superpowers-learning-workflow` because it is easier to adopt than the larger delivery workflows and is directly focused on preserving current state, durable lessons, and short session outcomes.

Recommended prompt:

```text
Use $superpowers-learning-workflow to capture what this session taught us and update the project memory.
```

This default works well across tools:

- in Cursor, use the workflow name in chat after meaningful work
- in Codex, use the workflow name in chat after meaningful work
- in Claude Code, prefer the generated slash command when that workflow bundle is installed

If `superpowers-learning-workflow` is not installed or you want a lighter fallback, use the closeout helper script:

```powershell
.\scripts\run-superpowers-memory-closeout.ps1 -ProjectRoot <project-root> -ChangedPaths "src","docs" -Signals "decision","validation" -RunValidator
```

Use the larger workflows only when you also want their full engineering discipline, not just memory capture:

- `superpowers-feature-workflow`
- `openspec-superpowers-workflow`
- `superpowers-openspec-execution-workflow`

### Recommended Operating Modes

There are three practical ways to use memory. Choose one and stay consistent.

#### Mode 1: Lightweight Default

Best for most open-source users.

1. keep `PROJECT_CONTEXT.md` and `CURRENT_STATE.md` current
2. start new sessions normally so the tool can read memory
3. after meaningful work, run `superpowers-learning-workflow`
4. run validation if memory changed

#### Mode 2: Script-Assisted Closeout

Best when you want reminder-style support without adopting a full workflow.

1. work normally
2. run `scripts/run-superpowers-memory-closeout.ps1`
3. update the suggested memory targets
4. run `scripts/validate-superpowers-memory.ps1`

This mode is lighter, but it will not write memory on its own.

#### Mode 3: Full Workflow Delivery

Best when the team also wants design gates, planning, verification discipline, and memory alignment in one operating style.

Typical options:

- `superpowers-feature-workflow`
- `openspec-superpowers-workflow`
- `superpowers-openspec-execution-workflow`

Choose this mode for structured delivery. Do not choose it if your only goal is "please remember what happened this session."

### Concrete Example: Cursor

For a Cursor project at `D:\ys\ysProjects\Hobby\hobby-map`, a practical flow looks like this:

1. install the scaffold

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot D:\ys\ysProjects\Hobby\hobby-map
```

2. install Cursor integration

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool cursor -ProjectRoot D:\ys\ysProjects\Hobby\hobby-map
```

3. verify the expected files exist

```powershell
Test-Path "D:\ys\ysProjects\Hobby\hobby-map\.superpowers-memory\PROJECT_CONTEXT.md"
Test-Path "D:\ys\ysProjects\Hobby\hobby-map\.cursor\rules\superpowers-memory.mdc"
```

4. add a short project summary to `PROJECT_CONTEXT.md` and `CURRENT_STATE.md`
5. reopen Cursor or refresh the project
6. start a new chat session
7. ask for real project work, for example:

```text
Please use the repo memory first, then help me decide the next priority for hobby-map.
```

That is the point where memory becomes operational in day-to-day use.

### Concrete Example: Codex

For Codex, the main difference is that project instructions are loaded from `AGENTS.md`, and after installing or changing bundled skills or project instructions you should reopen or refresh the project so Codex can rediscover them.

A practical flow looks like this:

1. install the scaffold

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot D:\ys\ysProjects\Hobby\hobby-map
```

2. install Codex integration

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool codex -ProjectRoot D:\ys\ysProjects\Hobby\hobby-map
```

3. verify the expected files exist

```powershell
Test-Path "D:\ys\ysProjects\Hobby\hobby-map\.superpowers-memory\PROJECT_CONTEXT.md"
Select-String -Path "D:\ys\ysProjects\Hobby\hobby-map\AGENTS.md" -Pattern "superpowers-memory:start"
```

4. add a short project summary to `PROJECT_CONTEXT.md` and `CURRENT_STATE.md`
5. reopen or refresh the project in Codex
6. start a new session
7. ask for real project work, for example:

```text
Please read the repo memory first, then help me continue the current hobby-map work.
```

For Codex, this reopen step matters because the tool needs to pick up the updated project instructions before the new session begins.

### Concrete Example: Claude Code

For Claude Code, memory integration can coexist with workflow bundles, but workflow activation is more reliable when you use the generated slash command instead of relying only on natural-language routing.

A practical flow looks like this:

1. install the scaffold

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot D:\ys\ysProjects\Hobby\hobby-map
```

2. install Claude Code integration

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool claude-code -ProjectRoot D:\ys\ysProjects\Hobby\hobby-map
```

3. verify the expected files exist

```powershell
Test-Path "D:\ys\ysProjects\Hobby\hobby-map\.superpowers-memory\PROJECT_CONTEXT.md"
Select-String -Path "D:\ys\ysProjects\Hobby\hobby-map\CLAUDE.md" -Pattern "superpowers-memory:start"
```

4. add a short project summary to `PROJECT_CONTEXT.md` and `CURRENT_STATE.md`
5. reopen or refresh the project in Claude Code
6. start a new session
7. when using a bundled workflow, prefer the generated slash command so Claude Code reads the command file and applies the workflow gates consistently
8. ask for real project work, for example:

```text
/superpowers-feature
Continue hobby-map using the existing repo memory and current project state.
```

If you are only relying on memory and not activating a workflow bundle, a normal new session is still enough for Claude Code to read repo memory. The slash-command recommendation is specifically about reliable workflow activation.

### Recommended Session-Close Habit

After meaningful work:

1. update `CURRENT_STATE.md` if the active focus changed
2. add durable entries to `DECISIONS.md`, `KNOWN_FAILURES.md`, or `VERIFICATION_BASELINE.md` when needed
3. add a short note under `session-journal/`
4. run validation

```powershell
.\scripts\validate-superpowers-memory.ps1 -ProjectRoot <project-root>
```

If you want one standard closeout command instead of doing this manually:

```powershell
.\scripts\run-superpowers-memory-closeout.ps1 -ProjectRoot <project-root> -ChangedPaths "src","docs" -Signals "decision","validation" -RunValidator
```

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
Test-Path "<project-root>\\.superpowers-memory\\USER_PROFILE.md"
Test-Path "<project-root>\\.superpowers-memory\\AGENT_NOTES.md"
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

### Memory search

```powershell
.\scripts\search-superpowers-memory.ps1 -ProjectRoot <project-root> -Query "validator" -Type decisions
```

### Memory update suggestion

```powershell
.\scripts\suggest-superpowers-memory-updates.ps1 -ProjectRoot <project-root> -ChangedPaths "scripts/validate-superpowers-memory.ps1","docs/memory-enhancement-design.cn.md" -Signals "decision","validation","reusable"
```

### Memory closeout helper

```powershell
.\scripts\run-superpowers-memory-closeout.ps1 -ProjectRoot <project-root> -ChangedPaths "scripts/validate-superpowers-memory.ps1","docs/memory-learning-dialogue.cn.md" -Signals "decision","validation","reusable" -RunValidator
```

## Best Fit

This memory model works best when:

- the project has repeated sessions over days or weeks
- the team wants AI to remember architecture and recent decisions
- the team wants memory stored in the repository, not in a private external system
- the team wants durable lessons to evolve into explicit reusable artifacts over time

It is intentionally lightweight. It does not try to be a full task system or a hidden proprietary memory store.
