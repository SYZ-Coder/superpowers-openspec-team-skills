# 跨平台测试说明

这份文档给出记忆增强脚本在 Windows、Linux、macOS 上的最小验证矩阵。

适合用来快速回答这几个问题：

- 每个平台应该跑哪个脚本入口
- 什么结果可以算通过
- 当前仓库里哪些平台已经真正测过

## 范围

当前跨平台检查覆盖这些脚本：

- [validate-superpowers-memory.ps1](/D:/spring_AI/superpowers-openspec-team-skills/scripts/validate-superpowers-memory.ps1)
- [validate-superpowers-memory.sh](/D:/spring_AI/superpowers-openspec-team-skills/scripts/validate-superpowers-memory.sh)
- [generate-superpowers-promotion-drafts.ps1](/D:/spring_AI/superpowers-openspec-team-skills/scripts/generate-superpowers-promotion-drafts.ps1)
- [generate-superpowers-promotion-drafts.sh](/D:/spring_AI/superpowers-openspec-team-skills/scripts/generate-superpowers-promotion-drafts.sh)

## 状态矩阵

| 平台 | 记忆校验入口 | 晋升草案入口 | 当前状态 |
| --- | --- | --- | --- |
| Windows PowerShell 5.1+ | `validate-superpowers-memory.ps1` | `generate-superpowers-promotion-drafts.ps1` | 已做真实执行验证 |
| Linux (`/bin/sh`) | `validate-superpowers-memory.sh` | `generate-superpowers-promotion-drafts.sh` | 已完成静态核查，仍建议真实环境实跑 |
| macOS (`/bin/sh`) | `validate-superpowers-memory.sh` | `generate-superpowers-promotion-drafts.sh` | 已完成静态核查，仍建议真实环境实跑 |

## 当前已验证内容

### Windows

PowerShell 脚本已经在真实 Windows 环境中执行过。

已验证行为：

- 能从 `LEARNING_BACKLOG.md` 生成晋升草案
- validator 能在新 scaffold 上正常完成
- validator 会刷新 `memory-index.yaml`
- 已修复晋升脚本对 Windows PowerShell 5.1 的兼容问题

观察到的通过结果：

```text
Summary: 0 error(s), 0 warning(s), 2 info item(s)
```

### Linux 和 macOS

shell 脚本已经做过可移植性核查和兼容性补强，但当前工作区没有真实 Linux / macOS 运行时，因此还没完成实跑验证。

已完成的兼容性处理：

- 改成原生 `sh` 入口，不依赖 `pwsh`
- 同时兼容 GNU 和 BSD 的 `stat`
- 同时兼容 GNU 和 BSD 的 `date`
- 修复 promotion draft 生成里 `awk` 的兼容问题
- 将 stale / conflict 统计改成更稳的 `awk` 方案

## 推荐命令

请将 `<repo-root>` 和 `<project-root>` 替换成真实路径。

### Windows

校验记忆：

```powershell
.\scripts\validate-superpowers-memory.ps1 -ProjectRoot <project-root>
```

生成晋升草案：

```powershell
.\scripts\generate-superpowers-promotion-drafts.ps1 -ProjectRoot <project-root>
```

### Linux 或 macOS

校验记忆：

```bash
sh "<repo-root>/scripts/validate-superpowers-memory.sh" --project-root <project-root>
```

生成晋升草案：

```bash
sh "<repo-root>/scripts/generate-superpowers-promotion-drafts.sh" --project-root <project-root>
```

覆盖已有草案：

```bash
sh "<repo-root>/scripts/generate-superpowers-promotion-drafts.sh" --project-root <project-root> --force
```

## 通过标准

对于一个新的 memory scaffold，健康的结果通常意味着：

- 命令成功退出
- validator 没有报 error
- 如果没有显式跳过，`memory-index.yaml` 被刷新
- 当 backlog 候选被标记为 `ready_for_promotion` 时，`.superpowers-memory/promotion-drafts/` 下出现对应草案

如果项目还没有积累真实 journal 历史，出现少量 warning 也是可以接受的。

## 推荐手工测试用例

建议在每个平台都跑下面这组检查：

1. 安装或准备 `.superpowers-memory/`
2. 添加一条合法的 session journal
3. 运行 validator
4. 确认 `memory-index.yaml` 已更新
5. 添加一条 `ready_for_promotion` 的 backlog 候选
6. 运行晋升草案生成脚本
7. 确认草案文件已生成
8. 不带覆盖参数再跑一遍，确认已有草案不会被改写

## 当前边界

在当前阶段：

- Windows 已有真实执行证据
- Linux 和 macOS 已完成面向可移植性的核查和补强
- Linux 和 macOS 仍然需要在真实 shell 运行时中再做一次验证，才能算完整运行认证

更完整的安装与 workflow 验证，请参见 [VERIFY.cn.md](/D:/spring_AI/superpowers-openspec-team-skills/VERIFY.cn.md)。
