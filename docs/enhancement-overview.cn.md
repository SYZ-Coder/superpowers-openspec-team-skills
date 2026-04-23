# 增强功能总览

本文档说明当前仓库中新增的记忆、自学习、收尾治理、检索与开源治理增强功能，包括：

- 新增了什么
- 分别有什么用
- 应该怎么用
- 带来了什么效果
- 对历史功能有没有影响
- 对稳定性、可信度、真实性、完整性、方便性等方面的影响

## 1. 总体定位

这轮增强的重点不是把仓库变成一个全自动、自演化的 agent 平台，而是把原来偏轻量、偏约定式的能力升级成一个更完整的 repo 内知识闭环。

增强后的整体特点是：

- 显式启用
- 显式执行
- repo-owned
- 可校验
- 可追溯
- 可治理
- 可晋升

也就是说，这套机制仍然不是后台自动学习系统，而是一套更严格、更完整、更适合长期协作和开源维护的项目级知识体系。

## 2. 新增了什么

### 2.1 记忆结构增强

当前 `.superpowers-memory/` 除了原来的基础文件外，还扩展出了更多记忆面：

- `PROJECT_CONTEXT.md`
- `CURRENT_STATE.md`
- `DECISIONS.md`
- `KNOWN_FAILURES.md`
- `VERIFICATION_BASELINE.md`
- `TEAM_PREFERENCES.md`
- `USER_PROFILE.md`
- `AGENT_NOTES.md`
- `LEARNING_BACKLOG.md`
- `SESSION_CLOSE_CHECKLIST.md`
- `memory-index.yaml`
- `session-journal/`

这些模板位于：

- [templates/superpowers-memory](/D:/spring_AI/superpowers-openspec-team-skills/templates/superpowers-memory)

### 2.2 记忆校验与治理脚本

新增或增强了以下脚本：

- [validate-superpowers-memory.ps1](/D:/spring_AI/superpowers-openspec-team-skills/scripts/validate-superpowers-memory.ps1)
- [validate-superpowers-memory.sh](/D:/spring_AI/superpowers-openspec-team-skills/scripts/validate-superpowers-memory.sh)

### 2.3 检索、建议与收尾脚本

新增了：

- [search-superpowers-memory.ps1](/D:/spring_AI/superpowers-openspec-team-skills/scripts/search-superpowers-memory.ps1)
- [search-superpowers-memory.sh](/D:/spring_AI/superpowers-openspec-team-skills/scripts/search-superpowers-memory.sh)
- [suggest-superpowers-memory-updates.ps1](/D:/spring_AI/superpowers-openspec-team-skills/scripts/suggest-superpowers-memory-updates.ps1)
- [suggest-superpowers-memory-updates.sh](/D:/spring_AI/superpowers-openspec-team-skills/scripts/suggest-superpowers-memory-updates.sh)
- [run-superpowers-memory-closeout.ps1](/D:/spring_AI/superpowers-openspec-team-skills/scripts/run-superpowers-memory-closeout.ps1)
- [run-superpowers-memory-closeout.sh](/D:/spring_AI/superpowers-openspec-team-skills/scripts/run-superpowers-memory-closeout.sh)

### 2.4 学习候选与晋升草案

新增了：

- [generate-superpowers-promotion-drafts.ps1](/D:/spring_AI/superpowers-openspec-team-skills/scripts/generate-superpowers-promotion-drafts.ps1)
- [generate-superpowers-promotion-drafts.sh](/D:/spring_AI/superpowers-openspec-team-skills/scripts/generate-superpowers-promotion-drafts.sh)
- [promotion-drafts/README.md](/D:/spring_AI/superpowers-openspec-team-skills/templates/superpowers-memory/promotion-drafts/README.md)

### 2.5 workflow 和工具集成增强

增强后的结构和脚本已经接入：

- [MEMORY.md](/D:/spring_AI/superpowers-openspec-team-skills/MEMORY.md)
- [MEMORY.cn.md](/D:/spring_AI/superpowers-openspec-team-skills/MEMORY.cn.md)
- [VERIFY.md](/D:/spring_AI/superpowers-openspec-team-skills/VERIFY.md)
- [VERIFY.cn.md](/D:/spring_AI/superpowers-openspec-team-skills/VERIFY.cn.md)
- [superpowers-feature-workflow/SKILL.md](/D:/spring_AI/superpowers-openspec-team-skills/team-skills/superpowers-feature-workflow/SKILL.md)
- [superpowers-openspec-execution-workflow/SKILL.md](/D:/spring_AI/superpowers-openspec-team-skills/team-skills/superpowers-openspec-execution-workflow/SKILL.md)
- [superpowers-learning-workflow/SKILL.md](/D:/spring_AI/superpowers-openspec-team-skills/team-skills/superpowers-learning-workflow/SKILL.md)

以及三套工具集成模板：

- [Codex integration](/D:/spring_AI/superpowers-openspec-team-skills/templates/superpowers-memory/integrations/codex/AGENTS.memory.md)
- [Cursor integration](/D:/spring_AI/superpowers-openspec-team-skills/templates/superpowers-memory/integrations/cursor/superpowers-memory.mdc)
- [Claude Code integration](/D:/spring_AI/superpowers-openspec-team-skills/templates/superpowers-memory/integrations/claude-code/CLAUDE.memory.md)

