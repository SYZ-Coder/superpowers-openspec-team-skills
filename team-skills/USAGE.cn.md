# 源码工作流使用指南

这份文档说明如何使用 `team-skills/` 这一层源码工作流定义。

它主要面向维护者、工具适配者，以及需要查看原始 workflow 定义的高级使用者，而不是面向直接安装 bundle 的最终用户。

## 什么时候看这份指南

当你有下面这些需求时，使用这份指南：

- 理解源码 workflow 是如何组织的
- 判断应该扩展哪个源码 workflow
- 将这些 workflow 适配到新的 AI 工具或运行时
- 校验源码 workflow 和 `dist/` 分发 bundle 是否仍然对齐

如果你的目标只是把 workflow 安装到 Codex、Cursor 或 Claude Code，请优先查看根 README 和安装脚本。

## 一个源码工作流包通常包含什么

`team-skills/` 下的大多数 workflow 包通常包含：

- `README.md` 和 `readme_cn.md`
- 一个或多个描述 workflow 行为的说明文件
- 用于机器可读元数据的 `workflow.yaml`

请把这些目录视为源码定义，而不是可直接复制给最终用户的安装包。

## 推荐阅读顺序

对于维护者或评审者来说，比较实用的顺序是：

1. 先看本目录下的 [README.md](README.md)，选择合适的 workflow 家族
2. 再打开目标 workflow 的 README，理解它的职责
3. 查看 `workflow.yaml`，确认依赖和工具元数据
4. 如果需要确认实际分发行为，再去对照 `dist/` 下的对应 bundle

## 常见工作

### 安装到 Claude Code，但不替换已有 `CLAUDE.md`

如果目标项目已经有 `CLAUDE.md`，可以使用合并模式，而不是默认的替换行为。

PowerShell：

```powershell
.\scripts\install-claude-code.ps1 -Bundle openspec-superpowers -ProjectRoot <project-root> -MergeClaudeMd
```

shell：

```bash
sh "./scripts/install-claude-code.sh" --bundle openspec-superpowers --project-root <project-root> --merge-claude-md
```

这样会保留原有 `CLAUDE.md`，并把 bundle 里的说明作为一个可更新的受管区块追加进去。

### 查看某个 workflow

- 先读该 workflow 的 README
- 确认它是入口 workflow 还是辅助 workflow
- 确认它是否依赖 OpenSpec、Superpowers、archive 或 memory 行为

### 适配到新的工具

- 以 `team-skills/` 作为源码事实来源
- 即使命令形式、文件布局、表述方式发生变化，也要保持功能意图一致
- 面向具体工具的输出应写到 `dist/`，不要把源码包直接改成某个运行时专用格式

### 更新某个 workflow

- 在 `team-skills/` 下修改对应源码文件
- 同步维护相关说明文档
- 源码变更后重新构建分发 bundle

### 校验源码和 bundle 是否对齐

- 对比源码 workflow 行为和对应 bundle 行为
- 重点关注 workflow 门禁、预期产出、启用方式、续接逻辑
- 表述差异可以接受，但功能行为差异应当是有意为之

## 与可安装 bundle 的关系

这两层分别服务不同职责：

- `team-skills/`：编写与维护层
- `dist/`：最终用户安装层

部分源码 workflow 会故意保持模块化，并依赖其他 workflow 或外部 skills。这样更利于维护，但也正因为如此，不应把这里当作最终用户默认安装入口。

## 相关文档

- [English Source Workflow Navigation](README.md)
- [中文源码工作流导航](README.cn.md)
- [English Source Workflow Installation Notes](INSTALL.md)
- [中文源码工作流安装说明](INSTALL.cn.md)
- [English Source Workflow Usage Guide](USAGE.md)
- [中文源码工作流使用指南](USAGE.cn.md)
