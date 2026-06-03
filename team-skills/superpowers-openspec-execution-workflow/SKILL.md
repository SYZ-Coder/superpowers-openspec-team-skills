---
name: superpowers-openspec-execution-workflow
description: Use when the team explicitly wants the Superpowers exploration, OpenSpec specification, Superpowers execution, and OpenSpec archive workflow for a feature, or when a follow-up turn is confirming or editing tasks that this workflow already generated.
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

If `.superpowers-memory/` exists in the repository, read `PROJECT_CONTEXT.md`, `CURRENT_STATE.md`, `DECISIONS.md`, `KNOWN_FAILURES.md`, `VERIFICATION_BASELINE.md`, `TEAM_PREFERENCES.md`, `USER_PROFILE.md`, `AGENT_NOTES.md`, and the newest session journal entries at the start, then update the relevant files before final archive so the next session can resume with real context.

## Required Order

1. Start with `$superpowers-feature-workflow`.
   Use it to clarify scope, compare approaches, confirm the solution shape, and capture the design draft.
2. Move to `$openspec-feature-workflow`.
   Use it to create the change and complete `proposal.md`, `design.md`, `specs/.../spec.md`, and `tasks.md`.
3. Present the generated OpenSpec task checklist to the user.
4. By default, wait for explicit confirmation before implementation planning starts.
5. After the user confirms `tasks.md`, pause once more and ask whether to continue execution development.
   Accept either `继续开发` or `continue-dev` as the explicit continuation command.
6. Do not route the confirmed task handoff through OpenSpec apply.
7. If the user chooses execution development, return to `$superpowers-feature-workflow`.
   Use it to write the implementation plan, prefer a worktree, execute with TDD, and run fresh verification.
8. After execution development completes, pause again and ask whether to continue code review.
   Accept either `继续审查` or `continue-review` as the explicit continuation command.
9. If implementation and specs are aligned after verification, use `$openspec-archive-change` to archive the completed change.
   Before that final step, you may pause and ask whether to continue archive.
   Accept either `继续归档` or `continue-archive` as the explicit continuation command, or continue to use `$openspec-archive-change`.
10. If `.superpowers-memory/` exists, perform a memory alignment check after verification and archive decisions: ensure durable facts, current state, decisions, failure patterns, and session outcome are reflected in the right files.
11. Prefer `scripts/run-superpowers-memory-closeout.ps1` when you want one command to review the checklist, get update suggestions, and optionally run validation after execution or archive work.
12. Use `scripts/suggest-superpowers-memory-updates.ps1` if it is still unclear which memory surfaces should be updated after implementation, verification, or archive work.
13. When memory quality matters for the project, run `scripts/validate-superpowers-memory.ps1` before the final completion claim.

## Decision Gates

- When the user names `$superpowers-openspec-execution-workflow`, this orchestrator controls routing; do not route first to `$openspec-feature-workflow`, `openspec-propose`, `/opsx:propose`, or any OpenSpec proposal skill.
- Mentioning OpenSpec in this workflow name is not permission to start OpenSpec proposal generation.
- Do not invoke `$openspec-feature-workflow`, `openspec-propose`, or any OpenSpec artifact-generation step before the Superpowers exploration gate is complete.
- The Superpowers exploration gate is complete only after context review, requirement clarification, approach comparison, user confirmation of the solution shape, and a design draft under `docs/superpowers/specs/`.
- Do not create implementation code during the exploration stage.
- Do not start coding until required OpenSpec artifacts are complete.
- Do not use OpenSpec apply as the implementation stage for this workflow.
- After OpenSpec `tasks.md` is complete, stop OpenSpec apply-style execution, summarize the generated tasks, and by default ask the user to confirm the OpenSpec task checklist before the post-task handoff.
- Do not stop after OpenSpec artifacts with a readiness message such as "run apply", "/opsx:apply", or "let me start implementation".
- Do not resume through OpenSpec apply after `tasks.md` is confirmed; the only allowed next-step prompt is whether to continue execution development.
- After the user confirms `tasks.md`, pause and ask whether to continue execution development.
- At that prompt, accept either `继续开发` or `continue-dev`.
- Do not continue directly into Superpowers execution after OpenSpec artifacts until the user has explicitly confirmed the generated `tasks.md` and chosen execution development as the next step.
- After Superpowers execution and verification complete, ask whether to continue code review.
- At that prompt, accept either `继续审查` or `continue-review`.
- If archive is the next step, accept either `继续归档` or `continue-archive`, while `$openspec-archive-change` remains usable.
- Treat OpenSpec tasks as constraints and checklist input for the Superpowers implementation plan, not as permission to stay inside the OpenSpec apply flow.
- Do not claim success until fresh verification output exists.
- Do not archive the change until code, tests, and specs are aligned.
- Do not leave memory out of sync with the final archive decision when `.superpowers-memory/` exists.

## When to Use

- The user explicitly asks for "explore first, spec second, execute third"
- The user explicitly names `$superpowers-openspec-execution-workflow`
- The user explicitly asks for Superpowers exploration, OpenSpec locking, then Superpowers execution and archive
- The current turn is a follow-up that confirms, revises, or continues `tasks.md` that this workflow generated earlier in the same request
- A repository policy explicitly requires this workflow

## Continuation Gate

- If this workflow already produced OpenSpec artifacts for the current request and the user is now confirming, revising, or continuing the generated `tasks.md`, keep this workflow active even if the user does not repeat the skill name.
- Treat task edits or confirmation as a continuation turn inside the same orchestrated flow, not as a fresh routing decision.
- After the user confirms the task checklist, keep this workflow active, pause for the explicit execution-development prompt, and do not fall back to OpenSpec apply.
- At that handoff, accept either `继续开发` or `continue-dev` as the continuation command.
- If the user chooses execution development, resume at the next incomplete stage by returning to `$superpowers-feature-workflow` for planning, TDD, and verification.
- After execution development completes, ask whether to continue code review as a separate follow-up step.
- At that later handoff, accept either `继续审查` or `continue-review` as the continuation command.
- If archive is the next aligned step, accept either `继续归档` or `continue-archive`, while `$openspec-archive-change` remains valid.
- If the user revises tasks instead of confirming them, update the OpenSpec task summary, confirm the revised checklist state if needed, then continue the same workflow rather than falling back to generic OpenSpec apply guidance.

## Deliverables

- Design draft in `docs/superpowers/specs/`
- OpenSpec artifacts under `openspec/changes/<change-name>/`
- Implementation plan in `docs/superpowers/plans/`
- Code, tests, and fresh verification evidence
- Updated Superpowers memory and memory validation evidence when memory is in use
- Optional closeout helper output when the closeout helper was used
- Archived OpenSpec change when the work is complete

## Recommended Prompt

```text
Use $superpowers-openspec-execution-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```
