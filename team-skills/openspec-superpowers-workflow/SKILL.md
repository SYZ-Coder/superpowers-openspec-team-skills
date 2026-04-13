---
name: openspec-superpowers-workflow
description: Use when a feature request must follow the full OpenSpec plus Superpowers workflow from clarification through proposal, design, tasks, implementation, and verification. Trigger when the user explicitly asks for OpenSpec plus Superpowers, asks for brainstorm then proposal/design/tasks then code, or the work is a non-trivial behavior change.
---

# OpenSpec + Superpowers Workflow

## Overview

Use this skill as the team entrypoint for feature delivery. It coordinates the order of work; it does not replace the detailed OpenSpec or Superpowers sub-skills.

This is an explicit opt-in workflow. Do not use it by default. Only use it when the user explicitly asks for this workflow, names this skill, or a repository policy explicitly requires it.

## Required Order

1. Run `$superpowers-feature-workflow` to clarify the request, compare approaches, confirm the design, and prepare implementation.
2. Run `$openspec-feature-workflow` to create the change and complete `proposal`, `design`, `specs`, and `tasks`.
3. Return to the Superpowers track for plan execution, worktree setup, TDD, and verification.
4. Do not claim completion until verification evidence exists.

## When to Use

- The user explicitly asks for `OpenSpec + Superpowers`
- The user explicitly names `$openspec-superpowers-workflow`
- The user explicitly asks for brainstorm, then proposal/design/tasks, then implementation, then verification
- A repository policy explicitly requires this workflow

## Deliverables

- Design doc in `docs/superpowers/specs/`
- OpenSpec change artifacts in `openspec/changes/<change-name>/`
- Implementation plan in `docs/superpowers/plans/`
- Code, tests, and fresh verification output

## Guardrails

- Do not start implementation before the design is approved
- Do not skip OpenSpec artifacts for behavior changes
- Do not skip worktree, TDD, or verification when the request includes them
- Keep the skill portable: use repo-local paths and avoid machine-specific assumptions
