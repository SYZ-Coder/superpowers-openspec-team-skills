# 记忆与自学习增强设计方案

## 背景

当前仓库已经提供一套轻量、透明、可关闭的仓库内记忆机制：

- 通过 `.superpowers-memory/` 保存跨会话上下文
- 通过项目级工具集成提示会话开始先读记忆、结束前写回记忆
- 通过 `superpowers-learning-workflow` 在重要工作结束后沉淀经验

这套方案已经解决了“记忆放在哪里”和“什么时候应该读写”两个问题，但仍然存在以下不足：

- 记忆更新主要依赖 workflow 约定，缺少强校验
- 重要经验和一次性结论容易混写
- 长期记忆缺少证据来源、置信度、过期治理
- 失败模式、关键决策、验证基线缺少独立承载面
- `LEARNING_BACKLOG.md` 缺少晋升闭环，难以稳定转化成 checklist、rule 或 skill

本设计的目标是在保留现有机制“轻量、repo-owned、显式启用”的前提下，提升稳定性、可信度、完整性和防遗漏能力。

## 设计目标

增强后的记忆与自学习体系应满足以下目标：

1. 可恢复：新会话可以快速接上项目上下文、最近决策和下一步建议
2. 可验证：重要记忆具备来源、状态和置信度
3. 可治理：过期、冲突、缺失的记忆能够被发现
4. 可晋升：重复经验可以逐步升级成 checklist、rule、workflow step 或 skill 草案
5. 低负担：小任务只需轻量更新，避免记忆维护本身成为额外负担
6. 不越权：记忆存在不代表自动启用 Superpowers，也不代表自动修改技能库

## 非目标

本阶段不引入以下能力：

- 外部记忆服务
- 向量库或 embedding 检索
- 模型参数级微调
- 自动直接修改 skill library
- 隐式后台学习

换句话说，本设计仍然坚持“仓库内显式知识闭环”，而不是黑盒式自演化系统。

## 现状问题

### 稳定性问题

- workflow 写了“应该更新记忆”，但没有统一验证环节
- 缺少会话结束检查表，容易只更新部分文件
- `CURRENT_STATE.md` 过期后没有机制提醒

### 可信度问题

- 重要结论缺少来源
- 没有区分已验证事实、推断结论和暂定判断
- 旧结论可能与新结论冲突，但没人发现

### 完整性问题

- 关键决策没有独立存放位置
- 重复失败模式和环境脆弱点没有稳定沉淀面
- 验证基线分散在会话和脚本里，没有形成长期知识

### 自学习闭环问题

- `LEARNING_BACKLOG.md` 目前更像候选池，没有治理状态
- 缺少“何时值得晋升成 checklist/rule/skill”的判断标准
- 缺少从学习候选到实现草案的稳定路径

## 目标目录结构

建议将 `.superpowers-memory/` 扩展为：

```text
.superpowers-memory/
  PROJECT_CONTEXT.md
  CURRENT_STATE.md
  DECISIONS.md
  KNOWN_FAILURES.md
  VERIFICATION_BASELINE.md
  TEAM_PREFERENCES.md
  LEARNING_BACKLOG.md
  memory-index.yaml
  session-journal/
```

### 文件职责

- `PROJECT_CONTEXT.md`
  保存长期稳定的项目事实，例如项目目标、系统边界、核心数据流和长期约束。
- `CURRENT_STATE.md`
  保存当前焦点、最新决策、开放问题和下一步建议。
- `DECISIONS.md`
  保存对未来仍有参考价值的重要设计或流程决策。
- `KNOWN_FAILURES.md`
  保存重复出现的失败模式、环境坑、误判模式和脆弱点。
- `VERIFICATION_BASELINE.md`
  保存本项目被认为“足够可信”的验证命令、验证范围和证据要求。
- `TEAM_PREFERENCES.md`
  保存团队协作偏好、编码习惯、提问边界和流程口径。
- `LEARNING_BACKLOG.md`
  保存可复用经验候选，并跟踪它们是否值得晋升成长期资产。
- `memory-index.yaml`
  保存元数据索引，用于健康检查、过期治理和摘要汇总。
- `session-journal/`
  保存重要会话的短日志，一次一文件。

## 元数据规范

建议为长期有效的记忆条目补充统一元数据：

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
  - `current_state`
  - `decision`
  - `failure_pattern`
  - `verification_rule`
  - `team_preference`
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

为减少维护负担，建议把记忆更新分为三层。

### Level 1：轻量更新

适用于小任务、普通修复、快速确认。

更新内容：

- `CURRENT_STATE.md`
- 一条 `session-journal`

### Level 2：结构化更新

适用于跨文件修改、关键决策、验证口径变化、暴露新坑。

更新内容：

- `CURRENT_STATE.md`
- `session-journal`
- 根据内容更新 `DECISIONS.md`、`KNOWN_FAILURES.md` 或 `VERIFICATION_BASELINE.md`

### Level 3：学习沉淀

适用于重要工作结束后，需要保留可复用经验。

更新内容：

- 所有必要记忆文件
- `LEARNING_BACKLOG.md`

### 触发原则

