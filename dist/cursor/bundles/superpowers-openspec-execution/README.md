# Cursor Bundle: Superpowers -> OpenSpec -> Superpowers

Copy this bundle into the target repository root for the four-stage flow:

1. Superpowers exploration
2. OpenSpec locking
3. Superpowers execution and verification
4. OpenSpec archive

Important handoff: after OpenSpec `tasks.md` is complete, stop OpenSpec apply-style execution and return to Superpowers for the implementation plan, TDD, and fresh verification.

Activation options in Cursor:

```text
Use $superpowers-openspec-execution-workflow for this feature.
```

or

```text
Use the superpowers-openspec-execution workflow for this feature.
```

Cursor does not install a native slash command for this workflow. Use an explicit text request so the repository rules can route the conversation into the intended workflow.
