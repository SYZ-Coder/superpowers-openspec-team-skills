# 源码工作流安装说明

`team-skills/` 保存的是本仓库维护使用的 workflow 源定义。

这些目录现在已经不是面向最终用户的主要安装入口。

## 什么时候直接使用 `team-skills/`

只有在下面这些场景里，才建议直接使用 `team-skills/`：

- 维护源码 workflow
- 把 workflow 适配到新的工具
- 构建 `dist/` 下的新 bundle
- 阅读原始 workflow 定义

## 最终用户怎么安装

如果你的目标是把 workflow 装到某个工具里使用，请优先使用预构建 bundle 和安装脚本：

- Codex：`dist/codex/bundles/` 或 `scripts/install-codex.ps1`
- Cursor：`dist/cursor/bundles/` 或 `scripts/install-cursor.ps1`
  对 `superpowers-openspec-superpowers-workflow` 来说，安装后请在 Cursor 中使用显式文本请求来启用；它是通过仓库规则路由的，不是原生 slash command。
- Claude Code：`dist/claude-code/bundles/` 或 `scripts/install-claude-code.ps1`
  对主推荐 workflow 来说，优先使用 `superpowers-openspec-superpowers` bundle。 如果目标项目已经有 `CLAUDE.md`，并且你不想直接覆盖，而是希望把 bundle 里的说明合并进去，可以在 PowerShell 中使用 `-MergeClaudeMd`，或在 shell 安装脚本中使用 `--merge-claude-md`。

可选的 Superpowers 记忆骨架：

- `scripts/install-superpowers-memory.ps1 -ProjectRoot <project-root>`
- `scripts/install-superpowers-memory-integration.ps1 -Tool all -ProjectRoot <project-root>`

它会在目标项目里创建 `.superpowers-memory/`，让 Superpowers 相关 workflow 能读取稳定项目上下文，并把会话摘要、当前状态和经验沉淀写回仓库。

它也可以顺手更新项目级工具说明，让 Codex、Cursor、Claude Code 在新会话开始时更容易自动带上这些上下文。

## 为什么不再推荐直接复制源码 workflow

部分源码 workflow 是编排型 workflow，本身会依赖其他 workflow 或外部 skills。

这种模块化设计对维护者很好，但对最终用户并不友好。用户通常会以为复制一个目录就能直接使用，实际上往往还缺依赖。

所以现在真正推荐的安装路径是 `dist/` 下的 bundle。
