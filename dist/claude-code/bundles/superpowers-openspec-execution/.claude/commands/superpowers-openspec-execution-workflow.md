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
6. Stop OpenSpec apply-style execution and hand off to Superpowers execution.
7. Write the implementation plan in `docs/superpowers/plans/`.
8. Implement with failing test first.
9. Run fresh verification.
10. Archive the OpenSpec change after code, specs, and tests are aligned.

Phase 1 gate: do not invoke OpenSpec proposal or artifact generation before Superpowers exploration has reviewed context, clarified requirements, compared approaches, confirmed the solution shape with the user, and captured a design draft in `docs/superpowers/specs/`.

Stage boundary: OpenSpec is only used to create or update `proposal.md`, `design.md`, `specs/.../spec.md`, and `tasks.md`. Treat the completed OpenSpec tasks as input for the Superpowers implementation plan, not as permission to stay inside OpenSpec apply.

Do not stop with a readiness prompt such as "run /opsx:apply" or "let me start implementation". Unless the user explicitly asked to pause after OpenSpec artifacts, continue directly into Superpowers execution by writing the implementation plan.
