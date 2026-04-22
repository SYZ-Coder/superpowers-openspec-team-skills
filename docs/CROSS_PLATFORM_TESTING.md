# Cross-Platform Testing

This guide provides a minimal verification matrix for the memory enhancement scripts across Windows, Linux, and macOS.

Use it when you want a quick answer to:

- which script entrypoint should run on each platform
- what a passing result looks like
- what was actually verified in this repository

## Scope

The current cross-platform checks cover these scripts:

- [validate-superpowers-memory.ps1](/D:/spring_AI/superpowers-openspec-team-skills/scripts/validate-superpowers-memory.ps1)
- [validate-superpowers-memory.sh](/D:/spring_AI/superpowers-openspec-team-skills/scripts/validate-superpowers-memory.sh)
- [generate-superpowers-promotion-drafts.ps1](/D:/spring_AI/superpowers-openspec-team-skills/scripts/generate-superpowers-promotion-drafts.ps1)
- [generate-superpowers-promotion-drafts.sh](/D:/spring_AI/superpowers-openspec-team-skills/scripts/generate-superpowers-promotion-drafts.sh)

## Status Matrix

| Platform | Validator entrypoint | Promotion draft entrypoint | Current status |
| --- | --- | --- | --- |
| Windows PowerShell 5.1+ | `validate-superpowers-memory.ps1` | `generate-superpowers-promotion-drafts.ps1` | Real execution verified |
| Linux (`/bin/sh`) | `validate-superpowers-memory.sh` | `generate-superpowers-promotion-drafts.sh` | Static review completed, real run still recommended |
| macOS (`/bin/sh`) | `validate-superpowers-memory.sh` | `generate-superpowers-promotion-drafts.sh` | Static review completed, real run still recommended |

## What Was Actually Verified

### Windows

The PowerShell scripts were executed in a real Windows environment.

Verified behaviors:

- promotion drafts are generated from `LEARNING_BACKLOG.md`
- validator completes successfully against a fresh scaffold
- validator refreshes `memory-index.yaml`
- Windows PowerShell 5.1 compatibility was fixed for the promotion script

Observed passing result:

```text
Summary: 0 error(s), 0 warning(s), 2 info item(s)
```

### Linux and macOS

The shell scripts were reviewed and hardened for portability, but were not executed in a real Linux or macOS runtime from this workspace.

Portability work already applied:

- native `sh` entrypoints, no `pwsh` dependency
- GNU and BSD `stat` support
- GNU and BSD `date` fallback handling
- `awk` compatibility fix for promotion draft generation
- safer `awk`-based counters for stale and conflict metrics

## Recommended Commands

Replace `<repo-root>` and `<project-root>` with real paths.

### Windows

Validate memory:

```powershell
.\scripts\validate-superpowers-memory.ps1 -ProjectRoot <project-root>
```

Generate promotion drafts:

```powershell
.\scripts\generate-superpowers-promotion-drafts.ps1 -ProjectRoot <project-root>
```

### Linux or macOS

Validate memory:

```bash
sh "<repo-root>/scripts/validate-superpowers-memory.sh" --project-root <project-root>
```

Generate promotion drafts:

```bash
sh "<repo-root>/scripts/generate-superpowers-promotion-drafts.sh" --project-root <project-root>
```

Overwrite existing drafts:

```bash
sh "<repo-root>/scripts/generate-superpowers-promotion-drafts.sh" --project-root <project-root> --force
```

## Pass Criteria

For a fresh memory scaffold, a healthy run should generally mean:

- the command exits successfully
- the validator reports no errors
- `memory-index.yaml` is refreshed unless index writing was explicitly skipped
- promotion drafts appear under `.superpowers-memory/promotion-drafts/` when a candidate is marked `ready_for_promotion`

Warnings may still be acceptable when the project has not yet accumulated real journal history.

## Recommended Manual Test Cases

Run these checks on each target platform:

1. Install or prepare `.superpowers-memory/`.
2. Add one valid session journal entry.
3. Run the validator.
4. Confirm `memory-index.yaml` was updated.
5. Add one `ready_for_promotion` backlog candidate.
6. Run the promotion draft generator.
7. Confirm a draft file was written.
8. Re-run without overwrite and confirm the draft is preserved.

## Known Boundary

At the time of writing:

- Windows has real execution evidence
- Linux and macOS have portability-focused review and script hardening
- Linux and macOS should still be validated on a real shell runtime before claiming full runtime certification

For fuller installation and workflow verification, see [VERIFY.md](/D:/spring_AI/superpowers-openspec-team-skills/VERIFY.md).
