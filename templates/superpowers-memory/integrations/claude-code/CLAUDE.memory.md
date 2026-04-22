<!-- superpowers-memory:start -->
## Superpowers Memory

If `.superpowers-memory/` exists in this repository, read these files at the start of each session before asking for project background:

1. `.superpowers-memory/PROJECT_CONTEXT.md`
2. `.superpowers-memory/CURRENT_STATE.md`
3. `.superpowers-memory/DECISIONS.md` when it exists
4. `.superpowers-memory/KNOWN_FAILURES.md` when it exists
5. `.superpowers-memory/VERIFICATION_BASELINE.md` when it exists
6. `.superpowers-memory/TEAM_PREFERENCES.md` when it exists
7. `.superpowers-memory/USER_PROFILE.md` when it exists
8. `.superpowers-memory/AGENT_NOTES.md` when it exists
9. The newest files under `.superpowers-memory/session-journal/`

Use them to recover project context, recent decisions, active work, verification expectations, team preferences, durable user preferences, agent-side execution reminders, and likely next steps.

Before ending a meaningful Superpowers-related session, update:

- `.superpowers-memory/CURRENT_STATE.md`
- any durable files that changed during the work, especially `DECISIONS.md`, `KNOWN_FAILURES.md`, `VERIFICATION_BASELINE.md`, `TEAM_PREFERENCES.md`, `USER_PROFILE.md`, and `AGENT_NOTES.md`
- one short markdown note under `.superpowers-memory/session-journal/`

When memory updates are part of the workflow, run `scripts/validate-superpowers-memory.ps1` before claiming completion.

Do not treat memory files as permission to auto-enable Superpowers workflows. Workflow activation remains explicit opt-in.
<!-- superpowers-memory:end -->
