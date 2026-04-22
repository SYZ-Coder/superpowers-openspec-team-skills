# Session Close Checklist

Use this checklist before claiming a memory-aware session is complete.

## Required Checks

- Has `CURRENT_STATE.md` been updated to reflect the real stopping point?
- Is a new `session-journal/` entry needed for this session?
- Did any durable fact, decision, failure pattern, verification rule, or team preference change?
- Do all durable entries written this session include:
  - `id`
  - `status`
  - `confidence`
  - `source`
  - `last_updated`
  - `review_after`
- If any entry is marked `confidence: verified`, does it include real evidence in `source`?
- If any old entry was replaced, was it marked `status: superseded`?

## Promotion Checks

- If a backlog candidate is `ready_for_promotion`, does it have:
  - `evidence_count >= 2`
  - `repeated_times >= 2`
  - `source`
  - `review_after`
  - linked supporting entries

## Final Validation

- Run `scripts/validate-superpowers-memory.ps1` or `scripts/validate-superpowers-memory.sh` when memory changed.
- Review `memory-index.yaml` if the validator refreshed it.
