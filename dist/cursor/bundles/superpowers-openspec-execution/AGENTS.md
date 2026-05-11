# Agent Workflow

This workflow is explicit opt-in. Do not apply it by default. Only apply it when the user explicitly asks for this workflow or names it in chat.

Highest-priority router: if the current user message contains `superpowers-openspec-execution-workflow`, do not invoke `openspec-propose`, `/opsx:propose`, `$openspec-feature-workflow`, or create an OpenSpec proposal as the first action. Start with Superpowers exploration. If OpenSpec proposal generation already started for this request, stop that route and restart from Superpowers exploration.

Routing override: when the user names `superpowers-openspec-execution-workflow` or asks to use this workflow, do not select `openspec-propose`, `/opsx:propose`, `$openspec-feature-workflow`, or any OpenSpec proposal skill as the first active skill. The first assistant action must be Superpowers exploration. Mentioning OpenSpec in the workflow name is not permission to start OpenSpec proposal generation.

When the user wants the three-stage delivery path:

1. Explore and converge with Superpowers
2. Lock the confirmed behavior with OpenSpec
3. Return to Superpowers for implementation, testing, and verification
4. Archive the OpenSpec change when complete

The first active phase must be Superpowers exploration. Do not invoke `openspec-propose`, `$openspec-feature-workflow`, or OpenSpec artifact generation until project context has been reviewed, requirements have been clarified, approaches have been compared, the user has confirmed the solution shape, and a design draft exists in `docs/superpowers/specs/`.

The OpenSpec stage ends after `proposal.md`, `design.md`, `specs/.../spec.md`, and `tasks.md` are complete. Do not continue into OpenSpec apply-style implementation. After task generation, hand off to Superpowers execution: write the implementation plan, implement with TDD, run fresh verification, then return to OpenSpec only for archive after alignment.

Do not stop with a readiness prompt such as "run /opsx:apply" or "let me start implementation". Unless the user explicitly asked to pause after OpenSpec artifacts, continue directly into Superpowers execution by writing the implementation plan.

If `.superpowers-memory/` exists in the repository, read it at the start and update it before the session ends.
