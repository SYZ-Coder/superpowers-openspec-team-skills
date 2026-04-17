# Agent Workflow

This workflow is explicit opt-in. Do not apply it by default. Only apply it when the user explicitly asks for this workflow or names it in chat.

If `.superpowers-memory/` exists in the repository, treat it as shared project memory and keep it up to date during the workflow.

When the user asks for OpenSpec + Superpowers feature delivery, follow this order:

1. Clarify requirements and compare approaches.
2. Write and confirm the design.
3. Complete OpenSpec proposal, design, specs, and tasks.
4. Write the implementation plan.
5. Implement with TDD.
6. Run fresh verification before any completion claim.
