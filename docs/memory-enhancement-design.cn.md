# 记忆与自学习增强设计方案

## 背景

当前仓库已经提供了一套轻量、透明、可关闭的仓库内记忆机制：

- 用 `.superpowers-memory/` 保存跨会话上下文
- 用项目级工具集成提示会话开始先读记忆、结束前写回记忆
- 用 `superpowers-learning-workflow` 在重要工作结束后沉淀经验

这套机制已经解决了两个核心问题：

1. 记忆放在哪里
2. 什么时候应该读写

但如果目标是进一步提高稳定性、准确性、可信性、完整性和防遗漏能力，仍然需要一套更完整的增强设计。

## 设计目标

增强后的记忆与自学习体系应满足以下目标：

1. 可恢复：新会话可以快速接上项目上下文、近期决策和下一步建议
2. 可验证：重要记忆具备来源、状态和置信度
3. 可治理：过期、冲突、缺失的记忆能够被发现
4. 可晋升：重复经验可以逐步升级成 checklist、rule、workflow step 或 skill draft
5. 低负担：小任务只需轻量更新，不让记忆维护本身变成负担
6. 不越权：记忆存在不代表自动启用 workflow，也不代表自动改技能库

## 非目标

本阶段不引入以下能力：

- 外部记忆服务
- 向量检索或 embedding
- 模型参数级微调
- 自动直接修改 skill library
- 隐式后台学习

也就是说，这套方案仍然坚持“repo-owned、显式启用、可审计”的边界。

## 主要问题

### 1. 稳定性问题

- 记忆更新主要依赖 workflow 约定，缺少强校验
- 会话收尾容易漏掉某些记忆面
- `CURRENT_STATE.md` 或 journal 过期时，过去缺少统一治理入口

### 2. 可信性问题

- 重要结论如果没有 `source`，就难以回溯
- 容易把推断和已验证事实混写
- 旧结论和新结论可能冲突，但过去不容易发现

### 3. 完整性问题

- 决策、失败模式、验证基线、用户偏好、agent 提醒过去缺少独立承载面
- 很多重要信息容易只停留在聊天里
- 没有系统化的收尾 checklist 时，容易只更新当前状态，忘了更新其他层

### 4. 自学习闭环问题

- `LEARNING_BACKLOG.md` 过去更像候选池，没有足够清晰的治理状态
- 缺少“何时值得晋升成 checklist / rule / skill” 的统一门槛
- 缺少从学习候选到草案产出的稳定路径

## 目标目录结构

建议使用下面这套增强后的 `.superpowers-memory/` 结构：

```text
.superpowers-memory/
  PROJECT_CONTEXT.md
  CURRENT_STATE.md
  DECISIONS.md
  KNOWN_FAILURES.md
  VERIFICATION_BASELINE.md
  TEAM_PREFERENCES.md
  USER_PROFILE.md
  AGENT_NOTES.md
  LEARNING_BACKLOG.md
  SESSION_CLOSE_CHECKLIST.md
  memory-index.yaml
  session-journal/
  promotion-drafts/
```

### 文件职责

- `PROJECT_CONTEXT.md`
  保存长期稳定的项目事实，例如项目目标、系统边界、长期约束
- `CURRENT_STATE.md`
  保存当前焦点、阻塞点、开放问题和下一步建议
- `DECISIONS.md`
  保存跨会话仍然重要的设计或流程决策
- `KNOWN_FAILURES.md`
  保存重复出现的失败模式、环境坑和误判模式
- `VERIFICATION_BASELINE.md`
  保存被认为“足够可信”的验证命令、验证范围和证据要求
- `TEAM_PREFERENCES.md`
  保存团队协作偏好、编码习惯和流程口径
- `USER_PROFILE.md`
  保存不属于项目事实的稳定用户偏好
- `AGENT_NOTES.md`
  保存与仓库执行有关的稳定提醒，例如常见操作坑和质量提醒
- `LEARNING_BACKLOG.md`
  保存可复用经验候选，并跟踪其是否值得晋升
- `SESSION_CLOSE_CHECKLIST.md`
  保存统一的收尾检查项
- `memory-index.yaml`
  保存记忆健康度和治理摘要，建议由 validator 自动维护
- `session-journal/`
  保存每次有意义会话的一条短记录
- `promotion-drafts/`
  保存从 backlog 生成的 checklist / rule / skill 草案

## 元数据规范

建议为长期有效的记忆条目统一补充这些元数据：

- `id`
- `type`
- `status`
- `confidence`
- `last_updated`
- `source`
- `owner`
- `review_after`

### 推荐取值

- `type`
  - `durable_fact`
  - `decision`
  - `failure_pattern`
  - `verification_rule`
  - `team_preference`
  - `user_preference`
  - `agent_note`
  - `learning_candidate`
- `status`
  - `active`
  - `tentative`
  - `stale`
  - `superseded`
