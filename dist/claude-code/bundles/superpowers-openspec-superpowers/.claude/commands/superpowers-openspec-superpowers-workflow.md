Use this workflow only when the user explicitly asks for this sequence or explicitly invokes this command:

1. Explore and converge with Superpowers
2. Lock the confirmed behavior with OpenSpec
3. Return to Superpowers for implementation, testing, and verification
4. Archive the OpenSpec change when complete

Required order:

1. Explore context.
2. Clarify one question at a time.
3. Compare approaches and recommend one.
4. Write and confirm a design in `docs/superpowers/specs/`.
5. Only after the confirmed Superpowers design exists, complete OpenSpec `proposal.md`, `design.md`, `specs/.../spec.md`, and `tasks.md`.
6. Stop OpenSpec apply-style execution, summarize the generated tasks, and ask the user to confirm the OpenSpec task checklist.
7. After the user confirms `tasks.md`, pause again and ask whether to continue execution development.
8. Accept `continue-dev` as the primary continuation command for that handoff.
9. Write the implementation plan in `docs/superpowers/plans/` only after the user chooses execution development.
10. Implement with failing test first.
11. Run fresh verification.
12. After execution development and verification complete, pause again and ask whether to continue code review.
13. Accept `continue-review` as the primary continuation command for that later handoff.
14. Archive the OpenSpec change after code, specs, and tests are aligned.
15. If archive is the next aligned step, accept `continue-archive`, while `/openspec-archive-change` or the project archive flow remains usable.

Phase 1 gate: do not invoke OpenSpec proposal or artifact generation before Superpowers exploration has reviewed context, clarified requirements, compared approaches, confirmed the solution shape with the user, and captured a design draft in `docs/superpowers/specs/`.
Do not begin by listing available OpenSpec skills, proposing `openspec-propose`, or explaining how OpenSpec would usually work. Treat those responses as misroutes for this workflow request.

Stage boundary: OpenSpec is only used to create or update `proposal.md`, `design.md`, `specs/.../spec.md`, and `tasks.md`. Treat the completed OpenSpec tasks as input for the Superpowers implementation plan, not as permission to stay inside OpenSpec apply.

Do not stop with a readiness prompt such as "run /opsx:apply" or "let me start implementation".
Do not continue directly into Superpowers execution after OpenSpec artifacts until the user has explicitly confirmed the generated `tasks.md` and chosen execution development as the next step.
When the user confirms or revises the generated tasks on a later turn, treat that turn as the continuation of this workflow. After confirmation, the next required action is to ask whether to continue execution development.
After code review is complete and archive is not the next step, keep the workflow paused instead of silently finishing.
