---
name: superpowers-feature-workflow
description: Use when feature work needs the Superpowers stages before or during implementation: brainstorming, design confirmation, implementation planning, worktree setup, test-driven development, and verification. Trigger when the user asks to brainstorm first, wants a plan before coding, or wants disciplined execution with TDD and verification.
---

# Superpowers Feature Workflow

## Overview

Use this skill for the Superpowers half of feature delivery. It covers clarification, design, plan, worktree, TDD, and verification, but it does not manage OpenSpec artifacts.

## Workflow

1. Explore project context before proposing solutions.
2. Clarify requirements one question at a time.
3. Present 2-3 approaches with a recommendation.
4. Write the approved design to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`.
5. Ask for user confirmation on the written design before moving on.
6. Write the implementation plan to `docs/superpowers/plans/YYYY-MM-DD-<topic>.md`.
7. Prefer a repo-local worktree for implementation.
8. Implement with TDD: failing test first, then minimal code, then green.
9. Run fresh verification commands before any completion claim.

## When to Use

- The request explicitly asks to brainstorm first
- The user wants a plan before coding
- The implementation should use worktrees, TDD, or explicit verification
- The feature needs structured design review before code changes

## Outputs

- Confirmed design doc
- Implementation plan
- Verified implementation evidence

## Guardrails

- Do not write production code before design approval
- Do not skip the failing-test step for new behavior
- Do not report success without fresh command output
