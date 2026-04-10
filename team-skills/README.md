# Team Skills

This directory contains portable, repo-owned skill packages for the team's OpenSpec + Superpowers workflow.

Current packages:

- `openspec-superpowers-workflow`
- `superpowers-openspec-execution-workflow`
- `superpowers-feature-workflow`
- `openspec-feature-workflow`

These packages are designed to be open-source friendly and do not depend on local machine paths.

If the team later wants automatic skill discovery, copy the needed folders into a runtime skill directory such as `.codex/skills/`.

## Packages

- [openspec-superpowers-workflow](openspec-superpowers-workflow/README.md) ([中文](openspec-superpowers-workflow/readme_cn.md))
- [superpowers-openspec-execution-workflow](superpowers-openspec-execution-workflow/README.md) ([中文](superpowers-openspec-execution-workflow/readme_cn.md))
- [superpowers-feature-workflow](superpowers-feature-workflow/README.md) ([中文](superpowers-feature-workflow/readme_cn.md))
- [openspec-feature-workflow](openspec-feature-workflow/README.md) ([中文](openspec-feature-workflow/readme_cn.md))

## Recommended Use

- Use `openspec-superpowers-workflow` for a single full-flow entry.
- Use `superpowers-openspec-execution-workflow` when the team wants Superpowers exploration, OpenSpec locking, then Superpowers execution plus archive.
- Use `superpowers-feature-workflow` when you only need design, planning, worktree, TDD, and verification discipline.
- Use `openspec-feature-workflow` when you only need to create or complete change artifacts.

## Documentation

- [INSTALL.md](INSTALL.md)
- [INSTALL.cn.md](INSTALL.cn.md)
