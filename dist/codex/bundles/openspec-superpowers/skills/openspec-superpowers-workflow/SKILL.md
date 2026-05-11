---
name: openspec-superpowers-workflow
description: Standalone Codex workflow for OpenSpec-first artifacts, then Superpowers implementation planning, TDD, and verification.
---

# OpenSpec + Superpowers Workflow

Use this standalone skill when a feature should start with OpenSpec proposal, design, specs, and tasks before handing off to Superpowers implementation planning, TDD, and verification.

This is an explicit opt-in workflow. Do not use it by default. Only use it when the user explicitly asks for it, names `$openspec-superpowers-workflow`, or a repository policy explicitly requires it.

If `.superpowers-memory/` exists in the repository, read it before planning and update it before closing the workflow.

## Workflow

1. Explore the repository context enough to understand the requested behavior change.
2. Clarify requirements one question at a time only as needed to write accurate OpenSpec artifacts.
3. Derive or confirm a kebab-case OpenSpec change name.
4. Run `openspec status --change "<change-name>" --json` to inspect required artifact order.
5. Before writing each artifact, run `openspec instructions <artifact> --change "<change-name>" --json`.
6. Complete the change artifacts in dependency order:
   - `proposal.md`
   - `design.md`
   - `specs/.../spec.md`
   - `tasks.md`
7. Re-check `openspec status --change "<change-name>" --json` until all required artifacts are ready.
8. Stop OpenSpec apply-style execution and hand off to Superpowers execution.
9. Write the implementation plan to `docs/superpowers/plans/YYYY-MM-DD-<topic>.md`.
10. Prefer a repo-local worktree when the task is non-trivial or risky.
11. Implement with TDD:
   - write the failing test first
   - run it to confirm failure
   - write the minimal implementation
   - run tests again to confirm success
12. Run fresh verification commands before any completion claim.
13. If the project uses OpenSpec archive flow, archive the change after code, specs, and tests are aligned.

## Guardrails

- Do not skip required OpenSpec artifacts for behavior changes.
- Do not use OpenSpec apply as the implementation stage for this combined workflow.
- After OpenSpec `tasks.md` is complete, stop OpenSpec apply-style execution and hand off to Superpowers execution.
- Do not stop after OpenSpec artifacts with a readiness message such as "run apply", "/opsx:apply", or "let me start implementation".
- Unless the user explicitly asked to pause after OpenSpec artifacts, continue directly into Superpowers execution by writing the implementation plan.
- Treat OpenSpec tasks as constraints and checklist input for the Superpowers implementation plan.
- Do not report success without fresh verification evidence.
- Keep paths repo-local and avoid machine-specific assumptions.

## Deliverables

- OpenSpec change under `openspec/changes/<change-name>/`
- Implementation plan under `docs/superpowers/plans/`
- Code, tests, and verification output
