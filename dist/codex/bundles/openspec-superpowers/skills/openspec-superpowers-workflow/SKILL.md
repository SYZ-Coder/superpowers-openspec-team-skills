---
name: openspec-superpowers-workflow
description: Standalone Codex workflow for clarification, OpenSpec artifacts, implementation planning, TDD, and verification.
---

# OpenSpec + Superpowers Workflow

Use this standalone skill when a feature should follow a disciplined path from clarification through verification.

This is an explicit opt-in workflow. Do not use it by default. Only use it when the user explicitly asks for it, names `$openspec-superpowers-workflow`, or a repository policy explicitly requires it.

If `.superpowers-memory/` exists in the repository, read it before planning and update it before closing the workflow.

## Workflow

1. Explore the repository context before proposing a solution.
2. Clarify requirements one question at a time until the scope and success criteria are clear.
3. Present 2-3 approaches, recommend one, and wait for approval before implementation work.
4. Write the approved design to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`.
5. Ask the user to confirm the written design before continuing.
6. Derive or confirm a kebab-case OpenSpec change name.
7. Run `openspec status --change "<change-name>" --json` to inspect required artifact order.
8. Before writing each artifact, run `openspec instructions <artifact> --change "<change-name>" --json`.
9. Complete the change artifacts in dependency order:
   - `proposal.md`
   - `design.md`
   - `specs/.../spec.md`
   - `tasks.md`
10. Re-check `openspec status --change "<change-name>" --json` until all required artifacts are ready.
11. Write the implementation plan to `docs/superpowers/plans/YYYY-MM-DD-<topic>.md`.
12. Prefer a repo-local worktree when the task is non-trivial or risky.
13. Implement with TDD:
   - write the failing test first
   - run it to confirm failure
   - write the minimal implementation
   - run tests again to confirm success
14. Run fresh verification commands before any completion claim.
15. If the project uses OpenSpec archive flow, archive the change after code, specs, and tests are aligned.

## Guardrails

- Do not start implementation before the design is approved.
- Do not skip required OpenSpec artifacts for behavior changes.
- Do not report success without fresh verification evidence.
- Keep paths repo-local and avoid machine-specific assumptions.

## Deliverables

- Design doc under `docs/superpowers/specs/`
- OpenSpec change under `openspec/changes/<change-name>/`
- Implementation plan under `docs/superpowers/plans/`
- Code, tests, and verification output
