# Agent Workflow

This workflow is explicit opt-in. Do not apply it by default. Only apply it when the user explicitly asks for this workflow or names it in chat.

If `.superpowers-memory/` exists in the repository, treat it as shared project memory and keep it up to date during the workflow.

When the user asks for OpenSpec + Superpowers feature delivery, follow this OpenSpec-first order:

1. Clarify the requested behavior only as needed for accurate OpenSpec artifacts.
2. Complete OpenSpec proposal, design, specs, and tasks.
3. Stop OpenSpec apply-style execution.
4. Present the generated OpenSpec task checklist to the user.
5. By default, wait for explicit confirmation before implementation planning starts.
6. If the user explicitly asked to continue directly after OpenSpec tasks, skip the confirmation pause and hand off to Superpowers execution.
7. Otherwise, hand off to Superpowers execution only after the user confirms the generated `tasks.md`.
8. Implement with TDD.
9. Run fresh verification before any completion claim.

OpenSpec is only the artifact-locking stage in this combined workflow. Once `tasks.md` exists and is complete, do not keep implementing through OpenSpec apply. Summarize the generated tasks and, by default, get user confirmation on the OpenSpec task checklist before using those tasks as input for the Superpowers plan, TDD, and verification stages.

Do not stop with a readiness prompt such as "run /opsx:apply" or "let me start implementation". If the user explicitly asked to continue directly after OpenSpec tasks, you may skip the confirmation pause. Otherwise, do not continue directly into Superpowers execution after OpenSpec artifacts until the user has explicitly confirmed the generated `tasks.md`.
