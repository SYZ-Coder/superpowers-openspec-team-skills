# Superpowers Feature Workflow

## 当前工作流做什么

`superpowers-feature-workflow` 覆盖 Superpowers 侧的功能交付流程：需求探索、设计确认、实现计划、worktree、TDD 和最终验证。

它不会创建 OpenSpec 产物。适合只需要严谨实现流程，但不需要正式 OpenSpec change 记录的场景。

## 什么时候使用

- 需求在编码前需要头脑风暴或设计确认。
- 用户希望先写实现计划。
- 工作适合放到独立 worktree 中完成。
- 功能需要先写失败测试，再实现，并在完成前验证。

## 怎么使用

在功能请求中调用：

```text
Use $superpowers-feature-workflow to drive the Superpowers stages for this feature request.
```

该工作流会先探索项目上下文，再澄清需求、比较方案、写设计、写计划，并引导带测试的实现。

## 控制点

- 提方案前先探索项目上下文。
- 每次只澄清一个关键问题。
- 实现计划前需要确认设计。
- 新行为默认按 TDD 执行。
- 报告完成前必须有新的验证证据。

## 预期产物

- 已确认的设计文档
- 实现计划
- 代码变更
- 测试和验证证据

## 优势

- 不引入 OpenSpec 的情况下，为功能开发增加结构化纪律。
- 编码前明确设计决策。
- 鼓励小步、可测试的实现方式。
- 通过强制验证减少“看起来完成但没有证据”的收尾风险。
