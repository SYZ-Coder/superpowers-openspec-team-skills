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

Then describe the feature request. The skill will route work through Superpowers discovery, OpenSpec artifacts, implementation planning, TDD, and final verification.

If you also want to preserve what the session taught the team, run `superpowers-learning-workflow` after delivery is complete.

## Control Points

- Design approval is required before implementation planning.
- OpenSpec artifacts must be completed before coding starts.
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
