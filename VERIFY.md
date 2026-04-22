# Verify Installed Bundles

This document explains how to verify that a bundle has been installed correctly and is actually affecting tool behavior.

For a compact platform-by-platform script matrix, see [docs/CROSS_PLATFORM_TESTING.md](/D:/spring_AI/superpowers-openspec-team-skills/docs/CROSS_PLATFORM_TESTING.md).

Verification should happen at two levels:

1. installation verification: did the expected files land in the expected location?
2. runtime verification: did the tool actually pick up the workflow and behave differently?

In this document, `<repo-root>` means the local path of this repository on your machine.

## macOS or Linux Quick Checklist

If you are validating the shell installers on macOS or Linux, use this quick sequence first:

1. Confirm the script file exists:
   `ls "<repo-root>/scripts/install-codex.sh"`
2. Run a dry run with an absolute path:
   `sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --dry-run`
3. For OpenSpec bundles, check dependencies before install:
   `sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex" --check-dependencies`
4. Install the bundle:
   `sh "<repo-root>/scripts/install-codex.sh" --bundle openspec-superpowers --codex-home "$HOME/.codex"`
5. Verify the target file exists:
   `test -f "$HOME/.codex/skills/openspec-superpowers-workflow/SKILL.md" && echo OK`

Use the same pattern for other tools:

- Cursor:
  `sh "<repo-root>/scripts/install-cursor.sh" --bundle openspec-superpowers --project-root <project-root> --dry-run`
- Claude Code:
  `sh "<repo-root>/scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --dry-run`
- Memory scaffold:
  `sh "<repo-root>/scripts/install-superpowers-memory.sh" --project-root <project-root> --dry-run`
- Memory integration:
  `sh "<repo-root>/scripts/install-superpowers-memory-integration.sh" --tool all --project-root <project-root> --dry-run`

## 1. Verify Memory Scaffold

