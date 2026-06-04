# Superpowers -> OpenSpec -> Superpowers Workflow

## 当前工作流做什么

`superpowers-openspec-superpowers-workflow` 适合那些“不想靠猜、不想抢跑、也不想把复杂功能做着做着做乱掉”的团队。

它先用 Superpowers 把问题想透，再用 OpenSpec 把已经确认的事实锁准，最后再回到 Superpowers，把实现、测试、验证和归档一步步做稳。

适合用在“需求还没完全清楚、改动又很重要、团队希望整个过程稳而不乱”的场景。

## 什么时候使用

- 功能需求还不够清晰，需要先探索再写正式规范。
- 团队希望在方案方向确认后再生成 OpenSpec 产物。
- 该功能会改变行为，需要明确测试和验证。
- 实现完成后还需要把 OpenSpec change 作为最后一步归档。

## 怎么使用

在功能请求中调用：

```text
请按 superpowers-openspec-superpowers 工作流处理这个功能。
```

补充写法：

```text
请使用 $superpowers-openspec-superpowers-workflow 处理这个功能：先用 Superpowers 做探索，再用 OpenSpec 锁定变更，最后回到 Superpowers 完成实现、测试、验证和归档。
```

对 Cursor 来说，请使用这种显式文本请求方式。

典型的“先确认后实现”示例：

```text
请按 superpowers-openspec-superpowers 工作流处理这个功能。
在 OpenSpec 的 tasks 生成后，先展示给我，并等待我确认后再进入实现。
```

典型的“直接进入实现”示例：

```text
请按 superpowers-openspec-superpowers 工作流处理这个功能。
在 OpenSpec 的 tasks 生成后，直接继续进入实现阶段。
```

## 工作流顺序

1. 先用 Superpowers 探索上下文、澄清需求、比较方案，并确认设计方向。
2. 再用 OpenSpec 补齐已经确认的 change 产物，包括 `proposal.md`、`design.md`、`specs/.../spec.md` 和 `tasks.md`。
3. 让用户确认生成出来的 OpenSpec `tasks.md` 任务清单。
4. 回到 Superpowers 编写实现计划，按 TDD 执行实现，并运行新的验证。
5. 只有在代码、测试和规范都对齐后，才归档 OpenSpec change。

如果本次工作里还产生了可复用经验，可以在归档后继续使用 `superpowers-learning-workflow`。

## 控制点

- 探索阶段不能写生产代码。
- 必需的 OpenSpec 产物完成前不能开始编码。
- 默认情况下，用户没有确认 OpenSpec `tasks.md` 之前，不能进入实现计划或编码阶段。
- 如果用户明确要求 tasks 生成后直接执行，可以跳过这一步确认暂停。
- `tasks.md` 确认后，workflow 不应回落到 OpenSpec apply。
- 代码审查不会和 `tasks.md` 确认放在同一个分叉点上，而应在执行与验证完成后再单独提示。
- 没有新的验证输出不能声称完成。
- 实现、测试和规范对齐前不能归档。

## 预期产物

- `docs/superpowers/specs/` 下的 Superpowers 设计草稿
- `openspec/changes/<change-name>/` 下的 proposal、design、specs、tasks
- `docs/superpowers/plans/` 下的实现计划
- 已验证的代码变更
- 完成后的 OpenSpec change 归档
- 可选后续产物：通过 `superpowers-learning-workflow` 更新记忆和经验沉淀

## 进阶说明

- `task_confirmation_mode` 支持 `required`、`optional`、`off` 三种模式。
- 默认模式是 `optional`。
- `tasks.md` 确认后，下一步应进入执行开发，而不是 OpenSpec apply。
- 常用续接命令有 `continue-dev`、`continue-review`、`continue-archive`。
- 原有 OpenSpec / Superpowers 命令和 skill 入口仍然有效，这些续接口令只是更短的快捷方式。

## 优势

- 给复杂功能一条“先想透、再锁准、最后做稳”的节奏，而不是一路靠直觉硬推。
- 避免团队因为着急推进而过早开始编码。
- 让 OpenSpec 只承载已经确认的事实，而不是半成品想法。
- 把最重要的实现与验证阶段重新交回 Superpowers，确保事情真正落地、真正做稳。
