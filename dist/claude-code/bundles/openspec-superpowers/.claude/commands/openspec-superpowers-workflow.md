Use this workflow only when the user explicitly asks for the full OpenSpec + Superpowers path or explicitly invokes this command.

Required order:

1. Explore context enough to understand the behavior change.
2. Clarify one question at a time only as needed for accurate OpenSpec artifacts.
3. Complete OpenSpec `proposal.md`, `design.md`, `specs/.../spec.md`, and `tasks.md`.
4. Stop OpenSpec apply-style execution and hand off to Superpowers execution.
5. Write the implementation plan in `docs/superpowers/plans/`.
6. Implement with failing test first.
7. Run fresh verification before reporting success.

Stage boundary: OpenSpec is only used to create or update `proposal.md`, `design.md`, `specs/.../spec.md`, and `tasks.md`. Treat the completed OpenSpec tasks as input for the Superpowers implementation plan, not as permission to stay inside OpenSpec apply.

Do not stop with a readiness prompt such as "run /opsx:apply" or "let me start implementation". Unless the user explicitly asked to pause after OpenSpec artifacts, continue directly into Superpowers execution by writing the implementation plan.
