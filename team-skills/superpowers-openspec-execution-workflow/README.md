# Superpowers -> OpenSpec -> Superpowers Workflow

## What It Does

`superpowers-openspec-execution-workflow` runs feature work in three stages:

1. Explore and shape the solution with Superpowers.
2. Lock the agreed behavior with OpenSpec artifacts.
3. Return to Superpowers for implementation, testing, verification, and change completion.

It is best when a team wants exploration first, specification second, and disciplined execution last.

## When To Use It

- The feature is still fuzzy and needs discovery before formal specs.
- The team wants OpenSpec artifacts after the design direction is understood.
- The work changes behavior and should be implemented with explicit tests and verification.
- The change should be archived after implementation and specs are aligned.

## How To Use It

Invoke the workflow with a feature request:

```text
Use $superpowers-openspec-execution-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```

This makes the intended order explicit and prevents the agent from jumping straight into code.

## Control Points

- No production code during exploration.
- No coding until required OpenSpec artifacts are ready.
- No completion claim without fresh verification output.
- No archive until implementation, tests, and specs match.

## Expected Outputs

- Superpowers design draft under `docs/superpowers/specs/`
- OpenSpec proposal, design, specs, and tasks under `openspec/changes/<change-name>/`
- Superpowers implementation plan under `docs/superpowers/plans/`
- Verified code changes
- Archived OpenSpec change when complete

## Advantages

- Separates discovery from specification, so teams do not freeze unclear requirements too early.
- Keeps OpenSpec focused on agreed behavior instead of brainstorming notes.
- Brings TDD and verification back into the implementation stage.
- Supports a clean finish by archiving completed OpenSpec changes.
