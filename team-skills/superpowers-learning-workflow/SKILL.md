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
3. If `.superpowers-memory/` exists, update:
   - `PROJECT_CONTEXT.md` for durable facts
   - `CURRENT_STATE.md` for active state
   - `session-journal/` for the session summary
   - `LEARNING_BACKLOG.md` for reusable patterns that may deserve future workflows or skills
4. If `.superpowers-memory/` does not exist, tell the user to install the memory scaffold or keep the learning summary in a normal project doc.
5. Summarize what was learned and what, if anything, should become a future rule, checklist, or skill.

## When to Use

- The user explicitly asks to capture lessons from the current session
- The user explicitly names `$superpowers-learning-workflow`
- The user wants to persist durable knowledge for future sessions
- The user wants to turn repeated patterns into reusable learning notes
- A repository policy explicitly requires reflective capture after meaningful work

## Outputs

- Updated `.superpowers-memory/PROJECT_CONTEXT.md` when durable facts changed
- Updated `.superpowers-memory/CURRENT_STATE.md`
- New or updated session journal entry
- Updated `.superpowers-memory/LEARNING_BACKLOG.md` for reusable lessons
- A short summary of what should be remembered next time

## Guardrails

- Do not write temporary TODO noise into `PROJECT_CONTEXT.md`
- Do not turn a one-off fix into a reusable rule without a clear repeated pattern
- Do not auto-edit the skill library itself unless the user explicitly asks for that separate step
- Keep learning notes concise and actionable
