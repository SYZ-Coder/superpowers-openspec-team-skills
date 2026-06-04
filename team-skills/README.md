# Team Skills

Navigation for the source workflow layer.

`team-skills/` contains the source workflow definitions maintained by this repository. This directory is for maintainers, adapters, and advanced readers who want to inspect the original workflow structure.

If you want to install and use these workflows in Codex, Cursor, or Claude Code, start from the root [README.md](../README.md), `dist/`, and `scripts/` instead of copying folders out of `team-skills/`.

## What Is Here

This directory contains five source workflow packages:

- `openspec-superpowers-workflow`
- `superpowers-openspec-superpowers-workflow`
- `superpowers-feature-workflow`
- `superpowers-learning-workflow`
- `openspec-feature-workflow`

These packages are repo-owned, open-source-friendly, and do not depend on local machine paths.

## How To Use This Section

Use `team-skills/` when you need one of these tasks:

- read the original workflow definitions
- compare the responsibilities of each workflow
- maintain workflow source content
- adapt the workflows to a new AI tool
- build or validate bundles under `dist/`

If your goal is installation into a tool, this section is not the primary entry point.

## Workflow Directory

- [openspec-superpowers-workflow (EN)](openspec-superpowers-workflow/README.md) | [CN](openspec-superpowers-workflow/readme_cn.md)
- [superpowers-openspec-superpowers-workflow (EN)](superpowers-openspec-superpowers-workflow/README.md) | [CN](superpowers-openspec-superpowers-workflow/readme_cn.md)
- [superpowers-feature-workflow (EN)](superpowers-feature-workflow/README.md) | [CN](superpowers-feature-workflow/readme_cn.md)
- [superpowers-learning-workflow (EN)](superpowers-learning-workflow/README.md) | [CN](superpowers-learning-workflow/readme_cn.md)
- [openspec-feature-workflow (EN)](openspec-feature-workflow/README.md) | [CN](openspec-feature-workflow/readme_cn.md)

## How To Choose

- Choose `openspec-superpowers-workflow` when you want one full-flow entry from clarification through verified delivery.
- Choose `superpowers-openspec-superpowers-workflow` when you want to explore first, lock the truth second, then come back and build the change with more confidence and less chaos.
- Choose `superpowers-feature-workflow` when you want Superpowers engineering discipline without OpenSpec change artifacts.
- Choose `superpowers-learning-workflow` when meaningful work is done and you want to preserve reusable lessons and current state.
- Choose `openspec-feature-workflow` when you only want proposal, design, specs, and tasks before implementation.

## Source-Layer Guides

- [Source Workflow Installation Notes](INSTALL.md)
- [Source Workflow Usage Guide](USAGE.md)
- [Chinese Installation Notes](INSTALL.cn.md)
- [Chinese Usage Guide](USAGE.cn.md)

## Relationship To `dist/`

- `team-skills/`: source workflow definitions for maintainers and adapters
- `dist/`: installable bundles prepared for specific AI tools

The wording and file structure may differ between these layers, but the intended behavior should stay aligned.
