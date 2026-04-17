---
name: superpowers-learning-workflow
description: Standalone Codex workflow for capturing durable project knowledge, current state, session outcomes, and reusable lessons after meaningful work.
---

# Superpowers Learning Workflow

Use this standalone skill when the user wants to preserve lessons from recent work in the repository.

This is an explicit opt-in workflow. Do not use it by default. Only use it when the user explicitly asks for it, names `$superpowers-learning-workflow`, or a repository policy explicitly requires it.

## Workflow

1. Review recent work, decisions, and verification evidence.
2. Classify what was learned into durable facts, current state, session outcome, and reusable lessons.
3. If `.superpowers-memory/` exists, update `PROJECT_CONTEXT.md`, `CURRENT_STATE.md`, recent journal files, and `LEARNING_BACKLOG.md` as appropriate.
4. If `.superpowers-memory/` does not exist, tell the user to install the memory scaffold or keep the learning summary in a normal project document.
5. Keep stable facts separate from temporary notes.
6. Summarize what the next session should remember.

## Guardrails

- Do not write temporary task noise into `PROJECT_CONTEXT.md`.
- Do not turn a one-off fix into a reusable rule without a repeated pattern.
- Do not auto-edit the skill library itself unless the user explicitly asks for that separate step.
