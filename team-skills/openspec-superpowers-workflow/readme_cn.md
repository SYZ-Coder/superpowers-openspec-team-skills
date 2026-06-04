# OpenSpec + Superpowers Workflow

## 当前工作流做什么

`openspec-superpowers-workflow` 是完整功能交付的总入口。

它把 Superpowers 的探索、设计确认、实现计划、TDD、验证纪律，与 OpenSpec 的 proposal、design、spec、tasks 产物组合在一起。

适合用于“既要想清楚、又要留下正式规范记录、最后还要可靠实现”的功能开发。

## 什么时候使用

- 用户明确要求使用 OpenSpec + Superpowers。
- 功能不是简单改动，需要澄清、方案、规范、任务、实现、测试和验证。
- 仓库或团队要求行为变更前先补齐 OpenSpec 产物。
- 希望用一个入口统一协调从想法到验证完成的完整流程。

## 怎么使用

在智能体提示词中直接调用：

```text
请使用 $openspec-superpowers-workflow 处理这个功能，从需求澄清一直推进到验证完成。
```

然后描述你的功能需求。该 workflow 会按顺序引导 Superpowers 探索、OpenSpec 产物、任务确认、实现计划、TDD 和最终验证。

典型的“先确认后实现”示例：

```text
请使用 $openspec-superpowers-workflow 处理这个功能。
在 OpenSpec 的 tasks 生成后，先展示给我，并等待我确认后再进入实现。
```

典型的“直接进入实现”示例：

```text
请使用 $openspec-superpowers-workflow 处理这个功能。
在 OpenSpec 的 tasks 生成后，直接继续进入实现阶段。
```

## 工作流顺序

1. 先用 Superpowers 探索上下文、澄清需求、比较方案，并确认设计方向。
2. 再用 OpenSpec 创建或补齐 `proposal.md`、`design.md`、spec delta 和 `tasks.md`。
3. 让用户确认生成出来的 OpenSpec `tasks.md`。
4. 回到 Superpowers 编写实现计划，按 TDD 执行开发，并运行新的验证。
5. 如果项目流程需要，再进入后续审查或归档步骤。

如果本次工作还需要沉淀项目记忆或可复用经验，可以在交付完成后继续使用 `superpowers-learning-workflow`。

## 控制点

- 设计确认前不能进入实现计划。
- OpenSpec 产物完成前不能开始编码。
- 默认情况下，OpenSpec `tasks.md` 需要先让用户确认，之后才能进入实现计划。
- 如果用户明确要求 tasks 生成后直接执行，可以跳过这一步确认暂停。
- `tasks.md` 确认后，workflow 不应回落到 OpenSpec apply。
- 代码审查不应作为 `tasks.md` 确认后的第一分支，而应在执行与验证完成后再单独提示。
- 实现阶段应遵循 Superpowers 的计划和 TDD 纪律。
- 声称完成前必须有新的验证输出。

## 预期产物

- `docs/superpowers/specs/` 下的设计文档
- `openspec/changes/<change-name>/` 下的 OpenSpec change
- `docs/superpowers/plans/` 下的实现计划
- 代码、测试和验证结果
- 可选后续产物：通过 `superpowers-learning-workflow` 更新 `.superpowers-memory/` 和复用经验

## 进阶说明

- `task_confirmation_mode` 支持 `required`、`optional`、`off` 三种模式。
- 默认模式是 `optional`。
- `tasks.md` 确认后，下一步应进入执行开发，而不是 OpenSpec apply。
- 代码审查应在执行开发和验证完成后再触发。
- 常用续接命令有 `continue-dev`、`continue-review`、`continue-archive`。
- 原有 OpenSpec / Superpowers 命令和 skill 入口仍然有效，这些续接口令只是更短的快捷方式。

## 优势

- 为复杂功能提供一个统一、好记的入口。
- 把探索思考、正式规范和实现纪律串成一条完整链路。
- 通过明确门禁减少跳步骤的风险。
- 产物可长期保留，方便后续维护者理解变更原因。
