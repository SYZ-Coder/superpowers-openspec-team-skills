# Verification Baseline

Use this file for the verification commands and evidence standards that the team considers trustworthy for this project.

## Entry Template

```md
### Verification Rule: <short-title>
- id: verification-YYYY-MM-DD-<slug>
- type: verification_rule
- status: active
- confidence: verified
- last_updated: YYYY-MM-DD
- source:
- owner:
- review_after:

Command or method:

What it validates:

What it does not validate:

Evidence expected:
```

## Notes

- Prefer commands that are reproducible and already used successfully by the team.
- Record known blind spots so future sessions do not overclaim confidence.
- Durable entries should always include `id`, `status`, `confidence`, `source`, `last_updated`, and `review_after`.
- If the rule is `verified`, the `source` should point to a successful command, log, test, or documented evidence.