- `confidence`
  - `verified`
  - `inferred`
  - `tentative`

### 基本约束

- 没有 `source` 的条目不应标成 `verified`
- 需要长期保留的条目应有 `review_after`
- 被新结论取代的旧条目应标为 `superseded`

### 示例

```md
### Decision: Use session-close memory validation
- id: decision-2026-04-22-session-close-validation
- type: decision
- status: active
- confidence: verified
- last_updated: 2026-04-22
- source: workflow review and repository policy
- owner: team
- review_after: 2026-06-01

Reason:
Reduce the chance that a meaningful session ends without updating memory.

Tradeoff:
Adds one validation step before completion claims.
```

## 记忆更新分层

为了降低维护负担，建议把记忆更新分成三层。

### Level 1：轻量更新

适用于：

- 小任务
- 普通修复
- 快速确认

通常更新：

- `CURRENT_STATE.md`
- 一条 `session-journal`

### Level 2：结构化更新

适用于：

- 跨文件修改
- 关键决策
- 新验证口径
- 发现新坑

通常更新：

- `CURRENT_STATE.md`
- `session-journal`
- `DECISIONS.md` / `KNOWN_FAILURES.md` / `VERIFICATION_BASELINE.md` / `TEAM_PREFERENCES.md`

### Level 3：学习沉淀

适用于：

- 重要工作结束后
- 需要保留可复用经验
- 某个模式已重复出现

通常更新：

- 必要的 durable memory
- `LEARNING_BACKLOG.md`
- 如有需要生成 promotion draft

## 防遗漏触发器

建议在 workflow 中加入这些显式触发器：

- 模块边界、职责、数据流变化
  - 更新 `PROJECT_CONTEXT.md` 或 `DECISIONS.md`
- 当前任务、阻塞或下一步变化
  - 更新 `CURRENT_STATE.md`
- 一次重要实现、验证、回滚或交付结束
  - 写一条 `session-journal`
- 发现重复 bug、环境坑或流程坑
  - 更新 `KNOWN_FAILURES.md`
- 引入新的可信验证命令
  - 更新 `VERIFICATION_BASELINE.md`
- 确认团队偏好或协作边界
  - 更新 `TEAM_PREFERENCES.md`
- 确认稳定用户偏好
  - 更新 `USER_PROFILE.md`
- 发现稳定的 agent 执行提醒
  - 更新 `AGENT_NOTES.md`
- 相同经验重复出现两次以上
  - 更新 `LEARNING_BACKLOG.md`

## 会话收尾检查表

建议在 Superpowers 相关 workflow 的收尾阶段统一检查：

1. 这次是否改变了长期项目事实？
2. 当前焦点、阻塞或下一步是否变化？
3. 是否产生了重要决策？
4. 是否暴露了失败模式、环境坑或误判模式？
5. 是否形成了新的验证口径？
6. 是否出现了可复用且重复的经验？
7. 新增或更新的 durable entry 是否写入了日期、状态和来源？

## 学习候选晋升机制

建议把 `LEARNING_BACKLOG.md` 作为“学习候选池”，并为每个候选记录：

- `candidate_id`
- `trigger`
- `repeated_pattern`
- `impact`
- `evidence_count`
- `repeated_times`
- `suggested_artifact`
- `status`
- `promote_decision`
- `linked_entries`

### 晋升门槛

满足以下条件时，才建议晋升：

- `repeated_times >= 2`
- `evidence_count >= 2`
- 影响明确，且跨会话或跨成员有价值
- 不是一次性偶发问题
- 可以抽象成可执行产物

### 可晋升产物

- checklist
- project rule
- workflow step
- script
- skill draft

### 晋升边界

- 不直接自动修改 skill library
- 先生成草案，再由用户或维护者确认
- 没有来源支撑的候选不应直接晋升

## 校验器设计

建议使用 `scripts/validate-superpowers-memory.ps1` 作为统一治理入口。

### 检查范围

#### 结构检查

- `.superpowers-memory/` 是否存在
- 核心文件是否齐全
- 文件中是否存在关键标题或关键字段

#### 新鲜度检查

- `CURRENT_STATE.md` 是否过期
- 最新 journal 是否缺失或过旧
- 活动任务是否缺少近期状态更新

#### 可信度检查

- 重要条目是否缺少 `source`
- 标记为 `verified` 的条目是否缺少证据
- 是否缺少 `review_after`
- 是否已经超过复查时间

#### 冲突检查

- durable entry 的 `id` 是否冲突
- 当前状态与近期 journal 是否存在明显断裂
- 长期事实和后续决策之间是否可能互相矛盾

#### Backlog 治理检查

- 是否存在长期未处理的候选
- 是否存在 `ready_for_promotion` 但证据不足的候选
- 是否把一次性会话记录误写进 backlog

### 输出等级

- `ERROR`
- `WARN`
- `INFO`

### `memory-index.yaml` 的作用

