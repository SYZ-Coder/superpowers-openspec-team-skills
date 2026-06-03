# Agent Workflow

This workflow is explicit opt-in. Do not apply it by default. Only apply it when the user explicitly asks for this workflow or names it in chat.

If this workflow already produced `tasks.md` for the current request and the next user turn confirms, revises, or continues those tasks, keep this workflow active even if the user does not repeat the workflow name.

Highest-priority router: if the current user message contains `superpowers-openspec-execution-workflow`, `superpowers-openspec-execution workflow`, `Use $superpowers-openspec-execution-workflow`, or another direct request to use the Superpowers -> OpenSpec -> Superpowers workflow, do not invoke `openspec-propose`, `/opsx:propose`, `$openspec-feature-workflow`, or create an OpenSpec proposal as the first action. Start with Superpowers exploration. If OpenSpec proposal generation already started for this request, stop that route and restart from Superpowers exploration.

Routing override: when the user names `superpowers-openspec-execution-workflow`, refers to the `superpowers-openspec-execution` workflow in natural language, or asks to use this workflow, do not select `openspec-propose`, `/opsx:propose`, `$openspec-feature-workflow`, or any OpenSpec proposal skill as the first active skill. The first assistant action must be Superpowers exploration. Mentioning OpenSpec in the workflow name is not permission to start OpenSpec proposal generation.

When the user wants the three-stage delivery path:

1. Explore and converge with Superpowers
2. Lock the confirmed behavior with OpenSpec
3. Return to Superpowers for implementation, testing, and verification
4. Archive the OpenSpec change when complete

The first active phase must be Superpowers exploration. Do not invoke `openspec-propose`, `$openspec-feature-workflow`, or OpenSpec artifact generation until project context has been reviewed, requirements have been clarified, approaches have been compared, the user has confirmed the solution shape, and a design draft exists in `docs/superpowers/specs/`.
Do not begin by listing available OpenSpec skills, proposing `openspec-propose`, or explaining how OpenSpec would usually work. Treat those responses as misroutes for this workflow request.

The OpenSpec stage ends after `proposal.md`, `design.md`, `specs/.../spec.md`, and `tasks.md` are complete. Do not continue into OpenSpec apply-style implementation. After task generation, summarize the generated tasks, get explicit user confirmation on the OpenSpec task checklist, then pause again and ask whether to continue execution development before handing off to Superpowers execution: write the implementation plan, implement with TDD, run fresh verification, then return to OpenSpec only for archive after alignment.

Do not stop with a readiness prompt such as "run /opsx:apply" or "let me start implementation". After OpenSpec artifacts are confirmed, do not continue directly into Superpowers execution until the user has explicitly chosen execution as the next step.

When the user confirms or revises the generated tasks on a later turn, treat that turn as the continuation of this workflow instead of rerouting to generic OpenSpec handling. After confirmation, the next required action is to ask whether to continue execution development. After execution and verification finish, ask whether to continue code review.
Accept `继续开发` / `continue-dev` for the first handoff and `继续审查` / `continue-review` for the second.
If archive is the next aligned step, also accept `继续归档` / `continue-archive`, while `$openspec-archive-change` remains usable.

If `.superpowers-memory/` exists in the repository, read it at the start and update it before the session ends.