### 2.6 开源治理增强

新增了：

- [LICENSE](/D:/spring_AI/superpowers-openspec-team-skills/LICENSE)
- [CONTRIBUTING.md](/D:/spring_AI/superpowers-openspec-team-skills/CONTRIBUTING.md)
- [SECURITY.md](/D:/spring_AI/superpowers-openspec-team-skills/SECURITY.md)
- [CODE_OF_CONDUCT.md](/D:/spring_AI/superpowers-openspec-team-skills/CODE_OF_CONDUCT.md)
- [CHANGELOG.md](/D:/spring_AI/superpowers-openspec-team-skills/CHANGELOG.md)
- [PR template](/D:/spring_AI/superpowers-openspec-team-skills/.github/PULL_REQUEST_TEMPLATE.md)
- [Issue templates](/D:/spring_AI/superpowers-openspec-team-skills/.github/ISSUE_TEMPLATE)
- [GitHub Actions CI](/D:/spring_AI/superpowers-openspec-team-skills/.github/workflows/ci.yml)

## 3. 这些增强分别有什么用

### 3.1 项目事实、状态和知识面分层

增强前，很多信息容易混在 `PROJECT_CONTEXT.md`、`CURRENT_STATE.md` 或会话对话里。

增强后，信息被拆分成不同职责：

- `PROJECT_CONTEXT.md`：长期稳定项目事实
- `CURRENT_STATE.md`：当前工作状态
- `DECISIONS.md`：关键决策与理由
- `KNOWN_FAILURES.md`：重复失败模式与脆弱点
- `VERIFICATION_BASELINE.md`：可信验证方式
- `TEAM_PREFERENCES.md`：团队协作偏好
- `USER_PROFILE.md`：用户偏好与交互习惯
- `AGENT_NOTES.md`：agent 特定提醒
- `LEARNING_BACKLOG.md`：可晋升经验候选
- `SESSION_CLOSE_CHECKLIST.md`：收尾检查
- `memory-index.yaml`：治理索引与健康摘要

这样做的核心价值是：减少信息混写、减少上下文污染、减少长期事实与临时状态混淆。

### 3.2 validator：把记忆治理从“建议”变成“可检查”

`validate-superpowers-memory.*` 的作用不只是看文件在不在，还包括：

- 检查记忆文件是否齐全
- 检查模板结构
- 检查 durable entry 元数据
- 检查 `CURRENT_STATE.md` 和 journal 是否过旧
- 检查 `review_after` 是否到期
- 检查一部分 promotion candidate 的最低条件
- 自动刷新 `memory-index.yaml`

这会把原来“最好更新一下记忆”的软要求，变成可被验证的流程约束。

### 3.3 search：把固定读取升级为可检索召回

`search-superpowers-memory.*` 支持按类型、关键字、时间窗口、最近优先等方式检索：

- decisions
- failures
- verification
- backlog
- journal
- user profile
- agent notes

它的意义是：跨会话时不用只靠人工翻文档和 journal，而是能快速找回历史结论和经验。

### 3.4 suggestion：降低遗漏概率

`suggest-superpowers-memory-updates.*` 会根据：

- `ChangedPaths`
- `Signals`

建议本次会话更可能需要更新哪些记忆面。

它的作用不是自动写入，而是把“你可能忘了补这里”变成明确提示，降低收尾遗漏率。

### 3.5 closeout helper：把收尾变成标准入口

`run-superpowers-memory-closeout.*` 会把以下动作串起来：

- 输出 checklist 路径
- 输出聚合后的 memory update suggestions
- 按需运行 validator
- 输出 closeout summary

它的意义是：把多个分散动作整合成一个统一收尾入口。

### 3.6 promotion drafts：把学习候选往可复用资产推进一步

`generate-superpowers-promotion-drafts.*` 会读取 `LEARNING_BACKLOG.md` 中状态成熟的候选，并生成：

- checklist draft
- rule draft
- skill draft

这一步仍然保留人工审核，不会直接自动改 skill 库，因此比“自动自学习”更稳妥。

### 3.7 开源治理层：让仓库更适合 GitHub 协作

新增的治理文件让仓库从“能用”提升到“更适合长期公开协作”：

- `LICENSE`：明确复用边界
- `CONTRIBUTING.md`：明确贡献方式
- `SECURITY.md`：明确安全问题提报方式
- `CODE_OF_CONDUCT.md`：明确协作边界
- `CHANGELOG.md`：记录重要演进
- issue/PR templates：降低沟通成本
- CI：避免明显错误进入主分支

## 4. 怎么用

### 4.1 启用项目记忆

首先在目标项目中安装 `.superpowers-memory/` scaffold，并按需安装工具集成。

### 4.2 会话开始时读取

启用相关 workflow 后，工具会优先读取：

- 项目长期事实
- 当前状态
- 决策
- 失败模式
- 验证规则
- 团队偏好
- 用户偏好
- agent notes
- 最近 journal

