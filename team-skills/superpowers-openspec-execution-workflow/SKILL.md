---
name: superpowers-openspec-execution-workflow
description: Use when a non-trivial feature should combine exploratory planning, formal OpenSpec change artifacts, and disciplined implementation with testing and final change completion.
---

# Superpowers -> OpenSpec -> Superpowers Workflow

## Overview

Use this skill when the team wants a three-stage delivery path:

1. Explore with Superpowers
2. Lock the change with OpenSpec
3. Execute with Superpowers and finish with verification plus change completion

This skill is an orchestrator. It should delegate detail work to the existing workflow skills instead of duplicating them.

## Required Order

1. Start with `$superpowers-feature-workflow`.
   Use it to clarify scope, compare approaches, confirm the solution shape, and capture the design draft.
2. Move to `$openspec-feature-workflow`.
   Use it to create the change and complete `proposal.md`, `design.md`, `specs/.../spec.md`, and `tasks.md`.
3. Return to `$superpowers-feature-workflow`.
   Use it to write the implementation plan, prefer a worktree, execute with TDD, and run fresh verification.
4. If implementation and specs are aligned after verification, use `$openspec-archive-change` to archive the completed change.

## Decision Gates

- Do not create implementation code during the exploration stage.
- Do not start coding until required OpenSpec artifacts are complete.
- Do not claim success until fresh verification output exists.
- Do not archive the change until code, tests, and specs are aligned.

## When to Use

- The team wants "explore first, spec second, execute third"
- The request needs exploratory planning before formal requirements are locked
- The feature changes behavior and needs both durable change artifacts and disciplined implementation
- The team wants a single entry skill for this three-stage workflow

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
