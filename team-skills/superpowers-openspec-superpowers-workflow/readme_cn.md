# Superpowers -> OpenSpec -> Superpowers Workflow

## 这条 workflow 是做什么的

`superpowers-openspec-superpowers-workflow` 适合那些不想靠猜、不想抢跑、也不想把复杂功能做着做着做乱掉的团队。

它的节奏是：

1. 先用 Superpowers 做探索和方案收敛
2. 再用 OpenSpec 把已经确认的事实锁定下来
3. 然后回到 Superpowers 做实现、测试、验证
4. 最后在需要时归档 OpenSpec change

这条 workflow 的重点不是“尽快开始写代码”，而是让从想法到实现的过程更稳、更清晰、更容易续接。

## 什么场景适合用

- 功能需求还不够清楚，需要先探索再写正式规格
- 团队希望先把方案方向想透，再生成 OpenSpec artifacts
- 变更会影响行为，需要明确测试和验证
- 希望实现、验证、归档都有清晰阶段，而不是混在一起推进

## 怎么触发

最简洁的触发方式：

```text
请按 superpowers-openspec-superpowers 工作流处理这个功能。
```

更显式的触发方式：

```text
Use $superpowers-openspec-superpowers-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```

对 Cursor 来说，推荐使用显式文本请求，而不是期待原生 slash command。

## 常见示例

“先确认 tasks，再进入实现”的示例：

```text
请按 superpowers-openspec-superpowers 工作流处理这个功能。
在 OpenSpec 的 tasks 生成后，先展示给我，并等待我确认后再进入实现。
```

“更严格地限制误路由”的示例：

```text
Use $superpowers-openspec-superpowers-workflow for this feature.

Start with Superpowers exploration first. Do not start with openspec-propose or the default OpenSpec workflow.
Then move to OpenSpec to generate proposal, design, spec, and tasks.
After OpenSpec tasks are generated, show them to me and wait for my confirmation before implementation.
Do not suggest /opsx:apply.
```

这类严格版示例更适合下面这些场景：

- 项目里同时装过 `openspec-superpowers` 和 `superpowers-openspec-superpowers`
- `.cursor/rules/` 里残留过旧规则
- 你已经观察到模型会先跳去 OpenSpec 命令，或者会在 `tasks.md` 后提示 `/opsx:apply`

如果项目规则干净、bundle 单一、路由稳定，前面的简洁示例通常已经够用。

## 工作流顺序

1. 先用 Superpowers 探索上下文、澄清需求、比较方案，并确认设计方向
2. 再用 OpenSpec 生成 `proposal.md`、`design.md`、`specs/.../spec.md`、`tasks.md`
3. 展示并确认生成出来的 `tasks.md`
4. `tasks.md` 确认后，先暂停并询问是否继续执行开发
5. 回到 Superpowers，写实现计划，按 TDD 执行实现，并进行 fresh verification
6. 开发与验证完成后，再暂停并询问是否继续代码审查
7. 如果代码、测试和规格已经对齐，再归档 OpenSpec change

如果这次工作还产生了值得长期保留的经验，建议在归档后继续使用 `superpowers-learning-workflow` 更新项目记忆。

## 控制点

- 探索阶段不能直接写生产代码
- OpenSpec artifacts 没准备好之前不能开始编码
- 默认情况下，`tasks.md` 确认前不进入实现计划或编码
- `tasks.md` 确认后，不应回落到 OpenSpec apply
- `tasks.md` 确认后，下一步必须先询问是否继续执行开发
- 代码审查不应和 `tasks.md` 确认放在同一个分叉点，而应在执行与验证完成后再单独提示
- 没有 fresh verification 输出，不应声称工作完成
- 代码、测试、规格没有对齐前，不应归档

## 常用续接命令

- `continue-dev`
- `continue-review`
- `continue-archive`

原有 OpenSpec / Superpowers 命令依旧可用，这些续接命令只是更短的快捷方式。

## 预期产物

- `docs/superpowers/specs/` 下的设计草稿
- `openspec/changes/<change-name>/` 下的 proposal、design、spec、tasks
- `docs/superpowers/plans/` 下的实现计划
- 已验证的代码改动
- 完成后的 OpenSpec change 归档
- 可选后续产物：通过 `superpowers-learning-workflow` 更新 `.superpowers-memory/` 和经验沉淀

## 这条 workflow 的价值

- 给复杂功能一条“先想透、再锁准、最后做稳”的节奏
- 避免团队因为着急推进而过早开始编码
- 让 OpenSpec 只承载已经确认的事实，而不是半成品想法
- 把最重要的实现与验证阶段重新交回 Superpowers，确保事情真正落地
