# Project Workflow

These workflow instructions are explicit opt-in. Do not apply them by default. Only use them when the user explicitly asks for the workflow or invokes its command.

Prefer the `superpowers-openspec-execution-workflow` command when feature delivery should use Superpowers exploration, OpenSpec locking, Superpowers execution, and OpenSpec archive.

When the user invokes `superpowers-openspec-execution-workflow`, this workflow controls routing. Do not route first to OpenSpec proposal generation, `openspec-propose`, or `/opsx:propose`.

The first active phase must be Superpowers exploration. Do not invoke OpenSpec proposal or artifact-generation steps until context has been reviewed, requirements have been clarified, approaches have been compared, the user has confirmed the solution shape, and a design draft exists in `docs/superpowers/specs/`.

The OpenSpec stage ends after `proposal.md`, `design.md`, `specs/.../spec.md`, and `tasks.md` are complete. Do not continue into OpenSpec apply-style implementation. Hand off to Superpowers execution for planning, TDD, and fresh verification.

Do not stop with a readiness prompt such as "run /opsx:apply" or "let me start implementation". Unless the user explicitly asked to pause after OpenSpec artifacts, continue directly into Superpowers execution by writing the implementation plan.

If `.superpowers-memory/` exists in the repository, read it at the start and update it before the session ends.
