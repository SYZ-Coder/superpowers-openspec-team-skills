# Project Workflow

These workflow instructions are explicit opt-in. Do not apply them by default. Only use them when the user explicitly asks for the workflow or invokes its command.

If this workflow already produced `tasks.md` for the current request and the next user turn confirms, revises, or continues those tasks, keep this workflow active even if the command is not repeated.

Prefer the `openspec-superpowers-workflow` command when a feature should start with OpenSpec artifacts, then use Superpowers for implementation planning, TDD, and verification.

OpenSpec is only the artifact-locking stage in this combined workflow. After `tasks.md` is complete, do not continue with OpenSpec apply-style implementation. Summarize the generated tasks, get explicit user confirmation on the OpenSpec task checklist, then pause again and ask whether to continue execution development before handing off to Superpowers execution for planning, TDD, and fresh verification.

Do not stop with a readiness prompt such as "run /opsx:apply" or "let me start implementation". After OpenSpec artifacts are confirmed, do not continue directly into Superpowers execution until the user has explicitly chosen execution as the next step.

When the user confirms or revises the generated tasks on a later turn, treat that turn as the continuation of this workflow instead of rerouting to generic OpenSpec handling. After confirmation, the next required action is to ask whether to continue execution development. After execution and verification finish, ask whether to continue code review.
Accept `继续开发` / `continue-dev` for the first handoff and `继续审查` / `continue-review` for the second.
If archive is the next aligned step, also accept `继续归档` / `continue-archive`, while `$openspec-archive-change` remains usable.

If `.superpowers-memory/` exists in the repository, treat it as shared project memory and keep it up to date during the workflow.