### 4.3 会话结束时收尾

推荐运行 closeout helper：

```powershell
.\scripts\run-superpowers-memory-closeout.ps1 -ProjectRoot <project-root> -ChangedPaths "scripts/validate-superpowers-memory.ps1" -Signals "validation" -RunValidator
```

Shell 版：

```bash
sh "./scripts/run-superpowers-memory-closeout.sh" --project-root <project-root> --changed-paths "scripts/validate-superpowers-memory.ps1" --signals "validation" --run-validator
```

### 4.4 查询历史记忆

```powershell
.\scripts\search-superpowers-memory.ps1 -ProjectRoot <project-root> -Type decisions -Query "validation" -RecentFirst -Summary
```

### 4.5 生成晋升草案

```powershell
.\scripts\generate-superpowers-promotion-drafts.ps1 -ProjectRoot <project-root>
```

## 5. 带来了什么效果

### 5.1 从“聊天记忆”变成“仓库记忆”

很多原来只存在于一次会话里的信息，现在可以长期保存在 repo 里。

### 5.2 从“经验印象”变成“结构化候选”

学习结果不再只是聊天总结，而是变成带状态、证据和晋升方向的候选条目。

### 5.3 从“靠自觉收尾”变成“有统一收尾入口”

closeout helper 和 checklist 会显著减少会话结束时的遗漏。

### 5.4 从“只能读固定文件”变成“可检索”

历史决策、失败模式和验证方法的复用效率明显提高。

### 5.5 从“普通仓库”变成“更成熟的开源仓库”

治理文件和 CI 让外部贡献者更容易理解边界，也更容易信任仓库行为。

## 6. 对历史功能有没有影响

总体上属于兼容增强，不是破坏式变更。

### 6.1 不受影响的部分

- workflow 仍然是显式启用
- 不会自动全局开启增强功能
- 原有核心记忆文件仍然有效
- 原有 source workflow 和 `dist/` bundle 主体逻辑仍在

### 6.2 会发生变化的部分

- 启用记忆后，读取面更完整了
- 收尾动作更标准化了
- learning backlog 更结构化了
- validator 和 closeout helper 成为标准建议入口
- GitHub 仓库的治理约束更完整了

因此影响主要是：启用增强后，流程更严格、更完整，但不会破坏旧功能。

## 7. 对不同质量维度的影响

### 7.1 稳定性

正向提升明显：

- 模板更完整
- validator 更强
- memory-index 提供健康汇总
- closeout helper 降低遗漏
- CI 挡住一部分明显错误

边界：

- Linux/macOS 仍需要更多真实环境持续验证
- 目前仍以显式触发为主，不是完整 runtime hook

### 7.2 可信度

可信度提升很大，原因包括：

- 更强的元数据约束
- 更清晰的记忆分层
- 更明确的验证基线
- 更统一的收尾和校验流程
- 更透明的开源治理文件

### 7.3 真实性

真实性有提升，但不是自动保真。

系统可以帮助：

- 区分不同类型信息
- 要求来源和时间信息
- 提醒复查和过期项
- 提高错误被发现的概率

但它不能自动保证所有条目都绝对正确。

### 7.4 准确性

准确性提升体现在：

- 用户偏好与项目事实分离
- agent 提醒与项目事实分离
- 验证标准单独沉淀
- 决策理由有专门落点

这会减少信息被写错层、写混层的概率。

### 7.5 完整性

完整性是提升最明显的维度之一。

以前容易缺失的几个面现在都有明确落点：

- 决策
- 失败模式
- 验证规则
- 团队偏好
- 用户偏好
- agent 执行提醒
- 学习候选
- 收尾检查

### 7.6 方便性

方便性不是来自“少做事”，而是来自“把正确动作变得更容易做”：

- search 降低查找成本
- suggestion 降低判断成本
- closeout helper 降低收尾成本
- issue/PR template 降低开源协作成本

## 8. 对开源使用者的意义

对于 GitHub 开源仓库用户来说，这次增强意味着：

- 更容易理解仓库边界
- 更容易知道如何贡献
- 更容易知道哪些能力是显式触发
- 更容易理解脚本、workflow 和记忆机制之间的关系
- 更容易验证仓库当前能力是否可信

## 9. 当前还没有做到的事

为了避免误解，以下能力目前仍然没有完全实现：

- Hermes 那种 runtime 级自动记忆编排
- 外部 semantic memory provider
- 真正的自动 skill patch / 自动技能演化
- 全自动 hook 式收尾
- 三平台完全等强度的长期实测

因此当前版本的准确定位是：

一个更强的、repo-owned、显式触发、可审计的项目记忆与学习系统，而不是全自动自治 agent 平台。

## 10. 一句话总结

这轮增强把原来偏轻量、偏约定式的记忆与自学习能力，升级成了一个更结构化、更可校验、更可追溯、更适合长期协作和开源治理的体系。

它不会打坏历史功能，也不会默认偷偷启用；但一旦启用，会显著提升：

- 稳定性
- 可信度
- 可追溯性
- 完整性
- 收尾一致性
- 开源协作可维护性
