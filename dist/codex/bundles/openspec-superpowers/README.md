# Codex Bundle: OpenSpec + Superpowers

Install this bundle when you want one standalone Codex skill for an OpenSpec-first flow: create proposal, design, specs, and tasks before handing off to Superpowers implementation, TDD, and verification.

Install target:

```text
.codex/skills/
```

After installation, invoke:

```text
Use $openspec-superpowers-workflow to run this feature from OpenSpec artifacts through Superpowers verification.
```

Important handoff: OpenSpec is only used to lock the agreed artifacts. After `tasks.md` is complete, the workflow must hand off to Superpowers execution for planning, TDD, and verification instead of continuing through OpenSpec apply.
