# Source Workflow Installation Notes

`team-skills/` contains the source workflow definitions maintained by this repository.

These folders are not the primary end-user installation target anymore.

## When To Use `team-skills/`

Use `team-skills/` directly only when you are:

- maintaining the source workflows
- adapting the workflows to a new tool
- building new bundles under `dist/`
- reading the original workflow definitions

## End User Installation

If you want to install the workflows into a tool, use the prebuilt bundles and install scripts instead:

- Codex: `dist/codex/bundles/` or `scripts/install-codex.ps1`
- Cursor: `dist/cursor/bundles/` or `scripts/install-cursor.ps1`
- Claude Code: `dist/claude-code/bundles/` or `scripts/install-claude-code.ps1`

Optional memory scaffold for Superpowers workflows:

- `scripts/install-superpowers-memory.ps1 -ProjectRoot <project-root>`
- `scripts/install-superpowers-memory-integration.ps1 -Tool all -ProjectRoot <project-root>`

This creates `.superpowers-memory/` in the target project so Superpowers-based workflows can read stable project context and persist session summaries for future sessions.
It can also update project-level tool instructions so Codex, Cursor, and Claude Code read that memory at the start of new sessions.

## Why Not Copy Source Workflows Directly

Some source workflows are orchestrators. They are designed for maintainability and may depend on other workflows or external skills.

That modular design is useful for maintainers, but it can confuse users who expect a single copied folder to be immediately usable.

The `dist/` bundles are the supported installation path for real usage.
