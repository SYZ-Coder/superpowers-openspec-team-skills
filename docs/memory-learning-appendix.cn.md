# 记忆与自学习精简附录

这是一份可供 skill、workflow、设计文档快速引用的精简附录。

## 记忆文件分工

- `PROJECT_CONTEXT.md`：长期稳定的项目事实
- `CURRENT_STATE.md`：当前工作状态、阻塞与下一步
- `DECISIONS.md`：关键决策与取舍原因
- `KNOWN_FAILURES.md`：重复出现的失败模式和常见坑
- `VERIFICATION_BASELINE.md`：可信验证方法与通过标准
- `TEAM_PREFERENCES.md`：团队偏好、协作规则和边界
- `USER_PROFILE.md`：不属于项目事实的稳定用户偏好
- `AGENT_NOTES.md`：与仓库执行相关的稳定提醒
- `session-journal/`：本次会话的执行经过与结果
- `LEARNING_BACKLOG.md`：未来可能晋升为 checklist / rule / skill 的候选经验
- `SESSION_CLOSE_CHECKLIST.md`：统一的收尾检查表
- `memory-index.yaml`：由脚本维护的健康摘要与候选统计

## 典型会话顺序

```text
读 PROJECT_CONTEXT
读 CURRENT_STATE
读 decisions / failures / verification / preferences
读最近 journal
开始工作
更新 CURRENT_STATE
写 session journal
补 decision / failure / verification / preference
必要时补 PROJECT_CONTEXT
必要时补 LEARNING_BACKLOG
跑 validator
必要时生成 promotion drafts
```

## 核心脚本

- [validate-superpowers-memory.ps1](/D:/spring_AI/superpowers-openspec-team-skills/scripts/validate-superpowers-memory.ps1)
- [validate-superpowers-memory.sh](/D:/spring_AI/superpowers-openspec-team-skills/scripts/validate-superpowers-memory.sh)  
  用途：校验 memory 结构、新鲜度、元数据完整性，并刷新 `memory-index.yaml`

- [search-superpowers-memory.ps1](/D:/spring_AI/superpowers-openspec-team-skills/scripts/search-superpowers-memory.ps1)
- [search-superpowers-memory.sh](/D:/spring_AI/superpowers-openspec-team-skills/scripts/search-superpowers-memory.sh)  
  用途：检索 decisions、failures、verification、journal、user profile、agent notes 等记忆面

- [suggest-superpowers-memory-updates.ps1](/D:/spring_AI/superpowers-openspec-team-skills/scripts/suggest-superpowers-memory-updates.ps1)
- [suggest-superpowers-memory-updates.sh](/D:/spring_AI/superpowers-openspec-team-skills/scripts/suggest-superpowers-memory-updates.sh)  
  用途：根据 changed paths 和 signals，给出这次更可能该更新哪些 memory 面

- [run-superpowers-memory-closeout.ps1](/D:/spring_AI/superpowers-openspec-team-skills/scripts/run-superpowers-memory-closeout.ps1)
- [run-superpowers-memory-closeout.sh](/D:/spring_AI/superpowers-openspec-team-skills/scripts/run-superpowers-memory-closeout.sh)  
  用途：把 checklist 提示、memory suggestions 和可选 validator 串成一次标准收尾动作

- [generate-superpowers-promotion-drafts.ps1](/D:/spring_AI/superpowers-openspec-team-skills/scripts/generate-superpowers-promotion-drafts.ps1)
- [generate-superpowers-promotion-drafts.sh](/D:/spring_AI/superpowers-openspec-team-skills/scripts/generate-superpowers-promotion-drafts.sh)  
  用途：把 `ready_for_promotion` 的 backlog 候选生成成 checklist / rule / skill 草案

## 触发原则

- memory scaffold 需要显式安装
- memory integration 需要显式安装
- workflow 需要显式调用
- validator 需要显式执行，或由 workflow 在收尾阶段要求执行
- suggestion / closeout helper 需要显式执行
- promotion draft 需要显式执行，不会自动修改 skill 库

## 一句话总结

当前增强版方案的核心价值，是把“项目记忆”和“学习候选”做成一个可审计、可验证、可检索、可晋升，但不黑盒的 repo 内闭环。