Install:

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot <project-root>
```

Verify the expanded scaffold:

```powershell
Test-Path "<project-root>\\.superpowers-memory\\PROJECT_CONTEXT.md"
Test-Path "<project-root>\\.superpowers-memory\\CURRENT_STATE.md"
Test-Path "<project-root>\\.superpowers-memory\\DECISIONS.md"
Test-Path "<project-root>\\.superpowers-memory\\KNOWN_FAILURES.md"
Test-Path "<project-root>\\.superpowers-memory\\VERIFICATION_BASELINE.md"
Test-Path "<project-root>\\.superpowers-memory\\TEAM_PREFERENCES.md"
Test-Path "<project-root>\\.superpowers-memory\\USER_PROFILE.md"
Test-Path "<project-root>\\.superpowers-memory\\AGENT_NOTES.md"
Test-Path "<project-root>\\.superpowers-memory\\LEARNING_BACKLOG.md"
Test-Path "<project-root>\\.superpowers-memory\\SESSION_CLOSE_CHECKLIST.md"
Test-Path "<project-root>\\.superpowers-memory\\memory-index.yaml"
Test-Path "<project-root>\\.superpowers-memory\\session-journal"
```

Expected result:

```text
True
True
True
True
True
True
True
True
True
True
True
True
```

Then run memory validation:

```powershell
.\scripts\validate-superpowers-memory.ps1 -ProjectRoot <project-root>
```

macOS or Linux with native shell:

```bash
sh "<repo-root>/scripts/validate-superpowers-memory.sh" --project-root <project-root>
```

Expected behavior:

- the script completes without errors for a fresh scaffold
- warnings are acceptable when the project has not yet accumulated real journal history
- the output clearly shows what is missing or stale
- `memory-index.yaml` is refreshed with the current health summary
- durable entries are checked for `id`, `source`, `review_after`, and overdue review windows

Cross-platform verification commands:

- Windows PowerShell:
  `.\scripts\validate-superpowers-memory.ps1 -ProjectRoot <project-root>`
- Linux or macOS:
  `sh "<repo-root>/scripts/validate-superpowers-memory.sh" --project-root <project-root>`
- Skip index write during inspection only:
  `sh "<repo-root>/scripts/validate-superpowers-memory.sh" --project-root <project-root> --skip-index-write`

Cross-platform notes:

- the shell scripts are native `sh` implementations and do not require `pwsh`
- file timestamp lookup supports both GNU `stat -c` and BSD `stat -f`
- date parsing falls back across GNU `date -d` and BSD `date -j` / `date -v`
- run the shell scripts on a real macOS or Linux machine, or inside a POSIX-compatible shell on Windows

To verify promotion draft generation, add one candidate in `LEARNING_BACKLOG.md` with:

- `status: ready_for_promotion`
- `suggested_artifact: checklist` or `rule` or `skill draft`

Then run:

```powershell
.\scripts\generate-superpowers-promotion-drafts.ps1 -ProjectRoot <project-root>
```

macOS or Linux with native shell:

```bash
sh "<repo-root>/scripts/generate-superpowers-promotion-drafts.sh" --project-root <project-root>
```

Expected behavior:

- a draft file appears under `.superpowers-memory/promotion-drafts/`
- existing drafts are not overwritten unless `-Force` is used

Cross-platform draft generation commands:

- Windows PowerShell:
  `.\scripts\generate-superpowers-promotion-drafts.ps1 -ProjectRoot <project-root>`
- Linux or macOS:
  `sh "<repo-root>/scripts/generate-superpowers-promotion-drafts.sh" --project-root <project-root>`
- Overwrite existing drafts:
  `sh "<repo-root>/scripts/generate-superpowers-promotion-drafts.sh" --project-root <project-root> --force`

To verify local memory search, run:

```powershell
.\scripts\search-superpowers-memory.ps1 -ProjectRoot <project-root> -Query "decision" -Type decisions
```

macOS or Linux with native shell:

```bash
sh "<repo-root>/scripts/search-superpowers-memory.sh" --project-root <project-root> --query "decision" --type decisions
```

Expected behavior:

- matching entries are listed with file paths
- `--type` narrows the search to a specific memory surface
- `--status` can narrow entry-based files such as decisions or backlog candidates
- `-RecentFirst` can sort results toward newer durable entries and journals
- `-SinceDays` can limit results to a recent time window
- `-Summary` can print a compact count-by-kind and count-by-status view before detailed results

To verify memory update suggestions, run:

```powershell
.\scripts\suggest-superpowers-memory-updates.ps1 -ProjectRoot <project-root> -ChangedPaths "scripts/validate-superpowers-memory.ps1","docs/memory-enhancement-design.cn.md" -Signals "decision","validation","reusable"
```

macOS or Linux with native shell:

```bash
sh "<repo-root>/scripts/suggest-superpowers-memory-updates.sh" --project-root <project-root> --changed-paths "scripts/validate-superpowers-memory.sh,docs/memory-enhancement-design.cn.md" --signals "decision,validation,reusable"
```

Expected behavior:

- suggested targets include `CURRENT_STATE.md` and `session-journal/`
- signal-specific targets such as `DECISIONS.md`, `VERIFICATION_BASELINE.md`, or `LEARNING_BACKLOG.md` appear when relevant
- the script acts as a closeout hint, not as an automatic writer

To verify the closeout helper, run:

```powershell
.\scripts\run-superpowers-memory-closeout.ps1 -ProjectRoot <project-root> -ChangedPaths "scripts/validate-superpowers-memory.ps1","docs/memory-learning-dialogue.cn.md" -Signals "decision","validation","reusable" -RunValidator
```

macOS or Linux with native shell:

```bash
sh "<repo-root>/scripts/run-superpowers-memory-closeout.sh" --project-root <project-root> --changed-paths "scripts/validate-superpowers-memory.sh,docs/memory-learning-dialogue.cn.md" --signals "decision,validation,reusable" --run-validator
```

Expected behavior:

- the checklist path is shown first
- memory update suggestions are listed next
- validator output appears when validation is requested
- the helper does not edit memory files on its own

## 2. Verify Memory Integration

Install:

```powershell
.\scripts\install-superpowers-memory-integration.ps1 -Tool all -ProjectRoot <project-root>
```

Verify:

```powershell
Select-String -Path "<project-root>\\AGENTS.md" -Pattern "superpowers-memory:start"
Test-Path "<project-root>\\.cursor\\rules\\superpowers-memory.mdc"
Select-String -Path "<project-root>\\CLAUDE.md" -Pattern "superpowers-memory:start"
```

Expected behavior:

- Codex project instructions include the managed memory block
- Cursor has a dedicated memory rule file
- Claude Code project instructions include the managed memory block

## 3. Codex

### Step 1: Check runtime dependencies

For bundles that depend on OpenSpec, run:

```powershell
.\scripts\install-codex.ps1 -Bundle superpowers-openspec-execution -CheckDependencies
```

### Step 2: Install the bundle

```powershell
.\scripts\install-codex.ps1 -Bundle superpowers-openspec-execution
```

### Step 3: Verify installed files

```powershell
Test-Path "$env:USERPROFILE\.codex\skills\superpowers-openspec-execution-workflow\SKILL.md"
```

If you installed memory integration for Codex, also verify:

```powershell
Select-String -Path "<project-root>\AGENTS.md" -Pattern "superpowers-memory:start"
```

### Step 4: Restart or refresh Codex

Codex must rediscover the installed skill before it can use it.

### Step 5: Verify runtime behavior

In Codex, send:

```text
Use $superpowers-openspec-execution-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```

Expected behavior:

- Codex does not jump straight into code
- it explores the request first
- it moves through OpenSpec artifact work before implementation
- it returns to implementation and verification after the spec is locked
- when memory is enabled, it reads repo memory before asking for repeated project background

### Also verify `superpowers-learning`

Install:

```powershell
.\scripts\install-codex.ps1 -Bundle superpowers-learning
```

Then invoke:

```text
Use $superpowers-learning-workflow to capture what this session taught us and update the project memory.
```

Expected behavior:

- Codex reflects on recent work instead of starting new implementation
- it updates the right memory surfaces when memory is enabled
- it can recommend promotion candidates from `LEARNING_BACKLOG.md`
- it runs memory validation when memory was updated

## 4. Cursor

### Step 1: Check runtime dependencies

```powershell
.\scripts\install-cursor.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root> -CheckDependencies
```

### Step 2: Install the bundle

```powershell
.\scripts\install-cursor.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

