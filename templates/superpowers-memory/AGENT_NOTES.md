# Agent Notes

Use this file for durable agent-side reminders about execution quality, repo-specific handling, or recurring operational pitfalls.

## Entry Template

```md
### Agent Note: <short-title>
- id: agent-YYYY-MM-DD-<slug>
- type: agent_note
- status: active
- confidence: verified
- last_updated: YYYY-MM-DD
- source:
- owner:
- review_after:

Reminder:

Why it matters:

How to apply it:
```

## Notes

- Keep this separate from project facts and user preferences.
- Use this file for repeatable execution reminders, not transient scratch notes.
- If a note is no longer relevant, mark it `superseded` instead of silently removing the history.
