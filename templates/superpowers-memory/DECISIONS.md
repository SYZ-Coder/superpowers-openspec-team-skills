# Decisions

Use this file for important project or workflow decisions that should remain visible across sessions.

## Entry Template

```md
### Decision: <short-title>
- id: decision-YYYY-MM-DD-<slug>
- type: decision
- status: active
- confidence: verified
- last_updated: YYYY-MM-DD
- source:
- owner:
- review_after:

Reason:

Alternatives considered:

Impact:
```

## Notes

- Put only decisions that still matter to future sessions.
- Move outdated decisions to `status: superseded` instead of deleting history blindly.
- Reference code, docs, tests, or session notes when possible.
- Durable entries should always include `id`, `status`, `confidence`, `source`, `last_updated`, and `review_after`.
- Do not mark an entry `confidence: verified` unless `source` points to real evidence.
