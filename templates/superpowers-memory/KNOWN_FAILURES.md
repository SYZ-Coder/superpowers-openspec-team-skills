# Known Failures

Use this file for repeated failure modes, environment pitfalls, process traps, and recurring misjudgments.

## Entry Template

```md
### Failure Pattern: <short-title>
- id: failure-YYYY-MM-DD-<slug>
- type: failure_pattern
- status: active
- confidence: verified
- last_updated: YYYY-MM-DD
- source:
- owner:
- review_after:

Trigger:

Symptom:

Likely cause:

How to detect:

Mitigation:
```

## Notes

- Prefer repeated or high-impact failures over one-off mistakes.
- If a failure is fully obsolete, mark it as `superseded` and explain why.
- Link to verification evidence when possible.
- Durable entries should always include `id`, `status`, `confidence`, `source`, `last_updated`, and `review_after`.
- Use `review_after` to force periodic re-checks of environment-sensitive failure patterns.
