# Superpowers Feature Workflow

## What It Does

`superpowers-feature-workflow` covers the Superpowers side of feature delivery: discovery, design confirmation, implementation planning, worktree setup, TDD, and final verification.

It does not create OpenSpec artifacts. Use it when you want disciplined implementation without the formal OpenSpec change record.

## When To Use It

- The request needs brainstorming or design confirmation before coding.
- The user wants a written implementation plan.
- The work should use a separate worktree.
- The feature should be implemented with failing tests first and verified before completion.

## How To Use It

Invoke it with the feature request:

```text
Use $superpowers-feature-workflow to drive the Superpowers stages for this feature request.
```

The workflow starts by exploring project context, then asks clarifying questions, compares approaches, writes a design, creates a plan, and guides implementation with tests.

When the work is meaningful and the team wants to preserve lessons for future sessions, follow it with `superpowers-learning-workflow`.

## Control Points

- Project context is explored before proposing solutions.
- Requirements are clarified one question at a time.
- A design is confirmed before implementation planning.
- TDD is expected for new behavior.
- Verification must be fresh before completion is reported.

## Expected Outputs

- Confirmed design document
- Implementation plan
- Code changes
- Tests and verification evidence
- Optional follow-up: updated `.superpowers-memory/` files through `superpowers-learning-workflow`

## Advantages

- Adds structure to feature work without requiring OpenSpec.
- Makes design decisions explicit before code changes.
- Encourages small, testable implementation steps.
- Reduces incomplete finishes by requiring verification evidence.
