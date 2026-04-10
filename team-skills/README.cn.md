# 团队 Skills

这个目录包含团队在 OpenSpec + Superpowers 流程下使用的多个可移植 skill 包。

当前包含：

- `openspec-superpowers-workflow`
- `superpowers-openspec-execution-workflow`
- `superpowers-feature-workflow`
- `openspec-feature-workflow`

这些 skill 采用仓库内维护方式，适合开源，也不依赖本机私有路径。

如果团队后续需要自动发现，可以把需要的目录复制到运行时 skill 目录，例如 `.codex/skills/`。

## 包列表

- [openspec-superpowers-workflow](D:/syz/project/designMode/docs/team-skills/openspec-superpowers-workflow)
- [superpowers-openspec-execution-workflow](D:/syz/project/designMode/docs/team-skills/superpowers-openspec-execution-workflow)
- [superpowers-feature-workflow](D:/syz/project/designMode/docs/team-skills/superpowers-feature-workflow)
- [openspec-feature-workflow](D:/syz/project/designMode/docs/team-skills/openspec-feature-workflow)

## 推荐用法

- 使用 `openspec-superpowers-workflow` 作为一个完整流程入口。
- 如果想明确按“先探索、再锁规范、再执行”的三段式节奏，使用 `superpowers-openspec-execution-workflow`。
- 如果只需要设计、计划、worktree、TDD、验证，使用 `superpowers-feature-workflow`。
- 如果只需要补齐 change 产物，使用 `openspec-feature-workflow`。

## 配套文档

- [INSTALL.md](D:/syz/project/designMode/docs/team-skills/INSTALL.md)
- [INSTALL.cn.md](D:/syz/project/designMode/docs/team-skills/INSTALL.cn.md)
