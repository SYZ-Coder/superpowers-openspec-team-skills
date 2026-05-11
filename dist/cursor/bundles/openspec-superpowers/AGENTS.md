# Agent Workflow

This workflow is explicit opt-in. Do not apply it by default. Only apply it when the user explicitly asks for this workflow or names it in chat.

If `.superpowers-memory/` exists in the repository, treat it as shared project memory and keep it up to date during the workflow.

When the user asks for OpenSpec + Superpowers feature delivery, follow this OpenSpec-first order:

1. Clarify the requested behavior only as needed for accurate OpenSpec artifacts.
2. Complete OpenSpec proposal, design, specs, and tasks.
3. Stop OpenSpec apply-style execution.
4. Hand off to Superpowers execution and write the implementation plan.
5. Implement with TDD.
6. Run fresh verification before any completion claim.

OpenSpec is only the artifact-locking stage in this combined workflow. Once `tasks.md` exists and is complete, do not keep implementing through OpenSpec apply. Use the OpenSpec tasks as input for the Superpowers plan, TDD, and verification stages.

Do not stop with a readiness prompt such as "run /opsx:apply" or "let me start implementation". Unless the user explicitly asked to pause after OpenSpec artifacts, continue directly into Superpowers execution by writing the implementation plan.
