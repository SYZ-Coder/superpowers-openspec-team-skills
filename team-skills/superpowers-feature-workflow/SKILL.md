---
name: superpowers-feature-workflow
description: Use when feature work needs the Superpowers stages before or during implementation: brainstorming, design confirmation, implementation planning, worktree setup, test-driven development, and verification. Trigger when the user asks to brainstorm first, wants a plan before coding, or wants disciplined execution with TDD and verification.
---

# Superpowers Feature Workflow

## Overview

Use this skill for the Superpowers half of feature delivery. It covers clarification, design, plan, worktree, TDD, verification, and repo-persisted memory, but it does not manage OpenSpec artifacts.

This is an explicit opt-in workflow. Do not use it by default. Only use it when the user explicitly asks for this workflow, names this skill, or a repository policy explicitly requires it.

## Workflow

1. Explore project context before proposing solutions. If `.superpowers-memory/` exists, read `PROJECT_CONTEXT.md`, `CURRENT_STATE.md`, and the latest session journal entries first.
2. Clarify requirements one question at a time.
3. Present 2-3 approaches with a recommendation.
4. Write the approved design to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`.
5. Ask for user confirmation on the written design before moving on.
6. Write the implementation plan to `docs/superpowers/plans/YYYY-MM-DD-<topic>.md`.
7. Prefer a repo-local worktree for implementation.
8. Implement with TDD: failing test first, then minimal code, then green.
9. Run fresh verification commands before any completion claim.
10. Before finishing the session, update `.superpowers-memory/CURRENT_STATE.md` and add a short session note under `.superpowers-memory/session-journal/` when the repo uses Superpowers memory.

## When to Use

- The user explicitly asks to brainstorm first
- The user explicitly names `$superpowers-feature-workflow`
- The user explicitly asks for a written plan, TDD, or verification workflow
- A repository policy explicitly requires this workflow

## Outputs

- Confirmed design doc
- Implementation plan
- Verified implementation evidence
- Updated Superpowers memory when `.superpowers-memory/` is present

## Guardrails

- Do not write production code before design approval
- Do not skip the failing-test step for new behavior
- Do not report success without fresh command output
- Do not overwrite stable project memory with temporary notes; keep long-term facts in `PROJECT_CONTEXT.md` and session-specific updates in the journal
