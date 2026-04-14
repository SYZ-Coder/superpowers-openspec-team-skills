# Superpowers -> OpenSpec -> Superpowers Workflow

## 当前工作流做什么？

`superpowers-openspec-execution-workflow` 把功能开发拆成四个明确步骤：

1. 先用 Superpowers 探索和收敛方案。
2. 再用 OpenSpec 固化已经确认的行为和产物。
3. 最后回到 Superpowers 执行实现、测试、验证。
4. 在代码、测试和规范对齐后归档 OpenSpec change。

它适合团队采用“先探索、再锁规范、再执行实现、最后归档”的节奏。

## 什么时候使用？

- 功能需求还不够清晰，需要先探索再写正式规范。
- 团队希望在方案方向确认后再生成 OpenSpec 产物。
- 该功能会改变行为，需要明确测试和验证。
- 实现完成后还需要把 OpenSpec change 作为最后一步归档。

## 怎么使用

在功能请求中调用：

```text
Use $superpowers-openspec-execution-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```

这会明确工作顺序，避免智能体直接跳到编码。

## 工作流顺序

1. 先用 Superpowers 探索上下文、澄清需求、比较方案，并确认设计方向。
2. 再用 OpenSpec 补齐已经确认的 change 产物，包括 `proposal.md`、`design.md`、`specs/.../spec.md` 和 `tasks.md`。
3. 回到 Superpowers 编写实现计划，按 TDD 执行实现，并运行新的验证。
4. 只有在代码、测试和规范都对齐后，才归档 OpenSpec change。

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

- 把探索、规范、执行、归档四个阶段拆清楚，交接点更明确。
- 把探索和规范分开，避免过早固化不清晰的需求。
- 让 OpenSpec 聚焦已经确认的行为，而不是头脑风暴过程。
- 在归档前保留 TDD 和验证纪律，收尾更稳。