### Step 3: Verify installed files

```powershell
Test-Path "<project-root>\.cursor\rules\superpowers-openspec-execution-workflow.mdc"
Test-Path "<project-root>\AGENTS.md"
```

If you installed memory integration for Cursor, also verify:

```powershell
Test-Path "<project-root>\.cursor\rules\superpowers-memory.mdc"
```

### Step 4: Reopen the project in Cursor

Cursor should reload the project rules after the files are written.

### Step 5: Verify runtime behavior

In Cursor, send:

```text
Use the superpowers-openspec-execution workflow for this feature: first explore, then lock OpenSpec, then implement and verify, then archive the change.
```

Expected behavior:

- the agent behaves like it is following a staged workflow
- it does not skip directly to implementation
- it treats design and OpenSpec artifact work as explicit phases
- when memory is enabled, it reads the right memory files before asking repeated background questions

### Also verify `superpowers-learning`

Invoke:

```text
Use the superpowers-learning workflow to capture what this session taught us and update the project memory.
```

Expected behavior:

- Cursor switches into reflection rather than implementation
- it writes learning back into the expanded `.superpowers-memory/` structure
- it keeps durable facts separate from temporary notes
- it validates memory when the workflow updated it

## 5. Claude Code

### Step 1: Check runtime dependencies

```powershell
.\scripts\install-claude-code.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root> -CheckDependencies
```

### Step 2: Install the bundle

```powershell
.\scripts\install-claude-code.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

### Step 3: Verify installed files

```powershell
Test-Path "<project-root>\.claude\commands\superpowers-openspec-execution-workflow.md"
Test-Path "<project-root>\CLAUDE.md"
```

If you installed memory integration for Claude Code, also verify:

```powershell
Select-String -Path "<project-root>\CLAUDE.md" -Pattern "superpowers-memory:start"
```

### Step 4: Reopen the project in Claude Code

Claude Code should reload commands and project instructions after installation.

### Step 5: Verify runtime behavior

Invoke:

```text
/superpowers-openspec-execution-workflow
```

Then provide the feature request.

Expected behavior:

- the command is available
- Claude Code follows the staged workflow instead of jumping straight into implementation
- when memory is enabled, it reads repo memory before repeated discovery questions

### Also verify `superpowers-learning`

Invoke:

```text
/superpowers-learning-workflow
```

Expected behavior:

- the command is available
- Claude Code reflects on recent work instead of starting new implementation
- it updates the expanded memory structure when memory is enabled
- it runs memory validation when memory was updated

## 6. What Counts As Actually Working

A bundle is not considered fully verified just because the files exist.

The real signal is behavior:

- the tool recognizes the installed bundle
- the tool follows the intended workflow stages
- the tool respects design, spec, verification, and memory gates

If the files are present but the agent still behaves as if nothing changed, installation succeeded but runtime activation did not.

## 7. Verify That Workflows Do Not Auto-Activate

After installation, also verify the opposite case: the workflow should stay inactive unless explicitly invoked.

### Codex

Send a normal coding request without naming any workflow:

```text
Implement this small feature and keep the change minimal.
```

Expected behavior:

- Codex responds normally
- it does not automatically announce or assume a Superpowers or OpenSpec workflow
- it does not force staged behavior unless the user explicitly asked for it

### Cursor

Send a normal request without naming a workflow:

```text
Please help implement this small change.
```

Expected behavior:

- Cursor behaves like a normal coding assistant
- it does not automatically switch into the installed workflow

### Claude Code

Open the project after installation, but do not invoke any workflow command.

Then send:

```text
Help me make this small change.
```

Expected behavior:

- Claude Code behaves normally
- it does not automatically act as if `/superpowers-openspec-execution-workflow` had been invoked

## 8. Recommended Verification Sequence

For any tool:

1. run `-CheckDependencies`
2. install the bundle or memory scaffold
3. verify expected files exist
4. reload the tool
5. run one explicit workflow invocation
6. if memory is enabled, run `validate-superpowers-memory.ps1`
7. confirm behavior follows the intended workflow stages
8. run one normal request without naming a workflow
9. confirm the workflow does not auto-activate
