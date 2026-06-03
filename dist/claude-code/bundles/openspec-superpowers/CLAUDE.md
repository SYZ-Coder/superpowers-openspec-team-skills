# Project Workflow

These workflow instructions are explicit opt-in. Do not apply them by default. Only use them when the user explicitly asks for the workflow or invokes its command.

Prefer the `openspec-superpowers-workflow` command when a feature should start with OpenSpec artifacts, then use Superpowers for implementation planning, TDD, and verification.

OpenSpec is only the artifact-locking stage in this combined workflow. After `tasks.md` is complete, do not continue with OpenSpec apply-style implementation. Summarize the generated tasks and, by default, get explicit user confirmation on the OpenSpec task checklist before handing off to Superpowers execution for planning, TDD, and fresh verification.

Do not stop with a readiness prompt such as "run /opsx:apply" or "let me start implementation". If the user explicitly asked to continue directly after OpenSpec tasks, you may skip the confirmation pause. Otherwise, do not continue directly into Superpowers execution after OpenSpec artifacts until the user has explicitly confirmed the generated `tasks.md`.

If `.superpowers-memory/` exists in the repository, treat it as shared project memory and keep it up to date during the workflow.
