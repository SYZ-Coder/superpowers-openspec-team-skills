# Superpowers Learning Workflow

## 当前工作流做什么？

`superpowers-learning-workflow` 是一个在重要工作结束后使用的反思型 workflow，用来把当前会话真正值得保留下来的内容沉淀到仓库里。

它很适合接在这些 workflow 后面使用：

- `superpowers-feature-workflow`
- `superpowers-openspec-execution-workflow`
- `openspec-superpowers-workflow`

它会帮助团队把最近的工作整理成四类内容：

1. 稳定的项目事实
2. 当前工作状态
3. 简短的会话记录
4. 未来可能沉淀成 workflow、skill 或 checklist 的可复用经验

## 什么时候使用？

- 一次重要任务或会话刚结束。
- 团队希望下一次会话能直接接上当前上下文。
- 这次工作里出现了重复坑点或可复用方法。
- 用户希望把经验留在仓库里，而不是只留在聊天记录中。

## 怎么使用

在重要工作结束后调用：

```text
Use $superpowers-learning-workflow to capture what this session taught us and update the project memory.
```

典型串联方式：

```text
1. 先执行一个交付型 workflow
2. 完成实现与验证
3. 再用 $superpowers-learning-workflow 把本次经验沉淀下来
```

## 工作流顺序

1. 回顾最近的工作、决策和验证结果。
2. 把稳定事实和临时状态分开。
3. 如果项目事实发生变化，更新 `.superpowers-memory/PROJECT_CONTEXT.md`。
4. 更新 `.superpowers-memory/CURRENT_STATE.md`，写入当前最新状态。
5. 在 `.superpowers-memory/session-journal/` 下补一条简短会话记录。
6. 把可复用经验写入 `.superpowers-memory/LEARNING_BACKLOG.md`。

## 控制点

- 不要把临时任务噪音写进稳定项目背景。
- 不要太早把一次性修复提升成可复用规则。
- 不要在用户没有明确要求时直接修改技能库本身。

## 预期产物

- 更新后的项目记忆
- 一份简短的学习总结
- 后续可转化成 skill 或 checklist 的经验候选

## 优势

- 能把真正有价值的项目上下文跨会话保留下来。
- 能把稳定知识和临时状态拆开管理。
- 给团队提供一条从“本次经验”走向“未来可复用方法”的安全路径。
