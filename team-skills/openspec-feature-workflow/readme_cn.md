# OpenSpec Feature Workflow

## 当前工作流做什么

`openspec-feature-workflow` 用于创建并补齐实现前需要的 OpenSpec change 产物：proposal、design、specs 和 tasks。

它专注于“把变更正式化”。它本身不负责 TDD、worktree 或实现后的验证流程。

## 什么时候使用

- 仓库要求非平凡行为变更必须走 OpenSpec。
- 功能在编码前需要 `proposal.md`、`design.md`、spec delta 和 `tasks.md`。
- 团队希望长期保留“为什么改、改了什么行为”的记录。
- 你已经足够理解目标行为，可以开始写正式变更产物。

## 怎么使用

在变更请求中调用：

```text
Use $openspec-feature-workflow to create and complete the OpenSpec change for this feature.
```

该工作流会推导或确认 kebab-case change 名称，创建 OpenSpec change 目录，读取 OpenSpec instructions，并按依赖顺序完成产物。

## 控制点

- 创建产物前必须确认或推导 change 名称。
- 使用 `openspec status --change "<change-name>" --json` 决定产物顺序。
- 写每个产物前应先读取对应 OpenSpec instructions。
- 必需产物完成前不应开始编码。

## 预期产物

- `openspec/changes/<change-name>/proposal.md`
- `openspec/changes/<change-name>/design.md`
- `openspec/changes/<change-name>/specs/.../spec.md`
- `openspec/changes/<change-name>/tasks.md`

## 优势

- 为行为变更产出一致的 OpenSpec 文档。
- 把需求、设计决策和实现任务连接起来。
- 通过拆分意图、技术方案、规范行为和任务清单，让评审更清晰。
- 避免从模糊请求直接进入编码。
