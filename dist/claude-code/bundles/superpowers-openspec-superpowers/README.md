# Claude Code Bundle: Superpowers -> OpenSpec -> Superpowers

Copy this bundle into the target repository root, then invoke `/superpowers-openspec-superpowers-workflow`.

Recommended use in Claude Code:

```text
/superpowers-openspec-superpowers-workflow
<describe the feature request>
```

Prefer the slash command over natural-language routing so Claude Code reads `.claude/commands/superpowers-openspec-superpowers-workflow.md` and applies the workflow gates consistently.

Important handoff: after OpenSpec `tasks.md` is complete, stop OpenSpec apply-style execution, summarize the generated tasks, get explicit user confirmation on the OpenSpec task checklist, then pause again and ask whether to continue execution development before returning to Superpowers for the implementation plan, TDD, and fresh verification.

After execution development and verification complete, pause again and ask whether to continue code review.
