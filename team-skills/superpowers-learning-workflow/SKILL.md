---
name: superpowers-learning-workflow
description: Use when the user explicitly wants to capture lessons from completed work, persist durable project knowledge, or turn repeated patterns into reusable learning notes for future sessions.
---

# Superpowers Learning Workflow

## Overview

Use this workflow after meaningful work to capture what should survive the current session. It is a lightweight, repo-owned learning loop inspired by reflective agent systems, but scoped for safe use inside normal project workflows.

This is an explicit opt-in workflow. Do not use it by default. Only use it when the user explicitly asks for this workflow, names this skill, or a repository policy explicitly requires it.

## Workflow

1. Review the recent work, decisions, and verification evidence.
2. Classify what was learned into four buckets:
   - durable project facts
   - current working state
   - session outcome
   - reusable method or repeated pitfall
3. Add required metadata for durable entries:
   - `id`
   - `status`
   - `confidence`
   - `source`
   - `last_updated`
   - `review_after`
   Do not mark an entry as `verified` if `source` is empty.
4. If `.superpowers-memory/` exists, update:
   - `PROJECT_CONTEXT.md` for durable facts
   - `CURRENT_STATE.md` for active state
   - `DECISIONS.md` for lasting decisions
   - `KNOWN_FAILURES.md` for repeated failure patterns
   - `VERIFICATION_BASELINE.md` for trusted verification rules
   - `TEAM_PREFERENCES.md` for durable team agreements
   - `USER_PROFILE.md` for durable user preferences that are not project facts
   - `AGENT_NOTES.md` for durable execution reminders that are not project facts
   - `session-journal/` for the session summary
   - `LEARNING_BACKLOG.md` for reusable patterns that may deserve future workflows or skills
5. If `.superpowers-memory/` does not exist, tell the user to install the memory scaffold or keep the learning summary in a normal project doc.
6. Check whether any backlog item is strong enough to recommend promotion into a checklist, project rule, workflow step, script, or skill draft.
7. Review `.superpowers-memory/SESSION_CLOSE_CHECKLIST.md` before finishing the learning capture.
8. Use `scripts/suggest-superpowers-memory-updates.ps1` if it is unclear which memory surfaces should be updated from the current session signals.
9. Prefer `scripts/run-superpowers-memory-closeout.ps1` as the standard closeout helper when you want one command to review the checklist, get update suggestions, and optionally run validation.
10. When memory files were updated, run `scripts/validate-superpowers-memory.ps1` and include the result in the summary.
11. Use `scripts/search-superpowers-memory.ps1` when you need to confirm whether a pattern already exists in durable memory or recent journals.
12. Summarize what was learned and what, if anything, should become a future rule, checklist, script, or skill.

## When to Use

- The user explicitly asks to capture lessons from the current session
- The user explicitly names `$superpowers-learning-workflow`
- The user wants to persist durable knowledge for future sessions
- The user wants to turn repeated patterns into reusable learning notes
- A repository policy explicitly requires reflective capture after meaningful work

## Outputs

- Updated `.superpowers-memory/PROJECT_CONTEXT.md` when durable facts changed
- Updated `.superpowers-memory/CURRENT_STATE.md`
- Updated `.superpowers-memory/DECISIONS.md` when durable decisions changed
- Updated `.superpowers-memory/KNOWN_FAILURES.md` when repeated failure patterns were identified
- Updated `.superpowers-memory/VERIFICATION_BASELINE.md` when trusted verification rules changed
- Updated `.superpowers-memory/TEAM_PREFERENCES.md` when durable team agreements changed
- Updated `.superpowers-memory/USER_PROFILE.md` when durable user preferences changed
- Updated `.superpowers-memory/AGENT_NOTES.md` when durable execution reminders changed
- New or updated session journal entry
- Updated `.superpowers-memory/LEARNING_BACKLOG.md` for reusable lessons
- Updated `.superpowers-memory/SESSION_CLOSE_CHECKLIST.md` only as a reference checklist, not as a session log
- Memory validation evidence when memory was updated
- Optional memory update suggestion evidence when the suggestion script was used
- Optional closeout helper output when the closeout script was used
- A short summary of what should be remembered next time

## Guardrails

- Do not write temporary TODO noise into `PROJECT_CONTEXT.md`
- Do not turn a one-off fix into a reusable rule without a clear repeated pattern
- Do not auto-edit the skill library itself unless the user explicitly asks for that separate step
- Keep learning notes concise and actionable
- Do not promote a backlog item without enough repeated evidence or cross-session value
- Treat `ready_for_promotion` as a higher bar: expect repeated evidence, linked sources, and a reviewable promotion rationale
