# OpenSpec + Superpowers Workflow

## 当前工作流做什么

`openspec-superpowers-workflow` 是完整功能交付的总入口。它把 Superpowers 的探索、设计、计划、TDD、验证纪律，和 OpenSpec 的 proposal、design、spec、tasks 变更产物组合在一起。

适合用于“既要想清楚、又要留下规范记录、最后还要可靠实现”的功能开发。

## 什么时候使用

- 用户明确要求使用 OpenSpec + Superpowers。
- 功能不是简单改动，需要澄清、方案、规范、任务、实现、测试和验证。
- 仓库或团队要求行为变更前先补齐 OpenSpec 产物。
- 希望用一个入口统一协调从想法到验证完成的完整流程。

## 怎么使用

在智能体提示词中直接调用：

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

然后描述你的功能需求。该 skill 会按顺序引导 Superpowers 探索、OpenSpec 产物、OpenSpec 任务确认、实现计划、TDD 和最终验证。

默认控制方式：

- `task_confirmation_mode: optional`
- 默认会展示生成出来的 OpenSpec `tasks.md`，并等待你确认后再进入实现计划。
- 如果你在提示词里明确要求“tasks 生成后直接执行”，就可以跳过这一步确认暂停。

使用示例：

```text
Use $openspec-superpowers-workflow for this feature.
OpenSpec tasks 生成后先给我看，我确认后再进入实现。
```

适合你想先审阅 OpenSpec 任务清单，再继续进入实现计划。

```text
Use $openspec-superpowers-workflow for this feature.
OpenSpec tasks 生成后直接进入实现，不用等我确认任务清单。
```

适合你已经接受 OpenSpec 任务拆解，希望任务生成后直接进入实现。

## 控制点

- 设计确认前不能进入实现计划。
- OpenSpec 产物完成前不能开始编码。
- 默认情况下，OpenSpec `tasks.md` 需要先让用户确认，之后才能进入实现计划。
- 如果用户明确要求 tasks 生成后直接执行，可以跳过这一步确认暂停。
- 实现阶段应遵循 Superpowers 的计划和 TDD 纪律。
- 声称完成前必须有新的验证输出。

## 预期产物

- `docs/superpowers/specs/` 下的设计文档
- `openspec/changes/<change-name>/` 下的 OpenSpec change
- `docs/superpowers/plans/` 下的实现计划
- 代码、测试和验证结果

## 优势

- 为复杂功能提供一个统一、好记的入口。
- 把探索思考、正式规范和实现纪律串成一条完整链路。
- 通过明确门禁减少跳步骤的风险。
- 产物可长期保留，方便后续维护者理解变更原因。
## 最新流程说明

- 这个 workflow 中，OpenSpec 只负责产出和确认 `proposal.md`、`design.md`、`spec.md`、`tasks.md`，不负责后续 `apply` 实现。
- 当 `tasks.md` 生成并被用户确认后，禁止回落到 OpenSpec `apply`，也不应提示用户执行 `/opsx:apply`。
- `tasks.md` 确认后，下一步只提示用户是否继续执行开发。
- 这里的“继续执行开发”仍然包含 Superpowers 的实现计划、开发、TDD 和验证。
- 只有当执行开发和验证都完成后，才再单独提示用户是否继续代码审查。
- 代码审查不是 `tasks.md` 确认后的第一分支，而是执行完成后的后续质量步骤。
- 对应固定口令分别是：`继续开发` / `continue-dev`，以及 `继续审查` / `continue-review`。
- 如果后续进入归档阶段，还可以使用 `继续归档` / `continue-archive`。
- 原有的 OpenSpec / Superpowers 命令和 skill 入口仍然可以继续使用，这些只是更短的续接口令。
