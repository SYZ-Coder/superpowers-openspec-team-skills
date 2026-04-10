# Superpowers -> OpenSpec -> Superpowers Workflow

## 当前工作流做什么

`superpowers-openspec-execution-workflow` 把功能开发拆成三个阶段：

1. 先用 Superpowers 探索和收敛方案。
2. 再用 OpenSpec 固化已经确认的行为和产物。
3. 最后回到 Superpowers 执行实现、测试、验证和 change 归档。

它适合团队采用“先探索、再锁规范、最后严谨执行”的节奏。

## 什么时候使用

- 功能需求还不够清晰，需要先探索再写正式规范。
- 团队希望在方案方向确认后再生成 OpenSpec 产物。
- 该功能会改变行为，需要明确测试和验证。
- 实现完成后希望归档 OpenSpec change。

## 怎么使用

在功能请求中调用：

```text
Use $superpowers-openspec-execution-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```

这会明确工作顺序，避免智能体直接跳到编码。

## 控制点

- 探索阶段不能写生产代码。
- 必需的 OpenSpec 产物完成前不能开始编码。
- 没有新的验证输出不能声称完成。
- 实现、测试和规范对齐前不能归档。

## 预期产物

- `docs/superpowers/specs/` 下的 Superpowers 设计草稿
- `openspec/changes/<change-name>/` 下的 proposal、design、specs、tasks
- `docs/superpowers/plans/` 下的实现计划
- 已验证的代码变更
- 完成后的 OpenSpec change 归档

## 优势

- 把探索和规范分开，避免过早固化不清晰的需求。
- 让 OpenSpec 聚焦已经确认的行为，而不是头脑风暴过程。
- 在实现阶段重新引入 TDD 和验证纪律。
- 支持通过归档 OpenSpec change 给工作一个清晰收尾。
