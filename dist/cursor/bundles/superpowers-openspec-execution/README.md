# Cursor Bundle: Superpowers -> OpenSpec -> Superpowers

Copy this bundle into the target repository root for the four-stage flow:

1. Superpowers exploration
2. OpenSpec locking
3. Superpowers execution and verification
4. OpenSpec archive

Important handoff: after OpenSpec `tasks.md` is complete, stop OpenSpec apply-style execution and return to Superpowers for the implementation plan, TDD, and fresh verification.

Activation options in Cursor:

```text
Use the superpowers-openspec-execution workflow for this feature.
```

or

```text
Use $superpowers-openspec-execution-workflow for this feature.
```

Cursor does not install a native slash command for this workflow. Use an explicit text request so the repository rules can route the conversation into the intended workflow. The natural-language form above is the primary example.

Example  prompt:

```text
Use the superpowers-openspec-execution workflow for this feature.

Now update the drift-bottle review flow based on 2026-06-02_drift-bottle_create-and-audit-rating-full-chain.md.
Requirements:
1. Remove manual review because there are no reviewers.
2. Keep automatic review if it already exists.
3. Enable the automatic audit flow.
4. When the user finally publishes a drift bottle, default the rating to excellent unless the automatic rating determines otherwise.
Please follow the workflow in order: Superpowers exploration first, then OpenSpec locking, then Superpowers implementation and verification, then archive. Do not start by listing OpenSpec skills or jumping to openspec-propose.
```
