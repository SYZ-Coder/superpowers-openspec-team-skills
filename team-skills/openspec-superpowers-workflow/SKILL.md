---
name: openspec-superpowers-workflow
description: Use when the user explicitly wants an OpenSpec-first path that creates proposal, design, specs, and tasks before handing off to Superpowers execution, verification, and optional archive, or when a follow-up turn is confirming or editing tasks that this workflow already generated.
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
3. Present the generated OpenSpec task checklist to the user.
4. By default, wait for explicit confirmation before implementation planning starts.
5. After the user confirms `tasks.md`, pause once more and ask whether to continue execution development.
   Accept either `继续开发` or `continue-dev` as the explicit continuation command.
6. Do not route the confirmed task handoff through OpenSpec apply.
7. If the user chooses execution development, hand off to the Superpowers track for implementation planning, worktree setup, TDD, and verification.
8. After execution development completes, pause again and ask whether to continue code review.
   Accept either `继续审查` or `continue-review` as the explicit continuation command.
9. If the project uses OpenSpec archive flow and code, specs, and verification are aligned, archive the change as the final OpenSpec step.
   Before that final step, you may pause and ask whether to continue archive.
   Accept either `继续归档` or `continue-archive` as the explicit continuation command, or continue to use `$openspec-archive-change`.
10. Do not claim completion until verification evidence exists.
11. If `.superpowers-memory/` exists, update `CURRENT_STATE.md` and add a short journal entry for the session outcome.

## When to Use

- The user explicitly asks for `OpenSpec + Superpowers`
- The user explicitly names `$openspec-superpowers-workflow`
- The user explicitly wants OpenSpec proposal/design/spec/tasks before implementation planning
- The current turn is a follow-up that confirms, revises, or continues `tasks.md` that this workflow generated earlier in the same request
- A repository policy explicitly requires this workflow

## Continuation Gate

- If this workflow already produced OpenSpec artifacts for the current request and the user is now confirming, revising, or continuing the generated `tasks.md`, keep this workflow active even if the user does not repeat the skill name.
- Treat task edits or confirmation as a continuation turn, not as a fresh routing decision.
- After the user confirms the task checklist, keep this workflow active, pause for the explicit execution-development prompt, and do not fall back to OpenSpec apply.
- At that handoff, accept either `继续开发` or `continue-dev` as the continuation command.
- If the user chooses execution development, resume at the next incomplete Superpowers stage: hand off to the Superpowers track, write the implementation plan, and continue with TDD and verification.
- After execution development completes, ask whether to continue code review as a separate follow-up step.
- At that later handoff, accept either `继续审查` or `continue-review` as the continuation command.
- If the project uses archive flow and the work is aligned, a later archive handoff may accept either `继续归档` or `continue-archive`, while `$openspec-archive-change` remains valid.
- If the user revises tasks instead of confirming them, update the OpenSpec task summary, confirm the revised checklist state if needed, then continue the same workflow rather than falling back to generic OpenSpec apply guidance.

## Deliverables

- OpenSpec change artifacts in `openspec/changes/<change-name>/`
- Implementation plan in `docs/superpowers/plans/`
- Code, tests, and fresh verification output
- Archived OpenSpec change when archive flow is part of the project workflow
- Updated Superpowers memory when `.superpowers-memory/` is present

## Guardrails

- Do not skip OpenSpec artifacts for behavior changes
- Do not use OpenSpec apply as the implementation stage for this combined workflow
- After OpenSpec `tasks.md` is complete, stop OpenSpec apply-style execution, summarize the generated tasks, and by default ask the user to confirm the OpenSpec task checklist before the post-task handoff
- Do not stop after OpenSpec artifacts with a readiness message such as "run apply", "/opsx:apply", or "let me start implementation"
- Do not resume through OpenSpec apply after `tasks.md` is confirmed; the only allowed next-step prompt is whether to continue execution development
- After the user confirms `tasks.md`, pause and ask whether to continue execution development
- At that prompt, accept either `继续开发` or `continue-dev`
- Do not continue directly into Superpowers execution after OpenSpec artifacts until the user has explicitly confirmed the generated `tasks.md` and chosen execution development as the next step
- After Superpowers execution and verification complete, ask whether to continue code review
- At that prompt, accept either `继续审查` or `continue-review`
- If archive is the next step, accept either `继续归档` or `continue-archive`, while `$openspec-archive-change` remains usable.
- Treat OpenSpec tasks as constraints and checklist input for the Superpowers implementation plan
- Do not archive the change until code, tests, and specs are aligned
- Do not skip worktree, TDD, or verification when the request includes them
- Keep the skill portable: use repo-local paths and avoid machine-specific assumptions
