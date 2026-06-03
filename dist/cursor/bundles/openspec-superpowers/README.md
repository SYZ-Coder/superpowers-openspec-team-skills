# Cursor Bundle: OpenSpec + Superpowers

Copy this bundle into the target repository root. It provides a Cursor rule plus `AGENTS.md` guidance for the OpenSpec-first workflow: OpenSpec artifacts, then Superpowers implementation, TDD, and verification.

Important handoff: OpenSpec is only used to lock the agreed artifacts. After `tasks.md` is complete, the workflow must summarize the generated tasks, get explicit user confirmation on the OpenSpec task checklist, and only then hand off to Superpowers execution for planning, TDD, and verification instead of continuing through OpenSpec apply.

Task confirmation control:

- The default mode is `optional`.
- By default, after OpenSpec `tasks.md` is generated, the workflow shows the tasks and waits for confirmation before implementation.
- To require confirmation explicitly, add: `After OpenSpec tasks are generated, show them to me and wait for my confirmation before implementation.`
- To continue directly, add: `After OpenSpec tasks are generated, continue directly into implementation without waiting for task confirmation.`
