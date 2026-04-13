# Verify Installed Bundles

This document explains how to verify that a bundle has been installed correctly and is actually affecting tool behavior.

Verification should happen at two levels:

1. installation verification: did the expected files land in the expected location?
2. runtime verification: did the tool actually pick up the workflow and behave differently?

Before running any script in this document, make sure you are either:

- in the repository root, or
- invoking the script with an absolute path

## 1. Codex

### Step 1: Check runtime dependencies

For bundles that depend on OpenSpec, run:

```powershell
.\scripts\install-codex.ps1 -Bundle superpowers-openspec-execution -CheckDependencies
```

If `openspec-cli` is missing, the bundle can still be installed, but the workflow may not run end to end.

### Step 2: Install the bundle

```powershell
.\scripts\install-codex.ps1 -Bundle superpowers-openspec-execution
```

### Step 3: Verify installed files

```powershell
Test-Path "$env:USERPROFILE\.codex\skills\superpowers-openspec-execution-workflow\SKILL.md"
```

Expected result:

```text
True
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
- it asks clarifying questions or confirms scope
- it moves through OpenSpec artifact work before implementation
- it returns to implementation and verification after the spec is locked

If Codex immediately starts writing production code without that staged flow, the workflow did not take effect.

## 2. Cursor

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

Expected result:

```text
True
True
```

### Step 4: Reopen the project in Cursor

Cursor should reload the project rules after the files are written.

### Step 5: Verify runtime behavior

In Cursor, send a request such as:

```text
Use the superpowers-openspec-execution workflow for this feature: first explore, then lock OpenSpec, then implement and verify, then archive the change.
```

Expected behavior:

- the agent behaves like it is following a staged workflow
- it does not skip directly to implementation
- it treats design and OpenSpec artifact work as explicit phases

## 3. Claude Code

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

Expected result:

```text
True
True
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

## 4. What Counts As “Actually Working”

A bundle is not considered fully verified just because the files exist.

The real signal is behavior:

- the tool recognizes the installed bundle
- the tool follows the intended workflow stages
- the tool respects design/spec/verification gates

If the files are present but the agent still behaves as if nothing changed, installation succeeded but runtime activation did not.

## 5. Recommended Verification Sequence

For any tool:

1. run `-CheckDependencies`
2. install the bundle
3. verify expected files exist
4. restart or reload the tool
5. run one explicit workflow invocation
6. confirm behavior follows the workflow stages