- 不要求所有会话都进入 Learning
- 不要求所有任务都更新所有文件
- 必须根据变化类型写入最合适的承载面

## 防遗漏触发器

建议在 workflow 中加入以下显式触发器：

- 模块边界、职责、数据流变化
  - 更新 `PROJECT_CONTEXT.md` 或 `DECISIONS.md`
- 当前任务、阻塞、下一步变化
  - 更新 `CURRENT_STATE.md`
- 一次重要实现、验证、回滚或交付结束
  - 新增 `session-journal`
- 发现重复 bug、环境坑、流程误判
  - 更新 `KNOWN_FAILURES.md`
- 引入新的可信验证命令
  - 更新 `VERIFICATION_BASELINE.md`
- 确认了团队偏好或协作边界
  - 更新 `TEAM_PREFERENCES.md`
- 相同经验重复出现两次及以上
  - 更新 `LEARNING_BACKLOG.md`

## 会话收尾检查表

建议将以下清单加入 Superpowers 相关 workflow 的收尾阶段：

1. 这次是否改变了长期项目事实？
2. 当前焦点、阻塞、下一步是否变化？
3. 是否产生了重要决策？
4. 是否暴露了失败模式、环境坑或常见误判？
5. 是否形成了新的验证口径？
6. 是否出现了可复用且重复的经验？
7. 新增或更新的记忆是否写入了日期、状态和来源？

## 学习候选的晋升机制

建议将 `LEARNING_BACKLOG.md` 升级为“学习候选池”，并为每个候选记录以下信息：

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

候选在满足以下条件后才建议晋升：

- `repeated_times >= 2`
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

- 不直接自动编辑 skill library
- 先产出草案，再由用户或维护者确认
- 没有来源支撑的候选不应直接晋升

## 校验器设计

建议新增脚本：

`scripts/validate-superpowers-memory.ps1`

### 检查范围

#### 结构检查

- `.superpowers-memory/` 是否存在
- 核心文件是否齐全
- 文件中是否存在关键标题或关键字段

#### 新鲜度检查

- `CURRENT_STATE.md` 是否缺少更新时间
- 最近 journal 是否缺失
- 存在活动任务但没有近期状态更新

#### 可信度检查

- 重要条目是否缺少 `source`
- 标记为 `verified` 的结论是否没有证据来源
- 长期 `tentative` 条目是否未复查

#### 冲突检查

- `CURRENT_STATE.md` 与 journal 是否存在明显冲突
- `PROJECT_CONTEXT.md` 与 `DECISIONS.md` 是否存在相互矛盾的长期声明

#### Backlog 治理检查

- 是否存在长期未处理的候选
- 是否存在高重复但长期不晋升的候选
- 是否把一次性会话记录误写进 backlog

### 输出级别

- `ERROR`
- `WARN`
- `INFO`

### 集成建议

- 在 `superpowers-feature-workflow` 完成前运行
- 在 `superpowers-openspec-execution-workflow` 归档前运行
- 在 `superpowers-learning-workflow` 落库后运行

## 与现有 workflow 的接入点

### `superpowers-feature-workflow`

建议增强为：

1. 开始前除了读取 `PROJECT_CONTEXT.md`、`CURRENT_STATE.md` 和最新 journal，也读取 `DECISIONS.md` 和 `KNOWN_FAILURES.md`
2. 结束前执行会话收尾检查表
3. 声称完成前运行 memory validator

### `superpowers-openspec-execution-workflow`

建议增强为：

1. 在 archive 前增加一次 memory alignment 检查
2. 确保 spec、implementation、verification、memory 四者一致

### `superpowers-learning-workflow`

建议增强为：

1. 从四桶分类升级为“分类 + 元数据 + 晋升判断”
2. 输出学习摘要的同时，给出是否建议生成 checklist/rule/skill 草案

## 推荐实施顺序

### 第一期

- 扩展记忆模板
- 新增 `DECISIONS.md`
- 新增 `KNOWN_FAILURES.md`
- 新增 `VERIFICATION_BASELINE.md`
- 新增 `TEAM_PREFERENCES.md`
- 升级 `LEARNING_BACKLOG.md`
- 新增 `validate-superpowers-memory.ps1`

### 第二期

- 引入 `memory-index.yaml`
- 增加 stale/conflict 检查
- 在 workflow 中增加统一的收尾检查表

### 第三期

- 增加候选晋升辅助脚本
- 生成 checklist/rule/skill draft 草案
- 在不越权的前提下形成半自动自学习闭环

## 成功标准

如果增强方案生效，应能观察到以下结果：

- 新会话更少重复追问项目背景
- 会话结束后更少遗漏当前状态和下一步
- 重要决策、失败模式和验证方法有明确归档位置
- 过期或矛盾记忆能被校验器发现
- 重复经验不再只停留在聊天记录里，而能稳定进入 backlog 并逐步晋升

## 总结

这套增强方案的核心不是让 agent “自动变聪明”，而是让仓库里的记忆更结构化、可验证、可治理、可晋升。这样既能保留当前方案的透明和可控，也能显著降低跨会话信息损失和经验沉淀失真。
