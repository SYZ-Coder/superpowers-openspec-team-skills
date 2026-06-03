# Superpowers -> OpenSpec -> Superpowers Workflow

## What It Does

`superpowers-openspec-execution-workflow` runs feature work in four explicit steps:

1. Explore and shape the solution with Superpowers.
2. Lock the agreed behavior with OpenSpec artifacts.
3. Return to Superpowers for implementation, testing, and verification.
4. Archive the OpenSpec change after implementation, tests, and specs are aligned.

It is best when a team wants exploration first, specification second, disciplined execution third, and OpenSpec archive as the final closeout step.

## When To Use It

- The feature is still fuzzy and needs discovery before formal specs.
- The team wants OpenSpec artifacts after the design direction is understood.
- The work changes behavior and should be implemented with explicit tests and verification.
- The change should be archived after implementation, tests, and specs are aligned.

## How To Use It

Invoke the workflow with a feature request.

Recommended text entry:

```text
Use the superpowers-openspec-execution workflow for this feature.
```

Alternative text entry:

```text
Use $superpowers-openspec-execution-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```

For Cursor, use an explicit text request. The Cursor bundle installs repository rules rather than a native slash-command file. The natural-language form above is the primary example. These entries make the order explicit and help prevent the agent from jumping straight into code.

Default control:

- `task_confirmation_mode: optional`
- By default, the workflow shows the generated OpenSpec `tasks.md` and waits for your confirmation before implementation planning.
- After you confirm the generated task checklist, the workflow should pause once more and ask whether to continue execution development.
- If you confirm or revise that generated task checklist on the next turn, the workflow should stay active, avoid OpenSpec apply, and wait for that execution-development choice.
- Fixed continuation commands: `继续开发` / `continue-dev`, then later `继续审查` / `continue-review`.
- If archive is part of the project flow, you can also use `继续归档` / `continue-archive`.
- Existing workflow commands and skills still work; these continuation commands are shorter optional shortcuts.

Usage examples:

```text
Use the superpowers-openspec-execution workflow for this feature.
After OpenSpec tasks are generated, show them to me and wait for my confirmation before implementation.
```

This is a good fit when you want to inspect the generated task checklist before choosing whether to continue execution development.

```text
Use the superpowers-openspec-execution workflow for this feature.
After OpenSpec tasks are generated, show me the task checklist first. After I confirm it, ask whether to continue execution development.
```

This is a good fit when you want a fixed post-task pause before execution, and a separate code-review prompt only after execution and verification finish.

## Workflow Sequence

1. Use Superpowers to explore context, clarify requirements, compare approaches, and confirm the design direction.
2. Use OpenSpec to write the confirmed change artifacts, including `proposal.md`, `design.md`, `specs/.../spec.md`, and `tasks.md`.
3. Review the generated OpenSpec `tasks.md` with the user and wait for explicit confirmation.
4. Return to Superpowers to write the implementation plan, execute with TDD, and run fresh verification.
5. Archive the OpenSpec change only after the code, tests, and specs are aligned.

If the session produced useful reusable lessons, follow the archive step with `superpowers-learning-workflow` so the next session inherits the right context.

## Control Points

- No production code during exploration.
- No coding until required OpenSpec artifacts are ready.
- By default, there is no implementation planning or coding until the user confirms the generated OpenSpec `tasks.md`.
- After `tasks.md` is confirmed, the workflow should pause and ask whether to continue execution development.
- If task confirmation happens on a later turn, that turn is still part of the same workflow and should not fall back to OpenSpec apply.
- After execution and verification finish, the workflow should ask whether to continue code review.
- You can answer those handoffs with `继续开发` / `continue-dev` and later `继续审查` / `continue-review`.
- If archive is the next step, you can also use `继续归档` / `continue-archive`, or continue with `$openspec-archive-change`.
- No completion claim without fresh verification output.
- No archive until implementation, tests, and specs match.

## Expected Outputs

- Superpowers design draft under `docs/superpowers/specs/`
- OpenSpec proposal, design, specs, and tasks under `openspec/changes/<change-name>/`
- Superpowers implementation plan under `docs/superpowers/plans/`
- Verified code changes
- Archived OpenSpec change when complete
- Optional follow-up: updated `.superpowers-memory/` files and `LEARNING_BACKLOG.md` through `superpowers-learning-workflow`

## Advantages

- Makes the handoff between exploration, specification, execution, and archive explicit.
- Separates discovery from specification, so teams do not freeze unclear requirements too early.
- Keeps OpenSpec focused on agreed behavior instead of brainstorming notes.
- Brings TDD and verification back into the implementation stage before archive.
