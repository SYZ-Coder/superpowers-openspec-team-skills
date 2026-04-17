# 团队 Skills

这个目录包含团队在 OpenSpec + Superpowers 流程下使用的多个可移植 skill 包。

当前包含：

- `openspec-superpowers-workflow`
- `superpowers-openspec-execution-workflow`
- `superpowers-feature-workflow`
- `superpowers-learning-workflow`
- `openspec-feature-workflow`

这些 skill 采用仓库内维护方式，适合开源，也不依赖本机私有路径。

如果团队后续需要自动发现，可以把需要的目录复制到运行时 skill 目录，例如 `.codex/skills/`。

## 包列表

- [openspec-superpowers-workflow](openspec-superpowers-workflow/README.md) ([中文](openspec-superpowers-workflow/readme_cn.md))
- [superpowers-openspec-execution-workflow](superpowers-openspec-execution-workflow/README.md) ([中文](superpowers-openspec-execution-workflow/readme_cn.md))
- [superpowers-feature-workflow](superpowers-feature-workflow/README.md) ([中文](superpowers-feature-workflow/readme_cn.md))
- [superpowers-learning-workflow](superpowers-learning-workflow/README.md) ([中文](superpowers-learning-workflow/readme_cn.md))
- [openspec-feature-workflow](openspec-feature-workflow/README.md) ([中文](openspec-feature-workflow/readme_cn.md))

## 推荐用法

- 使用 `openspec-superpowers-workflow` 作为一个完整流程入口。
- 如果想明确按“先探索、再锁规范、再执行、最后归档”的四步节奏，使用 `superpowers-openspec-execution-workflow`。
- 如果只需要设计、计划、worktree、TDD、验证，使用 `superpowers-feature-workflow`。
- 如果想在重要工作结束后沉淀记忆、会话结论和可复用经验，使用 `superpowers-learning-workflow`。
- 如果只需要补齐 change 产物，使用 `openspec-feature-workflow`。

## 怎么选择

- 如果你想要一个从需求澄清一路带到实现和验证的统一入口，用 `openspec-superpowers-workflow`。
- 如果你已经明确要按四步顺序推进，并且希望这个顺序保持清晰可见，用 `superpowers-openspec-execution-workflow`。
- 如果你只想用 Superpowers 的工程纪律，用 `superpowers-feature-workflow`。
- 如果工作已经结束，想让下一次会话自动接上这次的经验，用 `superpowers-learning-workflow`。
- 如果你只想先补齐 OpenSpec change 产物，用 `openspec-feature-workflow`。

## 配套文档

- [INSTALL.md](INSTALL.md)
- [INSTALL.cn.md](INSTALL.cn.md)