建议由 validator 自动刷新这些摘要字段：

- current state / journal 是否新鲜
- warning / error 数量
- `stale_durable_entries`
- `entries_missing_source`
- `entries_missing_review_after`
- `review_overdue_entries`
- `promotion_ready_candidates`
- `last_validator_version`
- `last_promotion_scan`

这样它就不仅是占位文件，而是真正的治理索引。

## 收尾辅助脚本

建议在 suggestion 和 validator 之间再加一层统一入口：

- `scripts/suggest-superpowers-memory-updates.ps1`
  - 根据 changed paths 和 signals 给出建议更新面
- `scripts/run-superpowers-memory-closeout.ps1`
  - 串联 checklist 提示、建议输出和可选 validator
- `scripts/search-superpowers-memory.ps1`
  - 用于确认历史上是否已经存在类似决策、失败模式或经验

这一层的目标不是自动写入，而是让“正确收尾”变得更容易。

## 与现有 workflow 的接入点

### `superpowers-feature-workflow`

建议增强为：

1. 开始前读取 `PROJECT_CONTEXT.md`、`CURRENT_STATE.md`、`DECISIONS.md`、`KNOWN_FAILURES.md`、`VERIFICATION_BASELINE.md`、`TEAM_PREFERENCES.md`、`USER_PROFILE.md`、`AGENT_NOTES.md` 和最近 journal
2. 收尾时优先使用 closeout helper
3. 声称完成前运行 memory validator

### `superpowers-openspec-execution-workflow`

建议增强为：

1. 在 archive 前增加一次 memory alignment 检查
2. 确保 spec、implementation、verification、memory 四者一致
3. 收尾时优先使用 closeout helper

### `superpowers-learning-workflow`

建议增强为：

1. 从“四桶分类”升级为“分类 + 元数据 + 晋升判断”
2. 输出学习摘要的同时，给出是否建议生成 checklist / rule / skill 草案
3. 在需要时调用 search、suggestion、closeout helper 和 validator

## 推荐实施顺序

### 第一阶段：质量治理层

- 扩展记忆模板
- 新增 `DECISIONS.md`
- 新增 `KNOWN_FAILURES.md`
- 新增 `VERIFICATION_BASELINE.md`
- 新增 `TEAM_PREFERENCES.md`
- 新增 `USER_PROFILE.md`
- 新增 `AGENT_NOTES.md`
- 升级 `LEARNING_BACKLOG.md`
- 新增 `SESSION_CLOSE_CHECKLIST.md`
- 引入 `validate-superpowers-memory.ps1`
- 引入 `memory-index.yaml`

### 第二阶段：检索与收尾层

- 增加 `search-superpowers-memory.ps1`
- 增加 `suggest-superpowers-memory-updates.ps1`
- 增加 `run-superpowers-memory-closeout.ps1`
- 把这些能力接入 workflow 和文档

### 第三阶段：晋升草案层

- 增加晋升草案生成脚本
- 从 `LEARNING_BACKLOG.md` 生成 checklist / rule / skill draft
- 默认只写入 `promotion-drafts/`，不直接修改 skill library

## 当前仓库的落地情况

当前仓库已经完成了这套设计中的大部分内容：

### 已落地

- 扩展后的 `.superpowers-memory/` 模板结构
- `USER_PROFILE.md` 和 `AGENT_NOTES.md`
- `SESSION_CLOSE_CHECKLIST.md`
- `validate-superpowers-memory.ps1/.sh`
- `search-superpowers-memory.ps1/.sh`
- `suggest-superpowers-memory-updates.ps1/.sh`
- `run-superpowers-memory-closeout.ps1/.sh`
- `generate-superpowers-promotion-drafts.ps1/.sh`
- `memory-index.yaml` 自动回写
- 与三套工具集成模板和核心 workflow 的接入

### 已具备的能力

- durable entry 元数据约束
- 过期、缺源、复查到期、promotion-ready 候选等检查
- 记忆搜索、时间窗口和摘要视图
- 收尾建议和统一 closeout helper
- learning backlog 到 promotion draft 的半自动过渡

### 仍然保留的边界

- 不自动启用 workflow
- 不自动后台学习
- 不自动直接修改 skill library
- 不引入外部向量检索或 provider

## 成功标准

如果增强方案生效，应能观察到这些结果：

- 新会话更少重复追问项目背景
- 会话结束后更少遗漏当前状态和下一步
- 决策、失败模式和验证方法有明确归档位置
- 过期或缺源记忆能被 validator 发现
- 重复经验不再只停留在聊天里，而是进入 backlog 并逐步晋升
- 收尾动作比过去更标准、更一致

## 总结

这套增强方案的核心不是让 agent “自动变聪明”，而是让仓库里的记忆更结构化、可验证、可治理、可检索、可晋升。

它保留了当前路线的透明、可控和 repo-owned 特点，同时显著降低了跨会话信息损失和经验沉淀失真。
