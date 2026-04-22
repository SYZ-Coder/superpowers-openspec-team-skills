# Contributing

Thanks for contributing to `superpowers-openspec-team-skills`.

This repository contains two related layers:

- `team-skills/`: maintainer-facing source workflow definitions
- `dist/`: tool-adapted distributable bundles for Codex, Cursor, and Claude Code

Please keep them functionally aligned.

## Before You Start

1. Read [README.md](/D:/spring_AI/superpowers-openspec-team-skills/README.md).
2. Read [VERIFY.md](/D:/spring_AI/superpowers-openspec-team-skills/VERIFY.md) if your change affects installers, bundles, memory, or workflow behavior.
3. If your change touches repo memory behavior, also read:
   - [MEMORY.md](/D:/spring_AI/superpowers-openspec-team-skills/MEMORY.md)
   - [docs/memory-enhancement-design.cn.md](/D:/spring_AI/superpowers-openspec-team-skills/docs/memory-enhancement-design.cn.md)

## What Kinds of Contributions Are Welcome

- workflow improvements
- bundle installation fixes
- cross-platform script fixes
- documentation improvements
- verification and validation improvements
- memory / learning workflow refinements

## Contribution Rules

### 1. Keep explicit activation intact

Do not change the repository so installed workflows become default background behavior unless the change is explicitly intended and discussed.

### 2. Preserve source vs bundle separation

If you change `team-skills/`, check whether `dist/` and installer behavior also need updating.

### 3. Prefer small, reviewable changes

Keep pull requests focused. Avoid mixing:

- installer changes
- workflow behavior changes
- large documentation rewrites
- unrelated formatting

### 4. Keep docs aligned when behavior changes

If you change behavior, update the relevant documentation, usually one or more of:

- [README.md](/D:/spring_AI/superpowers-openspec-team-skills/README.md)
- [MEMORY.md](/D:/spring_AI/superpowers-openspec-team-skills/MEMORY.md)
- [VERIFY.md](/D:/spring_AI/superpowers-openspec-team-skills/VERIFY.md)
- Chinese counterparts when applicable

### 5. Do not silently widen trust or automation boundaries

Be careful with changes that:

- auto-enable workflows
- auto-write durable memory
- auto-promote learning candidates
- change installation targets
- expand script side effects

## Local Validation

Run the checks that match your change.

### Memory and learning changes

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot <project-root>
.\scripts\validate-superpowers-memory.ps1 -ProjectRoot <project-root>
.\scripts\search-superpowers-memory.ps1 -ProjectRoot <project-root> -Query "decision" -Type decisions
.\scripts\run-superpowers-memory-closeout.ps1 -ProjectRoot <project-root> -ChangedPaths "scripts/validate-superpowers-memory.ps1" -Signals "validation" -RunValidator
```

### Promotion draft changes

```powershell
.\scripts\generate-superpowers-promotion-drafts.ps1 -ProjectRoot <project-root>
```

### Installer or integration changes

```powershell
.\scripts\install-superpowers-memory.ps1 -ProjectRoot <project-root> -DryRun
.\scripts\install-superpowers-memory-integration.ps1 -Tool all -ProjectRoot <project-root> -DryRun
```

If you work on shell scripts, validate them in a real POSIX shell when possible.

## Pull Request Checklist

Before opening a PR, confirm:

- the change is scoped and reviewable
- affected docs were updated
- relevant scripts were tested
- behavior still matches the explicit opt-in model
- Windows / Linux / macOS support claims remain accurate

## Documentation Expectations

When introducing a new user-facing capability, prefer to document:

- what it does
- when it runs
- how it is triggered
- whether it is explicit or automatic
- how to verify it

## Questions

If a change has unclear product, workflow, or licensing implications, open an issue or draft PR first instead of guessing.
