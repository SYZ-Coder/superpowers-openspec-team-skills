# OpenSpec Feature Workflow

## What It Does

`openspec-feature-workflow` creates and completes the OpenSpec change artifacts required before implementation: proposal, design, specs, and tasks.

It focuses on formalizing the change. It does not manage TDD, worktrees, or implementation verification by itself.

## When To Use It

- The repository requires OpenSpec for non-trivial behavior changes.
- A feature needs `proposal.md`, `design.md`, spec deltas, and `tasks.md` before coding.
- The team wants a durable record of why a change exists and what behavior it introduces.
- You already understand the desired behavior well enough to write formal artifacts.

## How To Use It

Invoke it with a change request:

```text
Use $openspec-feature-workflow to create and complete the OpenSpec change for this feature.
```

The workflow derives or confirms a kebab-case change name, creates the OpenSpec change directory, reads OpenSpec instructions, and completes artifacts in dependency order.

## Control Points

- A change name must be confirmed or derived before artifacts are created.
- `openspec status --change "<change-name>" --json` drives artifact order.
- OpenSpec instructions should be read before writing each artifact.
- Coding should not start until required artifacts are ready.

## Expected Outputs

- `openspec/changes/<change-name>/proposal.md`
- `openspec/changes/<change-name>/design.md`
- `openspec/changes/<change-name>/specs/.../spec.md`
- `openspec/changes/<change-name>/tasks.md`

## Advantages

- Produces consistent OpenSpec artifacts for behavior changes.
- Keeps requirements, design decisions, and implementation tasks connected.
- Makes review easier by separating intent, technical approach, normative behavior, and execution checklist.
- Helps teams avoid coding from vague requests.
