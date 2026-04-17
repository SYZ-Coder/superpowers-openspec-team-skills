---
name: superpowers-feature-workflow
description: Standalone Codex workflow for clarification, design, planning, TDD, and verification.
---

# Superpowers Feature Workflow

Use this standalone skill when you want disciplined feature delivery without OpenSpec artifact generation.

This is an explicit opt-in workflow. Do not use it by default. Only use it when the user explicitly asks for it, names `$superpowers-feature-workflow`, or a repository policy explicitly requires it.

## Workflow

1. Explore project context first. If `.superpowers-memory/` exists, read `PROJECT_CONTEXT.md`, `CURRENT_STATE.md`, and the latest session journal entries before asking questions.
2. Clarify requirements one question at a time.
3. Present 2-3 approaches and recommend one.
4. Write the approved design to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`.
5. Ask the user to confirm the written design.
6. Write the implementation plan to `docs/superpowers/plans/YYYY-MM-DD-<topic>.md`.
7. Prefer a repo-local worktree for non-trivial work.
8. Implement with TDD: failing test, minimal code, green test.
9. Run fresh verification before claiming completion.
10. If `.superpowers-memory/` exists, update `CURRENT_STATE.md` and add a short session journal entry before ending the session.

## Guardrails

- No production code before design approval.
- No skipping the failing test for new behavior.
- No completion claim without fresh command output.
- Do not mix stable project facts with temporary session notes inside the same memory file.
