# Superpowers -> OpenSpec -> Superpowers Workflow

## What It Does

`superpowers-openspec-superpowers-workflow` is the workflow for teams that do not want to guess, rush, or lose control halfway through a complex feature.

It starts wide with Superpowers exploration, locks the agreed truth with OpenSpec, then comes back to Superpowers to build, test, verify, and finish the work with confidence.

Use it when the problem is still fuzzy, the change is important, and you want the journey from idea to archive to feel steady instead of chaotic.

## When To Use It

- The feature is still fuzzy and needs discovery before formal specs.
- The team wants OpenSpec artifacts after the design direction is understood.
- The work changes behavior and should be implemented with explicit tests and verification.
- The change should be archived after implementation, tests, and specs are aligned.

## How To Use It

Invoke the workflow with a feature request:

```text
Use the superpowers-openspec-superpowers workflow for this feature.
```

Alternative explicit entry:

```text
Use $superpowers-openspec-superpowers-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```

For Cursor, prefer an explicit text request like the examples above.

Typical confirmation-first example:

```text
Use the superpowers-openspec-superpowers workflow for this feature.
After OpenSpec tasks are generated, show them to me and wait for my confirmation before implementation.
```

Typical direct-execution example:

```text
Use the superpowers-openspec-superpowers workflow for this feature.
After OpenSpec tasks are generated, continue directly into implementation.
```

## Workflow Sequence

1. Use Superpowers to explore context, clarify requirements, compare approaches, and confirm design direction.
2. Use OpenSpec to write the confirmed change artifacts, including `proposal.md`, `design.md`, `specs/.../spec.md`, and `tasks.md`.
3. Review the generated OpenSpec `tasks.md` with the user.
4. Return to Superpowers to write the implementation plan, execute with TDD, and run fresh verification.
5. Archive the OpenSpec change only after the code, tests, and specs are aligned.

If the session produced useful reusable lessons, follow the archive step with `superpowers-learning-workflow`.

## Control Points

- No production code during exploration.
- No coding until required OpenSpec artifacts are ready.
- By default, there is no implementation planning or coding until the user confirms the generated OpenSpec `tasks.md`.
- If the user explicitly requests direct execution after task generation, that pause can be skipped.
- After `tasks.md` is confirmed, the workflow should stay active and should not fall back to OpenSpec apply.
- Code review should happen only after execution and verification finish.
- No completion claim without fresh verification output.
- No archive until implementation, tests, and specs match.

## Expected Outputs

- Superpowers design draft under `docs/superpowers/specs/`
- OpenSpec proposal, design, specs, and tasks under `openspec/changes/<change-name>/`
- Superpowers implementation plan under `docs/superpowers/plans/`
- Verified code changes
- Archived OpenSpec change when complete
- Optional follow-up: updated `.superpowers-memory/` files and `LEARNING_BACKLOG.md` through `superpowers-learning-workflow`

## Advanced Notes

- `task_confirmation_mode` supports `required`, `optional`, and `off`.
- Default behavior is `optional`.
- Once `tasks.md` is confirmed, the next handoff should be execution development rather than OpenSpec apply.
- Useful continuation commands are `continue-dev`, `continue-review`, and `continue-archive`.
- Original OpenSpec and Superpowers commands still remain valid; the continuation commands are optional shortcuts.

## Advantages

- Brings calm to messy feature work by giving exploration, specification, execution, and archive a clear rhythm.
- Prevents the team from coding too early just because the pressure to move is high.
- Keeps OpenSpec focused on agreed behavior instead of half-formed ideas.
- Returns to Superpowers for the part that matters most: building the change well and verifying it honestly.
