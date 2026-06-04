# Claude Code Bundle: Superpowers -> OpenSpec -> Superpowers

Copy this bundle into the target repository root, then invoke `/superpowers-openspec-superpowers-workflow`.

Recommended use in Claude Code:

```text
/superpowers-openspec-superpowers-workflow
<describe the feature request>
```

Prefer the slash command over natural-language routing so Claude Code reads `.claude/commands/superpowers-openspec-superpowers-workflow.md` and applies the workflow gates consistently.

Important handoff: after OpenSpec `tasks.md` is complete, stop OpenSpec apply-style execution, summarize the generated tasks, get explicit user confirmation on the OpenSpec task checklist, and only then return to Superpowers for the implementation plan, TDD, and fresh verification.
