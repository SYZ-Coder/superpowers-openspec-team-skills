# OpenSpec + Superpowers Workflow

## What It Does

`openspec-superpowers-workflow` is the full feature-delivery entrypoint. It combines Superpowers-style discovery and disciplined implementation with OpenSpec's durable proposal, design, spec, and task artifacts.

Use it when a feature needs both human-readable planning and formal change records before code changes begin.

## When To Use It

- A request explicitly asks for OpenSpec plus Superpowers.
- A non-trivial feature needs clarification, proposal, design, tasks, implementation, tests, and verification.
- The repository or team policy requires OpenSpec artifacts before behavior changes.
- You want one workflow skill to coordinate the complete path from idea to verified delivery.

## How To Use It

Invoke the skill directly in your agent prompt:

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

Then describe the feature request. The skill will route work through Superpowers discovery, OpenSpec artifacts, OpenSpec task review, implementation planning, TDD, and final verification.

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
Use $openspec-superpowers-workflow for this feature.
After OpenSpec tasks are generated, show them to me and wait for my confirmation before implementation.
```

This is a good fit when you want to review the OpenSpec task breakdown before choosing whether to continue execution development.

```text
Use $openspec-superpowers-workflow for this feature.
After OpenSpec tasks are generated, show me the task checklist first. After I confirm it, ask whether to continue execution development.
```

This is a good fit when you want a fixed post-task pause before execution, and a separate code-review prompt only after execution and verification finish.

If you also want to preserve what the session taught the team, run `superpowers-learning-workflow` after delivery is complete.

## Control Points

- Design approval is required before implementation planning.
- OpenSpec artifacts must be completed before coding starts.
- By default, the generated OpenSpec `tasks.md` should be reviewed and explicitly confirmed by the user before implementation planning starts.
- After `tasks.md` is confirmed, the workflow should pause and ask whether to continue execution development.
- If task confirmation happens on a later turn, that turn is still part of the same workflow and should not fall back to OpenSpec apply.
- After execution and verification finish, the workflow should ask whether to continue code review.
- You can answer those handoffs with `继续开发` / `continue-dev` and later `继续审查` / `continue-review`.
- If archive is the next step, you can also use `继续归档` / `continue-archive`, or continue with `$openspec-archive-change`.
- Implementation should follow the Superpowers plan and TDD discipline.
- Completion claims require fresh verification evidence.

## Expected Outputs

- Design doc under `docs/superpowers/specs/`
- OpenSpec change under `openspec/changes/<change-name>/`
- Implementation plan under `docs/superpowers/plans/`
- Code changes, tests, and verification output
- Optional follow-up: updated `.superpowers-memory/` files and reusable learning notes through `superpowers-learning-workflow`

## Advantages

- Gives teams a single, memorable entrypoint for complex feature work.
- Keeps exploratory thinking, formal specifications, and implementation discipline connected.
- Reduces skipped steps by making gates explicit.
- Produces durable artifacts that help future maintainers understand why a change exists.
