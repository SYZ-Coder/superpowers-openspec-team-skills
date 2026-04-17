# Superpowers Learning Workflow

## What It Does

`superpowers-learning-workflow` is a post-work reflection workflow for capturing what should survive the current session.

It is designed to pair naturally with:

- `superpowers-feature-workflow`
- `superpowers-openspec-execution-workflow`
- `openspec-superpowers-workflow`

It helps the team turn recent work into:

1. durable project facts
2. current working state
3. short session history
4. reusable lessons for future workflows or skills

## When To Use It

- A meaningful task or session just finished.
- The team wants the next session to inherit the right context.
- A repeated pitfall or reusable method showed up.
- The user wants to keep learning in the repository instead of losing it in chat history.

## How To Use It

Invoke it after meaningful work:

```text
Use $superpowers-learning-workflow to capture what this session taught us and update the project memory.
```

Typical chaining pattern:

```text
1. Run a delivery workflow
2. Finish implementation and verification
3. Use $superpowers-learning-workflow to preserve what should survive the session
```

## Workflow Sequence

1. Review recent work, decisions, and verification evidence.
2. Separate durable facts from temporary notes.
3. Update `.superpowers-memory/PROJECT_CONTEXT.md` when project facts changed.
4. Update `.superpowers-memory/CURRENT_STATE.md` with the latest active state.
5. Add a short session note under `.superpowers-memory/session-journal/`.
6. Add reusable lessons to `.superpowers-memory/LEARNING_BACKLOG.md`.

## Control Points

- Do not write temporary task noise into stable project context.
- Do not promote one-off fixes into reusable rules too early.
- Do not auto-edit the skill library unless the user explicitly asks for that separate step.

## Expected Outputs

- Updated project memory
- Short learning summary
- Reusable lesson candidates for future skills or checklists

## Advantages

- Preserves useful project context across sessions.
- Separates durable knowledge from temporary work state.
- Gives teams a safe path from session experience to reusable process improvements.
