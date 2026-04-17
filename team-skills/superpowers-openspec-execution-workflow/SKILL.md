---
name: superpowers-openspec-execution-workflow
description: Use when a feature should follow four explicit steps: Superpowers exploration, OpenSpec locking, Superpowers execution, and OpenSpec archive.
---

# Superpowers -> OpenSpec -> Superpowers Workflow

## Overview

Use this skill when the team wants this four-step delivery path:

1. Explore with Superpowers
2. Lock the change with OpenSpec
3. Execute with Superpowers and finish with implementation, testing, and verification
4. Archive the completed OpenSpec change

This skill is an orchestrator. It should delegate detail work to the existing workflow skills instead of duplicating them.

This is an explicit opt-in workflow. Do not use it by default. Only use it when the user explicitly asks for this workflow, names this skill, or a repository policy explicitly requires it.

If `.superpowers-memory/` exists in the repository, read it at the start and update it before final archive so the next session can resume with real context.

## Required Order

1. Start with `$superpowers-feature-workflow`.
   Use it to clarify scope, compare approaches, confirm the solution shape, and capture the design draft.
2. Move to `$openspec-feature-workflow`.
   Use it to create the change and complete `proposal.md`, `design.md`, `specs/.../spec.md`, and `tasks.md`.
3. Return to `$superpowers-feature-workflow`.
   Use it to write the implementation plan, prefer a worktree, execute with TDD, and run fresh verification.
4. If implementation and specs are aligned after verification, use `$openspec-archive-change` to archive the completed change.
5. If `.superpowers-memory/` exists, update `CURRENT_STATE.md` and add a short session journal entry after verification and archive decisions are complete.

## Decision Gates

- Do not create implementation code during the exploration stage.
- Do not start coding until required OpenSpec artifacts are complete.
- Do not claim success until fresh verification output exists.
- Do not archive the change until code, tests, and specs are aligned.

## When to Use

- The user explicitly asks for "explore first, spec second, execute third"
- The user explicitly names `$superpowers-openspec-execution-workflow`
- The user explicitly asks for Superpowers exploration, OpenSpec locking, then Superpowers execution and archive
- A repository policy explicitly requires this workflow

## Deliverables

- Design draft in `docs/superpowers/specs/`
- OpenSpec artifacts under `openspec/changes/<change-name>/`
- Implementation plan in `docs/superpowers/plans/`
- Code, tests, and fresh verification evidence
- Archived OpenSpec change when the work is complete

## Recommended Prompt

```text
Use $superpowers-openspec-execution-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```
