# Team Skills

This directory contains portable, repo-owned skill packages for the team's OpenSpec + Superpowers workflow.

Current packages:

- `openspec-superpowers-workflow`
- `superpowers-openspec-execution-workflow`
- `superpowers-feature-workflow`
- `superpowers-learning-workflow`
- `openspec-feature-workflow`

These packages are designed to be open-source friendly and do not depend on local machine paths.

If the team later wants automatic skill discovery, copy the needed folders into a runtime skill directory such as `.codex/skills/`.

## Packages

- [openspec-superpowers-workflow](openspec-superpowers-workflow/README.md) ([中文](openspec-superpowers-workflow/readme_cn.md))
- [superpowers-openspec-execution-workflow](superpowers-openspec-execution-workflow/README.md) ([中文](superpowers-openspec-execution-workflow/readme_cn.md))
- [superpowers-feature-workflow](superpowers-feature-workflow/README.md) ([中文](superpowers-feature-workflow/readme_cn.md))
- [superpowers-learning-workflow](superpowers-learning-workflow/README.md) ([中文](superpowers-learning-workflow/readme_cn.md))
- [openspec-feature-workflow](openspec-feature-workflow/README.md) ([中文](openspec-feature-workflow/readme_cn.md))

## Recommended Use

- Use `openspec-superpowers-workflow` for a single full-flow entry.
- Use `superpowers-openspec-execution-workflow` when the team wants four explicit steps: Superpowers exploration, OpenSpec locking, Superpowers execution, then OpenSpec archive.
- Use `superpowers-feature-workflow` when you only need design, planning, worktree, TDD, and verification discipline.
- Use `superpowers-learning-workflow` when you want to capture durable lessons, current state, and reusable patterns after meaningful work.
- Use `openspec-feature-workflow` when you only need to create or complete change artifacts.

## How To Choose

- Choose `openspec-superpowers-workflow` when you want one general entry point from clarification through implementation and verification.
- Choose `superpowers-openspec-execution-workflow` when you want a fixed four-step sequence and want that sequence to stay explicit.
- Choose `superpowers-feature-workflow` when you only want the Superpowers engineering workflow.
- Choose `superpowers-learning-workflow` when the work is done and you want the next session to inherit the right lessons.
- Choose `openspec-feature-workflow` when you only want OpenSpec change artifacts.

## Documentation

- [INSTALL.md](INSTALL.md)
- [INSTALL.cn.md](INSTALL.cn.md)
