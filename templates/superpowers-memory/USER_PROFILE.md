# User Profile

Use this file for durable user-facing preferences that are helpful across sessions but are not project facts.

## Entry Template

```md
### User Preference: <short-title>
- id: user-YYYY-MM-DD-<slug>
- type: user_preference
- status: active
- confidence: verified
- last_updated: YYYY-MM-DD
- source:
- owner:
- review_after:

Preference:

Why it matters:

How to apply it:
```

## Notes

- Keep this separate from `PROJECT_CONTEXT.md` so user preferences do not pollute project facts.
- Prefer durable interaction preferences over one-off requests.
- If a preference changes, update the entry or mark it `superseded`.
