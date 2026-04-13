# 验证已安装的 Bundle

这份文档说明如何验证 bundle 是否真的安装成功，以及它是否真的影响了工具行为。

验证分两层：

1. 安装验证：文件是否落到了预期位置
2. 运行验证：工具是否真的加载了 workflow，并按预期行为执行

在执行本文中的脚本前，请先确认：

- 你已经切换到了仓库根目录，或者
- 你使用的是脚本的绝对路径

## 1. Codex

### 第一步：检查运行时依赖

对于依赖 OpenSpec 的 bundle，先执行：

```powershell
.\scripts\install-codex.ps1 -Bundle superpowers-openspec-execution -CheckDependencies
```

如果提示缺少 `openspec-cli`，说明 bundle 可以安装，但流程可能无法完整运行。

### 第二步：安装 bundle

```powershell
.\scripts\install-codex.ps1 -Bundle superpowers-openspec-execution
```

### 第三步：检查安装文件

```powershell
Test-Path "$env:USERPROFILE\.codex\skills\superpowers-openspec-execution-workflow\SKILL.md"
```

预期结果：

```text
True
```

### 第四步：重启或刷新 Codex

Codex 需要重新发现刚安装的 skill。

### 第五步：验证运行行为

在 Codex 中发送：

```text
Use $superpowers-openspec-execution-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```

预期行为：

- 不会一上来直接写代码
- 会先探索需求和上下文
- 会先澄清范围或确认方案
- 会先进入 OpenSpec 阶段，再进入实现阶段
- 最后回到实现、验证和归档

如果它还是直接开始写生产代码，说明 workflow 没有真正生效。

## 2. Cursor

### 第一步：检查运行时依赖

```powershell
.\scripts\install-cursor.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root> -CheckDependencies
```

### 第二步：安装 bundle

```powershell
.\scripts\install-cursor.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

### 第三步：检查安装文件

```powershell
Test-Path "<project-root>\.cursor\rules\superpowers-openspec-execution-workflow.mdc"
Test-Path "<project-root>\AGENTS.md"
```

预期结果：

```text
True
True
```

### 第四步：重新打开项目

让 Cursor 重新加载项目规则文件。

### 第五步：验证运行行为

在 Cursor 中发送类似请求：

```text
Use the superpowers-openspec-execution workflow for this feature: first explore, then lock OpenSpec, then implement and verify, then archive the change.
```

预期行为：

- 智能体表现出明显的分阶段流程
- 不会跳过探索和规范阶段直接进入实现
- 会把设计和 OpenSpec 产物当成明确步骤处理

## 3. Claude Code

### 第一步：检查运行时依赖

```powershell
.\scripts\install-claude-code.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root> -CheckDependencies
```

### 第二步：安装 bundle

```powershell
.\scripts\install-claude-code.ps1 -Bundle superpowers-openspec-execution -ProjectRoot <project-root>
```

### 第三步：检查安装文件

```powershell
Test-Path "<project-root>\.claude\commands\superpowers-openspec-execution-workflow.md"
Test-Path "<project-root>\CLAUDE.md"
```

预期结果：

```text
True
True
```

### 第四步：重新打开项目

让 Claude Code 重新加载命令和项目说明文件。

### 第五步：验证运行行为

调用：

```text
/superpowers-openspec-execution-workflow
```

然后继续描述你的功能需求。

预期行为：

- 该命令可用
- Claude Code 会按分阶段流程工作，而不是直接进入实现

## 4. 什么才算“真的生效”

不能只看文件是否存在。

真正算生效，应该同时满足：

- 工具已经识别了安装的 bundle
- 工具的行为明显受 workflow 影响
- 工具遵循设计、规范、验证这些门禁

如果文件在，但行为没变，那只是安装成功了，不代表运行时真的启用了这个 workflow。

## 5. 推荐验证顺序

对任何工具，都推荐按这个顺序检查：

1. 先运行 `-CheckDependencies`
2. 安装 bundle
3. 检查目标文件是否存在
4. 重启或刷新工具
5. 发起一次明确的 workflow 调用
6. 观察工具行为是否符合 workflow 分阶段要求
