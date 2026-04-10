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

然后描述你的功能需求。该 skill 会按顺序引导 Superpowers 探索、OpenSpec 产物、实现计划、TDD 和最终验证。

## 控制点

- 设计确认前不能进入实现计划。
- OpenSpec 产物完成前不能开始编码。
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
