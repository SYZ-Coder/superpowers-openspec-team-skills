# Source Workflow Usage Guide

How to work with the source workflow layer under `team-skills/`.

This guide is for maintainers, tool adapters, and advanced users who need the original workflow definitions instead of the prebuilt bundles under `dist/`.

## When To Read This Guide

Use this guide when you are:

- reviewing how the source workflows are organized
- deciding which source workflow to extend
- adapting the workflows to another AI tool or runtime
- validating whether source workflows and distributed bundles still match

If you only want to install the workflows into Codex, Cursor, or Claude Code, use the root README and installer scripts instead.

## What A Source Workflow Package Contains

Most workflow packages under `team-skills/` include:

- a `README.md` and `readme_cn.md`
- one or more instruction files that describe the workflow behavior
- a `workflow.yaml` file for machine-readable metadata

Treat these folders as source definitions, not as ready-to-copy end-user packages.

## Recommended Reading Order

For maintainers or reviewers, a practical order is:

1. Start with [README.md](README.md) in this directory to choose the right workflow family.
2. Open the target workflow README to understand what that workflow does.
3. Check `workflow.yaml` to inspect dependency and tool metadata.
4. Compare the matching bundle under `dist/` if you need to confirm distribution behavior.

## Common Tasks

### Install into Claude Code without replacing an existing `CLAUDE.md`

If the target project already has a `CLAUDE.md`, use the merge mode instead of the default replace behavior.

PowerShell:

```powershell
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -MergeClaudeMd
```

shell:

```bash
sh "./scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --merge-claude-md
```

This keeps the existing `CLAUDE.md` and adds the bundle instructions as a managed block that can be updated on later installs.

### Inspect a workflow

- Read the workflow README first.
- Confirm whether it is an entry workflow or a supporting workflow.
- Check whether it assumes OpenSpec, Superpowers, archive, or memory behavior.

### Adapt a workflow to a new tool

- Use `team-skills/` as the source of truth.
- Preserve functional intent even if command style, file layout, or wording changes.
- Create tool-specific output under `dist/` rather than editing source packages to mimic one runtime.

### Update a workflow

- Edit the source workflow files under `team-skills/`.
- Keep related documentation aligned.
- Rebuild distributable bundles after the source changes.

### Validate source and bundle alignment

- Compare the source workflow behavior with the corresponding bundle behavior.
- Focus on workflow gates, expected outputs, activation method, and continuation logic.
- Differences in wording are acceptable; differences in functional behavior should be intentional.

## Relationship To Installable Bundles

Use these layers for different jobs:

- `team-skills/`: authoring and maintenance layer
- `dist/`: end-user installation layer

Some source workflows are intentionally modular and may depend on other workflows or external skills. That is good for maintenance, but it is exactly why end users should not treat this directory as the default installation target.

## Related Files

- [English Source Workflow Navigation](README.md)
- [Chinese Source Workflow Navigation](README.cn.md)
- [English Source Workflow Installation Notes](INSTALL.md)
- [Chinese Source Workflow Installation Notes](INSTALL.cn.md)
- [English Source Workflow Usage Guide](USAGE.md)
- [Chinese Source Workflow Usage Guide](USAGE.cn.md)
