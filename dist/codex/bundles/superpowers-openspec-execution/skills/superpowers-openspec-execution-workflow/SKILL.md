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

This is an explicit opt-in workflow. Do not use it by default. Only use it when the user explicitly asks for it, names `$superpowers-openspec-execution-workflow`, or a repository policy explicitly requires it.

If `.superpowers-memory/` exists in the repository, read it at the start and update it before the session ends.

## Workflow

1. Explore the repository context before proposing solutions.
2. Clarify requirements one question at a time until the scope and success criteria are clear.
3. Present 2-3 approaches, recommend one, and wait for approval before implementation work.
4. Write the approved design to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`.
5. Ask the user to confirm the written design before continuing.
6. Only after the confirmed Superpowers design exists, derive or confirm a kebab-case OpenSpec change name.
7. Run `openspec status --change "<change-name>" --json` to inspect required artifact order.
8. Before writing each artifact, run `openspec instructions <artifact> --change "<change-name>" --json`.
9. Complete the OpenSpec artifacts in dependency order:
   - `proposal.md`
   - `design.md`
   - `specs/.../spec.md`
   - `tasks.md`
10. Re-check `openspec status --change "<change-name>" --json` until all required artifacts are ready.
11. Stop OpenSpec apply-style execution and hand off to Superpowers execution.
12. Write the implementation plan to `docs/superpowers/plans/YYYY-MM-DD-<topic>.md`.
13. Prefer a repo-local worktree when the task is non-trivial or risky.
14. Implement with TDD:
   - write the failing test first
   - run it to confirm failure
   - write the minimal implementation
   - run tests again to confirm success
15. Run fresh verification commands before any completion claim.
16. If code, specs, and verification are aligned, archive the change with the OpenSpec archive flow.
17. If `.superpowers-memory/` exists, update `CURRENT_STATE.md` and add a short session journal entry.

## Guardrails

- When the user names `$superpowers-openspec-execution-workflow`, this orchestrator controls routing; do not route first to `$openspec-feature-workflow`, `openspec-propose`, `/opsx:propose`, or any OpenSpec proposal skill.
- Mentioning OpenSpec in this workflow name is not permission to start OpenSpec proposal generation.
- Do not invoke OpenSpec artifact generation, `openspec-propose`, or `$openspec-feature-workflow` before Superpowers exploration is complete.
- Superpowers exploration is complete only after context review, requirement clarification, approach comparison, user confirmation of the solution shape, and a design draft under `docs/superpowers/specs/`.
- Do not start implementation before the design is approved.
- Do not start coding until required OpenSpec artifacts are complete.
- Do not use OpenSpec apply as the implementation stage for this workflow.
- After OpenSpec `tasks.md` is complete, stop OpenSpec apply-style execution and hand off to Superpowers execution.
- Do not stop after OpenSpec artifacts with a readiness message such as "run apply", "/opsx:apply", or "let me start implementation".
- Unless the user explicitly asked to pause after OpenSpec artifacts, continue directly into Superpowers execution by writing the implementation plan.
- Treat OpenSpec tasks as constraints and checklist input for the Superpowers implementation plan.
- Do not report success without fresh verification evidence.
- Do not archive the change until code, tests, and specs are aligned.
