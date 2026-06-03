# Agent Workflow

This workflow is explicit opt-in. Do not apply it by default. Only apply it when the user explicitly asks for this workflow or names it in chat.

If this workflow already produced `tasks.md` for the current request and the next user turn confirms, revises, or continues those tasks, keep this workflow active even if the user does not repeat the workflow name.

If `.superpowers-memory/` exists in the repository, treat it as shared project memory and keep it up to date during the workflow.

When the user asks for OpenSpec + Superpowers feature delivery, follow this OpenSpec-first order:

1. Clarify the requested behavior only as needed for accurate OpenSpec artifacts.
2. Complete OpenSpec proposal, design, specs, and tasks.
3. Stop OpenSpec apply-style execution.
4. Present the generated OpenSpec task checklist to the user.
5. By default, wait for explicit confirmation before implementation planning starts.
6. After the user confirms `tasks.md`, pause again and ask whether to continue execution development.
   Accept either `继续开发` or `continue-dev`.
7. Do not route the confirmed handoff through OpenSpec apply.
8. Only hand off to Superpowers execution if the user chooses execution.
9. Implement with TDD.
10. Run fresh verification before any completion claim.
11. After execution and verification finish, ask whether to continue code review.
   Accept either `继续审查` or `continue-review`.
12. If archive is the next aligned step, ask whether to continue archive.
   Accept either `继续归档` or `continue-archive`, while `$openspec-archive-change` remains usable.

OpenSpec is only the artifact-locking stage in this combined workflow. Once `tasks.md` exists and is complete, do not keep implementing through OpenSpec apply. Summarize the generated tasks, get user confirmation on the OpenSpec task checklist, then pause again and ask whether to continue execution development before using those tasks as input for the Superpowers plan, TDD, and verification stages.

Do not stop with a readiness prompt such as "run /opsx:apply" or "let me start implementation". After OpenSpec artifacts are confirmed, do not continue directly into Superpowers execution until the user has explicitly chosen execution as the next step.

When the user confirms or revises the generated tasks on a later turn, treat that turn as the continuation of this workflow instead of rerouting to generic OpenSpec handling. After confirmation, the next required action is to ask whether to continue execution development. After execution and verification finish, ask whether to continue code review.
