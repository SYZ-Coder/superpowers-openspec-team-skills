Use this workflow only when the user explicitly asks for it or explicitly invokes this command.

Required order:

1. Confirm a kebab-case change name.
2. Run `openspec status --change "<change-name>" --json`.
3. Read `openspec instructions <artifact> --change "<change-name>" --json` before each artifact.
4. Complete `proposal.md`, `design.md`, `specs/.../spec.md`, and `tasks.md`.
5. Re-run status until required artifacts are complete.
