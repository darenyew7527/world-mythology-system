# 世界神话系统 v0.9.0 — Perses 同名实体审计

v0.9 从永久研究队列推进 `Perses` 身份冲突，依据古代文本把三个同名人物分别建模。这是可持续扩张的阶段性知识基线，不代表资料已经全部完成。

## 本批新增

- 将赫西俄德与《书库》所述的提坦 Perses 明确为 Crius 与 Eurybia 之子、Asteria 的伴侣及 Hecate 的父亲。
- 新建 Diodorus 所述 Helios 之子、Aeetes 兄弟的 Perses；连接其陶里克统治、Medea 杀死他并恢复 Aeetes 的版本。
- 新建 Herodotus 7.61 所述 Perseus 与 Andromeda 之子 Perses，并把“波斯人得名”保存为古代起源解释，而不是现代语言学结论。
- 新增 Crius、Eurybia、Astraeus、提坦 Pallas、Aeetes、Medea、Perseus、Andromeda、三部古籍档案及一个事件实体。
- 新增 4 条来源、27 条 Claims、27 条 Evidence、26 条直接关系与 6 条后续研究分支。

## 身份与证据边界

- 三位 Perses 之间登记三条 `EXPLICITLY_DISTINCT` 候选判断，不建立 `entity_redirects`。
- 同名冲突从 `OPEN` 更新为 `RESOLVED_AS_VARIANTS`，但希腊文献中其他同名人物仍作为开放发现范围保留。
- Herodotus 的波斯名称叙事只标注为古代文本中的 aition；数据库不据此断言现代学术词源。
- 所有本批 Claims 均连接到具体古代文本章节或行号；现代网页只作为合法数字访问入口。

## 数量与质量

- 547 个登记实体，其中 542 个可浏览规范实体。
- 154 条来源、373 条 Claims、369 条 Evidence、340 条直接关系。
- SQLite 完整性、外键、来源、隐私、网页生产构建和回归测试通过后生成发布包。

下一轮继续由永久 `collection_queue` 驱动；本版本不设 `ALL COMPLETE` 终点。
