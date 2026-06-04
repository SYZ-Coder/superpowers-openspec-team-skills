# Team Skills

源码工作流层的导航首页。

`team-skills/` 保存的是本仓库维护的 workflow 源定义。这里更适合维护者、适配者，或者想查看原始工作流结构的高级使用者。

如果你的目标是把这些 workflow 安装到 Codex、Cursor 或 Claude Code 中使用，请优先回到根目录 [README.cn.md](../README.cn.md)、`dist/` 和 `scripts/`，而不是直接从 `team-skills/` 复制目录。

## 这里包含什么

这个目录当前包含 5 个源码工作流包：

- `openspec-superpowers-workflow`
- `superpowers-openspec-superpowers-workflow`
- `superpowers-feature-workflow`
- `superpowers-learning-workflow`
- `openspec-feature-workflow`

这些包由仓库直接维护，适合开源分发，也不依赖本机私有路径。

## 什么时候看这一层

当你有下面这些目标时，使用 `team-skills/`：

- 阅读原始 workflow 定义
- 比较不同 workflow 的职责边界
- 维护 workflow 源内容
- 将这些 workflow 适配到新的 AI 工具
- 构建或校验 `dist/` 下的 bundle

如果你的目标只是安装到某个工具里使用，这里不是首选入口。

## 工作流目录

- [openspec-superpowers-workflow（English）](openspec-superpowers-workflow/README.md) | [中文](openspec-superpowers-workflow/readme_cn.md)
- [superpowers-openspec-superpowers-workflow（English）](superpowers-openspec-superpowers-workflow/README.md) | [中文](superpowers-openspec-superpowers-workflow/readme_cn.md)
- [superpowers-feature-workflow（English）](superpowers-feature-workflow/README.md) | [中文](superpowers-feature-workflow/readme_cn.md)
- [superpowers-learning-workflow（English）](superpowers-learning-workflow/README.md) | [中文](superpowers-learning-workflow/readme_cn.md)
- [openspec-feature-workflow（English）](openspec-feature-workflow/README.md) | [中文](openspec-feature-workflow/readme_cn.md)

## 怎么选择

- 想要一个从澄清到验证的完整统一入口，用 `openspec-superpowers-workflow`
- 想要“先想透、再锁准、最后做稳”的四阶段节奏，用 `superpowers-openspec-superpowers-workflow`
- 只想要 Superpowers 工程纪律，不需要 OpenSpec change 产物，用 `superpowers-feature-workflow`
- 工作完成后想沉淀可复用经验和当前状态，用 `superpowers-learning-workflow`
- 只想先生成 proposal、design、specs、tasks，用 `openspec-feature-workflow`

## 源码层配套文档

- [源码层安装说明](INSTALL.cn.md)
- [源码层使用指南](USAGE.cn.md)
- [English Installation Notes](INSTALL.md)
- [English Usage Guide](USAGE.md)

## 与 `dist/` 的关系

- `team-skills/`：面向维护者和适配者的源码工作流定义
- `dist/`：面向具体 AI 工具的可安装 bundle

这两层在写法和文件结构上可以不同，但预期行为应保持一致。
