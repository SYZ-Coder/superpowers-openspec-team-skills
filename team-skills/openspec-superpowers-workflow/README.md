# OpenSpec + Superpowers Workflow

## What It Does

`openspec-superpowers-workflow` is the full feature-delivery entrypoint.

It combines Superpowers-style discovery, design confirmation, implementation planning, TDD, and verification with OpenSpec's durable proposal, design, spec, and task artifacts.

Use it when a feature needs both disciplined implementation and a formal change record before code changes begin.

## When To Use It

- A request explicitly asks for OpenSpec plus Superpowers.
- A non-trivial feature needs clarification, proposal, design, tasks, implementation, tests, and verification.
- The repository or team policy requires OpenSpec artifacts before behavior changes.
- You want one workflow entrypoint to coordinate the full path from idea to verified delivery.

## How To Use It

Invoke the workflow directly in your agent prompt:

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

Then describe the feature request. The workflow should route work through Superpowers discovery, OpenSpec artifacts, task review, implementation planning, TDD, and final verification.

Typical confirmation-first example:

```text
Use $openspec-superpowers-workflow for this feature.
After OpenSpec tasks are generated, show them to me and wait for my confirmation before implementation.
```

Typical direct-execution example:

```text
Use $openspec-superpowers-workflow for this feature.
After OpenSpec tasks are generated, continue directly into implementation.
```

## Workflow Sequence

1. Use Superpowers to explore context, clarify requirements, compare approaches, and confirm design direction.
2. Use OpenSpec to create or complete `proposal.md`, `design.md`, spec deltas, and `tasks.md`.
3. Review the generated OpenSpec `tasks.md` with the user.
4. Return to Superpowers for implementation planning, TDD, execution, and fresh verification.
5. Optionally follow with review or archive steps when the broader project flow requires them.

If the session should also preserve durable lessons or project state, follow delivery with `superpowers-learning-workflow`.

## Control Points

- Design approval is required before implementation planning.
- OpenSpec artifacts must be completed before coding starts.
- By default, generated OpenSpec `tasks.md` should be reviewed and explicitly confirmed before implementation planning starts.
- If the user explicitly requests direct execution after task generation, that pause can be skipped.
- Once `tasks.md` is confirmed, the workflow should stay active and should not fall back to OpenSpec apply.
- After execution and verification finish, review should be a later follow-up step rather than the first branch after task confirmation.
- Implementation should follow the Superpowers plan and TDD discipline.
- Completion claims require fresh verification evidence.

## Expected Outputs

- Design doc under `docs/superpowers/specs/`
- OpenSpec change under `openspec/changes/<change-name>/`
- Implementation plan under `docs/superpowers/plans/`
- Code changes, tests, and verification output
- Optional follow-up: updated `.superpowers-memory/` files and reusable learning notes through `superpowers-learning-workflow`

## Advanced Notes

- `task_confirmation_mode` supports `required`, `optional`, and `off`.
- Default behavior is `optional`.
- After `tasks.md` is confirmed, the next handoff should be execution development rather than OpenSpec apply.
- Review should happen only after execution and verification are complete.
- Useful continuation commands are `continue-dev`, `continue-review`, and `continue-archive`.
- Original OpenSpec and Superpowers commands still remain valid; the continuation commands are optional shortcuts.

## Advantages

- Gives teams a single, memorable entrypoint for complex feature work.
- Keeps exploratory thinking, formal specifications, and implementation discipline connected.
- Reduces skipped steps by making gates explicit.
- Produces durable artifacts that help future maintainers understand why a change exists.
