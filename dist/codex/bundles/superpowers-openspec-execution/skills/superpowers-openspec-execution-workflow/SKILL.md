---
name: superpowers-openspec-execution-workflow
description: Standalone Codex workflow for Superpowers exploration, OpenSpec locking, Superpowers execution, and OpenSpec archive.
---

# Superpowers -> OpenSpec -> Superpowers Workflow

Use this standalone skill when feature delivery should follow this sequence:

1. Explore and converge with Superpowers
2. Lock the confirmed behavior and artifacts with OpenSpec
3. Return to Superpowers for implementation, testing, and verification
4. Archive the OpenSpec change when everything is aligned

## Workflow

1. Explore the repository context before proposing solutions.
2. Clarify requirements one question at a time until the scope and success criteria are clear.
3. Present 2-3 approaches, recommend one, and wait for approval before implementation work.
4. Write the approved design to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`.
5. Ask the user to confirm the written design before continuing.
6. Derive or confirm a kebab-case OpenSpec change name.
7. Run `openspec status --change "<change-name>" --json` to inspect required artifact order.
8. Before writing each artifact, run `openspec instructions <artifact> --change "<change-name>" --json`.
9. Complete the OpenSpec artifacts in dependency order:
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
15. If code, specs, and verification are aligned, archive the change with the OpenSpec archive flow.

## Guardrails

- Do not start implementation before the design is approved.
- Do not start coding until required OpenSpec artifacts are complete.
- Do not report success without fresh verification evidence.
- Do not archive the change until code, tests, and specs are aligned.
