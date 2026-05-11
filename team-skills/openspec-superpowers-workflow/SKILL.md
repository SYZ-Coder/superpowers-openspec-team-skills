---
name: openspec-superpowers-workflow
description: Use when the user explicitly wants an OpenSpec-first path that creates proposal, design, specs, and tasks before handing off to Superpowers execution, verification, and optional archive.
---

# OpenSpec + Superpowers Workflow

## Overview

Use this skill as the OpenSpec-first feature delivery entrypoint. It creates and validates OpenSpec change artifacts first, then hands the completed task checklist to Superpowers for implementation planning, TDD, and verification.

This is an explicit opt-in workflow. Do not use it by default. Only use it when the user explicitly asks for this workflow, names this skill, or a repository policy explicitly requires it.

If `.superpowers-memory/` exists in the repository, treat it as shared project memory: read it before planning and update it before closing the workflow.

## Required Order

1. Run `$openspec-feature-workflow` first.
   Use it to clarify the change enough to create and complete `proposal`, `design`, `specs`, and `tasks`.
2. Stop OpenSpec apply-style execution after `tasks.md` is complete.
3. Hand off to the Superpowers track for implementation planning, worktree setup, TDD, and verification.
4. If the project uses OpenSpec archive flow and code, specs, and verification are aligned, archive the change as the final OpenSpec step.
5. Do not claim completion until verification evidence exists.
6. If `.superpowers-memory/` exists, update `CURRENT_STATE.md` and add a short journal entry for the session outcome.

## When to Use

- The user explicitly asks for `OpenSpec + Superpowers`
- The user explicitly names `$openspec-superpowers-workflow`
- The user explicitly wants OpenSpec proposal/design/spec/tasks before implementation planning
- A repository policy explicitly requires this workflow

## Deliverables

- OpenSpec change artifacts in `openspec/changes/<change-name>/`
- Implementation plan in `docs/superpowers/plans/`
- Code, tests, and fresh verification output
- Archived OpenSpec change when archive flow is part of the project workflow
- Updated Superpowers memory when `.superpowers-memory/` is present

## Guardrails

- Do not skip OpenSpec artifacts for behavior changes
- Do not use OpenSpec apply as the implementation stage for this combined workflow
- After OpenSpec `tasks.md` is complete, stop OpenSpec apply-style execution and hand off to the Superpowers track
- Do not stop after OpenSpec artifacts with a readiness message such as "run apply", "/opsx:apply", or "let me start implementation"
- Unless the user explicitly asked to pause after OpenSpec artifacts, continue directly into Superpowers execution by writing the implementation plan
- Treat OpenSpec tasks as constraints and checklist input for the Superpowers implementation plan
- Do not archive the change until code, tests, and specs are aligned
- Do not skip worktree, TDD, or verification when the request includes them
- Keep the skill portable: use repo-local paths and avoid machine-specific assumptions
