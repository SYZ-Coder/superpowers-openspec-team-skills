# Superpowers -> OpenSpec -> Superpowers Workflow

## 这条 workflow 是做什么的

`superpowers-openspec-superpowers-workflow` 适合那些不想靠猜、不想抢跑、也不想把复杂功能做着做着做乱掉的团队。

它的节奏是：

1. 先用 Superpowers 做探索和方案收敛
2. 再用 OpenSpec 把已经确认的事实锁定下来
3. 然后回到 Superpowers 做实现、测试、验证
4. 最后在需要时归档 OpenSpec change

这条 workflow 的重点不是“尽快开始写代码”，而是让从想法到实现的过程更稳、更清晰、更容易接续。

## 什么时候适合用

- 功能需求还不够清楚，需要先探索再写正式规格
- 团队希望先把方案方向想透，再生成 OpenSpec artifacts
- 变更会影响行为，需要明确测试和验证
- 希望实现、验证、归档都有明确阶段，而不是混在一起推进

## 怎么使用

最简洁的触发方式：

```text
请按 superpowers-openspec-superpowers 工作流处理这个功能。
```

更显式的触发方式：

```text
Use $superpowers-openspec-superpowers-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```

对 Cursor 来说，推荐使用这种显式文本请求，而不是期待原生 slash command。

## 常见示例

“先确认 tasks，再进入实现”的示例：

```text
请按 superpowers-openspec-superpowers 工作流处理这个功能。
在 OpenSpec 的 tasks 生成后，先展示给我，并等待我确认后再进入实现。
```

“tasks 后直接继续执行”的示例：

```text
请按 superpowers-openspec-superpowers 工作流处理这个功能。
在 OpenSpec 的 tasks 生成后，直接继续进入实现阶段。
```

## 严格版示例

如果 Cursor 项目里混装过多个 workflow bundle、残留过旧规则，或者你怀疑路由有歧义，推荐使用下面这个更稳的提示词：

```text
Use $superpowers-openspec-superpowers-workflow for this feature.

先用 Superpowers 做探索，不要先进入 openspec-propose 或默认 OpenSpec workflow。
然后再进入 OpenSpec，生成 proposal、design、spec、tasks。
在 OpenSpec tasks 生成后，先展示给我，并等待我确认后再进入实现。
不要提示 /opsx:apply。
```

这条“严格版示例”不是为了替代前面的简洁示例，而是在这些场景里更适合：

- 项目里同时装过 `openspec-superpowers` 和 `superpowers-openspec-superpowers`
- `.cursor/rules/` 里残留过旧版本规则
- 你已经观察到模型会先列 OpenSpec 命令，或者会在 `tasks.md` 后提示 `/opsx:apply`

如果项目规则干净、bundle 单一、路由稳定，前面的简洁示例通常已经够用。

## 工作流顺序

1. 先用 Superpowers 探索上下文、澄清需求、比较方案，并确认设计方向
2. 再用 OpenSpec 生成 `proposal.md`、`design.md`、`specs/.../spec.md`、`tasks.md`
3. 展示并确认生成出来的 `tasks.md`
4. 回到 Superpowers，写实现计划，按 TDD 执行实现，并进行 fresh verification
5. 如果代码、测试和规格已经对齐，再归档 OpenSpec change

如果这次工作还产生了值得长期保留的经验，建议在归档后继续使用 `superpowers-learning-workflow` 更新项目记忆。

## 控制点

- 探索阶段不能直接写生产代码
- OpenSpec artifacts 没准备好之前不能开始编码
- 默认情况下，`tasks.md` 确认前不进入实现计划或编码
- 如果用户明确要求 `tasks.md` 后直接执行，可以跳过确认暂停
- `tasks.md` 确认后，不应回落到 OpenSpec apply
- 代码审查不应和 `tasks.md` 确认放在同一个分叉点，而应在执行与验证完成后再单独提示
- 没有 fresh verification 输出，不应声称工作完成
- 代码、测试、规格没有对齐前，不应归档

## 预期产物

- `docs/superpowers/specs/` 下的设计草稿
- `openspec/changes/<change-name>/` 下的 proposal、design、spec、tasks
- `docs/superpowers/plans/` 下的实现计划
- 已验证的代码改动
- 完成后的 OpenSpec change 归档
- 可选后续产物：通过 `superpowers-learning-workflow` 更新 `.superpowers-memory/` 和经验沉淀

## 进阶说明

- `task_confirmation_mode` 支持 `required`、`optional`、`off`
- 默认模式是 `optional`
- `tasks.md` 确认后，下一步应该进入执行开发，而不是 OpenSpec apply
- 常用续接命令有 `continue-dev`、`continue-review`、`continue-archive`
- 原有 OpenSpec / Superpowers 命令仍然有效，续接命令只是更短的快捷方式

## 优势

- 给复杂功能一条“先想透、再锁准、最后做稳”的节奏
- 避免团队因为着急推进而过早开始编码
- 让 OpenSpec 只承载已经确认的事实，而不是半成品想法
- 把最重要的实现与验证阶段重新交回 Superpowers，确保事情真正落地
