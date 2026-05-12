# Claude Code Bundle: Superpowers -> OpenSpec -> Superpowers

Copy this bundle into the target repository root, then invoke `/superpowers-openspec-execution-workflow`.

Recommended use in Claude Code:

```text
/superpowers-openspec-execution-workflow
<describe the feature request>
```

Prefer the slash command over natural-language routing so Claude Code reads `.claude/commands/superpowers-openspec-execution-workflow.md` and applies the workflow gates consistently.

Important handoff: after OpenSpec `tasks.md` is complete, stop OpenSpec apply-style execution and return to Superpowers for the implementation plan, TDD, and fresh verification.
