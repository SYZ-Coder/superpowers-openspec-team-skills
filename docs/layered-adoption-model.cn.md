# Core / Enhanced / Advanced 分层采用模型

本文档用于回答一个实际问题：

当前增强版能力越来越完整，如何避免“功能越来越强，但仓库越来越重”。

答案不是删能力，而是明确分层。

建议把当前能力分成 3 层：

- Core：最小可用层
- Enhanced：完整工程协作层
- Advanced：长期积累与晋升层

这样做的目标是：

- 降低学习成本
- 降低误用风险
- 降低小项目接入门槛
- 控制维护复杂度
- 保留增强能力的长期价值

## 1. 总体原则

不是所有项目都需要全量开启所有增强功能。

更合理的方式是：

- 小项目、小任务、短周期工作先用 Core
- 有跨会话协作和明确验证要求的项目用 Enhanced
- 需要长期积累、知识复用、流程晋升的项目再用 Advanced

一句话理解：

Core 保证能用，Enhanced 保证好用，Advanced 保证可积累。

## 2. Core 层

### 2.1 定位

Core 是最小可用层，适合：

- 小项目
- 单人或低协作项目
- 一次性任务
- 刚开始尝试这套技能库的团队

### 2.2 Core 包含什么

建议 Core 只包含：

- `PROJECT_CONTEXT.md`
- `CURRENT_STATE.md`
- `session-journal/`
- `validate-superpowers-memory.*`

可选保留：

- `SESSION_CLOSE_CHECKLIST.md`

### 2.3 Core 解决什么问题

Core 主要解决 3 件事：

- 下次进会话时知道项目长期事实
- 知道当前工作停在哪
- 通过最基础的 validator 避免明显缺项

### 2.4 Core 的典型动作

会话开始：

- 读 `PROJECT_CONTEXT.md`
- 读 `CURRENT_STATE.md`
- 读最近 journal

会话结束：

- 更新 `CURRENT_STATE.md`
- 写一条 journal
- 视情况运行 validator

### 2.5 Core 的优点

- 最容易理解
- 最容易落地
- 文档负担最轻
- 小项目接受度最高

### 2.6 Core 的代价

- 不会系统沉淀决策和失败模式
- 检索能力弱
- 学习候选和晋升闭环不明显

## 3. Enhanced 层

### 3.1 定位

Enhanced 是完整工程协作层，适合：

- 中大型项目
- 多会话协作
- 需要明确验证基线的项目
- 容易重复踩坑的项目

### 3.2 Enhanced 包含什么

在 Core 基础上增加：

- `DECISIONS.md`
- `KNOWN_FAILURES.md`
- `VERIFICATION_BASELINE.md`
- `TEAM_PREFERENCES.md`
- `memory-index.yaml`
- `search-superpowers-memory.*`
- `suggest-superpowers-memory-updates.*`
- `run-superpowers-memory-closeout.*`

### 3.3 Enhanced 解决什么问题

Enhanced 主要解决：

- 为什么这样做有迹可循
- 哪些坑已经踩过不再重复踩
- 哪些验证才算有效
- 收尾不再靠临场记忆
- 历史知识能被检索出来

### 3.4 Enhanced 的典型动作

会话开始：

- 读项目事实和当前状态
- 读决策、失败模式、验证基线、团队偏好
- 读最近 journal

会话结束：

- 按变化更新相应记忆面
- 运行 suggestion 获取建议
- 运行 closeout helper 标准收尾
- 按需运行 validator

### 3.5 Enhanced 的优点

- 完整性明显更强
- 可信度更高
- 跨会话恢复效率更好
- 遗漏率更低

### 3.6 Enhanced 的代价

- 文件面明显变多
- 维护成本上升
- 文档同步压力更高

## 4. Advanced 层

### 4.1 定位

Advanced 是长期积累与晋升层，适合：

- 长期维护仓库
- 多人协作团队
- 需要把经验变成规则、checklist 或 skill 的场景
- 希望沉淀用户偏好和 agent 注意事项的场景

### 4.2 Advanced 包含什么

在 Enhanced 基础上增加：

- `USER_PROFILE.md`
- `AGENT_NOTES.md`
- `LEARNING_BACKLOG.md`
- `generate-superpowers-promotion-drafts.*`
- `promotion-drafts/`

### 4.3 Advanced 解决什么问题

Advanced 主要解决：

- 用户偏好不再污染项目事实
- agent 执行提醒不再混入团队规则
- 学到的经验能进入候选池
- 候选可以逐步晋升为草案资产

### 4.4 Advanced 的典型动作

会话开始：

- 在 Enhanced 基础上，再读 `USER_PROFILE.md` 与 `AGENT_NOTES.md`

会话结束：

- 对本次经验做候选归类
- 更新 `LEARNING_BACKLOG.md`
- 对成熟候选生成 promotion drafts
- 人工审核后再决定是否正式晋升

### 4.5 Advanced 的优点

- 最适合长期协作
- 最适合知识积累
- 最接近真正的“自学习闭环”

### 4.6 Advanced 的代价

- 最重
- 最依赖治理纪律
- 最容易因文档和口径不同步而产生维护压力

## 5. 三层对比

| 维度 | Core | Enhanced | Advanced |
|---|---|---|---|
| 目标 | 最小可用 | 完整协作 | 长期积累 |
| 适合场景 | 小项目/短任务 | 中大型协作项目 | 长期知识型项目 |
| 文件数量 | 少 | 中 | 多 |
| 收尾复杂度 | 低 | 中 | 高 |
| 检索能力 | 低 | 中高 | 高 |
| 学习闭环 | 弱 | 中 | 强 |
| 维护成本 | 低 | 中 | 高 |

## 6. 推荐采用策略

建议不要默认所有项目都从 Advanced 开始。

推荐策略：

1. 默认从 Core 开始
2. 只有出现明确需求时才升到 Enhanced
3. 只有当项目确实需要长期积累与晋升时才进入 Advanced

推荐触发条件：

- 如果项目开始频繁跨会话协作，升级到 Enhanced
- 如果项目开始频繁出现重复决策和重复失败模式，升级到 Enhanced
- 如果团队明确希望沉淀用户偏好、agent 注意事项和学习候选，升级到 Advanced

## 7. 如何降低臃肿风险

为了避免增强能力演变成臃肿，建议遵守下面几条：

- 不要默认全开所有记忆面
- 小项目优先使用 Core
- 不要继续轻易新增新的 memory 文件
- 文档上明确哪一层是推荐默认层
- 脚本入口尽量收敛到 install / validate / search / closeout / promote 这几类

## 8. 当前仓库最适合的理解方式

当前仓库已经具备：

- Core：完整可用
- Enhanced：完整可用
- Advanced：主体可用，但仍需持续治理和真实场景打磨

因此更准确的说法不是“仓库已经臃肿”，而是：

仓库已经进入需要通过分层模型来控制复杂度的阶段。

## 9. 一句话总结

Core / Enhanced / Advanced 三层模型的意义，不是把能力削弱，而是让不同项目用合适的复杂度接入这套技能库，从而在保留增强能力价值的同时，避免仓库走向真正的臃肿。
