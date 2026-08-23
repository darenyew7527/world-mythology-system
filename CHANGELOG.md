# 更新日志 / Changelog

## v0.10.0-japanese-thunder-local-dossiers — 2026-08-23

- Added Kamo Wakeikazuchi, the scoped Kamo genealogy, Kamigamo Shrine, Kamo/Aoi Festival, Kamo Kurabeuma, Fujin, Sotatsu and the Wind and Thunder God screens.
- Kept the Otokuni and Kojiki Honoikazuchi records separate under an open identity conflict.
- Added 11 entities, 6 sources, 16 claims with evidence, 15 graph relations and 6 queue branches.
- Separated fragmentary textual, living-practice, real-heritage and Edo visual-reception layers.

## v0.9.0-perses-homonym-audit — 2026-08-22

- Separated the Titan Perses, Helios-son Perses, and Perseus-son Perses into three canonical entities.
- Added Crius, Eurybia, Astraeus, Titan Pallas, Aeetes, Medea, Perseus, Andromeda, three ancient-text entities, and a restoration event.
- Added 4 sources, 27 claims with 27 evidence records, 26 graph relations, three explicit-distinction assessments, and 6 queue branches.
- Advanced the Perses conflict while keeping wider homonym discovery open.

## v0.8.0-eleusis-evidence-layers — 2026-08-21

- 从永久队列推进 `queue.greek.v050.eleusis_layers`，新增 Triptolemos、Eleusinian Mysteries、Great Eleusinia、Telesterion、Sacred Way 与 I.Eleusis 97。
- 新增雅典国家考古博物馆、大厄琉息斯浮雕126号与大都会艺术博物馆14.130.9罗马摹本残片；以 `LATER_COPY_OF` 连接，不合并器物。
- 新增 7 条权威来源、10 个实体、25 条 Claims、25 条 Evidence、25 条直接关系与 6 个后续队列分支；全部本批 Claims 均有 Evidence。
- 将“秘仪内容不可从当前公开资料完整重构”登记为开放证据缺口，保留公共行列、建筑功能、古代文本限制与现代解释的不同知识层。
- 数据库达到 532 个登记实体、150 条来源、346 条 Claims、342 条 Evidence 与 314 条直接关系；刷新全表 JSONL/CSV、图谱、档案、Source Registry、Schema Catalog、Coverage、缺失／冲突报告与回归检查。

## v0.7.0-egyptian-solar-composites — 2026-08-15

- 新增 Amun-Ra、Ra-Horakhty 与 Khepri 的独立档案，以 `COMPOSITE_EXPRESSION_OF` 保存有来源、有限定范围的复合关系，不建立破坏性别名重定向。
- 新增 Mut、Khonsu、Theban Triad、Opet Festival、Karnak 阿蒙-拉大神庙、《亡灵书》第17咒文与太阳神夜行冥界事件层。
- 新增大都会艺术博物馆与大英博物馆五件馆藏对象，并将馆藏目录、历史仪式、神话宇宙论和现代学术解释保存在不同知识层。
- 增加 14 个权威来源、16 个实体、35 条 Claims、35 条 Evidence 与 32 条直接关系；两个旧队列目标推进到 `PARTIAL`，并保留新发现的后续研究分支。
- 数据库达到 522 个登记实体、143 条来源、321 条 Claims、317 条 Evidence 与 289 条直接关系；全部 v0.7 Claims 都有 Evidence。
- 刷新全部持久表 JSONL/CSV、知识图谱、档案、Source Registry、Schema Catalog、Coverage、缺失／冲突报告，并新增 v0.7 回归检查。

## v0.6.0-thunder-comparison — 2026-08-14

- 新增证据驱动的“雷神、闪电与风暴神对照”，首批 10 个比较成员全部连接已定位 Claim 与 Evidence；比较不表示同一神、共同起源或传播关系。
- 补齐 Thor 的 Odin／Jǫrð 父母层、Sif 配偶层、Magni／Móði／Þrúðr 子女层、Meili 与 Baldr 兄弟见证，以及 Ullr 继子关系。
- 明确古诺斯 Loki 不是 Thor 的兄弟，Hel 是 Loki 与 Angrboða 之女；MCU Loki 养兄弟与 Hela 同父异母姐姐另建现代实体和改编关系。
- 新增／扩展 Indra—Vajra—Vṛtra、Raijin 泛称与《古事记》八雷神、Takemikazuchi、雷公与雷泽雷神、Perun、Ṣàngó、Baʿlu/Haddu—Yagrush—Ayyamur—Yamm 等资料层。
- 新增 `comparison_sets`／`comparison_set_members`，保留原生范围、比较边界、文化权限、身份争议与永久发现路径。
- 数据库达到 506 个登记实体、129 条来源、286 条 Claims、282 条 Evidence 与 257 条直接关系；新增 65 条 v0.6 Claims 和 67 条 Evidence。
- 刷新全部持久表 JSONL/CSV、知识图谱、档案、Source Registry、Schema Catalog、Coverage、缺失／冲突报告，并新增 v0.6 数据与网页回归检查。

## v0.5.1-mobile-graph-hotfix — 2026-08-14

- 使用独立的 390px 手机 SVG 布局，移除强制 150%／175% 宽度导致的左右节点裁切。
- 家谱关系改为显示目标相对当前实体的角色，例如 Odin 的 Bestla、Borr 正确显示为“父母”，不再误标为“子女”。
- 家谱模式纳入 FATHER_OF／MOTHER_OF，并在中英文关系图与证据清单中统一目标角色文案。
- 横向实体选择器会将当前选中项居中，并增加滚动吸附；iPhone 底部工具栏加入安全区间距。
- 新增 390px 节点边界、家谱方向、响应式 CSS 和发布迁移回归测试；神话 Claims、Evidence 与 Sources 沿用 v0.5.0 的同一证据基线。

## v0.5.0-greek-primary-profiles — 2026-08-14

- 为 Zeus、Hera、Poseidon、Hades、Athena、Apollo、Artemis、Hermes、Ares、Aphrodite、Hephaestus、Demeter、Dionysus 及 Gaia、Uranus 补齐原文名、双语摘要和证据范围明确的结构化档案。
- 新增 Leto、Maia、Semele、Dione、Persephone 五个家谱实体，以及珀耳塞福涅被劫事件；补充 Titanomachy 的事件过程与参与者。
- 将《荷马颂歌》第 3、4、5、7、8、20、22、27、28 首登记为独立文本与独立来源，所有新来源保持诚实的 `URL_SYNTAX_VALID` 状态。
- 新增弓、埃癸斯、厄琉西斯关联和 62 条行号级 Claims/Evidence；公开数据库达到 221 Claims、215 Evidence、193 条直接关系。
- 显式登记 Aphrodite 的赫西俄德起源与《伊利亚特》宙斯—狄俄涅谱系冲突，不强制选定唯一版本。
- 实体详情页新增神祇／神器／文献／地点／事件结构化档案和版本冲突卡片，深链接仍可直接分享。
- 刷新全部持久表导出、知识图谱、Markdown 档案、来源登记、覆盖率、缺失与冲突报告；新增 v0.5 数据与网页回归测试。

## v0.4.0-greek-genealogy — 2026-08-14

- 回应公开社区反馈，新增 Thanatos、Hypnos、Nyx、Hecate、Selene、Helios、Hestia 七位希腊神祇档案。
- 自动扩张第一圈家谱，新增 Chaos、Erebus、Aether、Hemera、Hyperion、Theia、Eos、Asteria、Perses；同名 Perses 保留身份冲突检查，不按名称合并。
- 新增《神谱》与《荷马颂歌》第 2、29、31、32 首的行号级 Claims 与 Evidence；网友留言只记录为发现路径，不作为证据。
- 明确分离 Hecate 的早期 Hesiodic／《致得墨忒耳》文本层与待研究的后世魔法、十字路口及冥界层。
- 新增夜、睡眠与炉火比较导航概念，同时保留原生神祇意义，不宣称跨文明同一。
- 公开探索器新增中文／英文家谱模式、实体搜索与家谱证据清单。
- 刷新全表 JSONL/CSV、知识图谱、阅读档案、Source Registry、Coverage、缺失与冲突报告，并生成完整 ZIP、Git bundle 与 SQLite 检查点。

## v0.3.1-public-preview — 2026-08-13

- 隐私加固：导入审计只保存输入文件名，不再保存本机绝对路径。
- 拒绝的 JSONL 行只保存 SHA-256 与字节数，不再保存原始内容。
- 新增回归测试，防止合成私人标记或本机目录进入 SQLite 与公开导出。
- 发布包改用可复现打包：统一时间戳、移除 UID/GID 与访问时间元数据，校验清单只写相对路径。
- 新增可复现完整项目包构建脚本，统一收纳源码、Git bundle、SQLite 检查点与 SHA-256。
- 两张公开探索器截图清除 C2PA 实例标识与生成时间元数据，像素内容不变。
- 完整项目包加入预编译网页与 Windows/macOS/Linux 一键启动器，解压后即可在本机浏览器查看。

## v0.3.0-public-preview — 2026-08-13

- 新增中文优先、可切换英文的 React/Vite 公开探索器。
- 新增实体搜索与文明／类型筛选、实体深链接、关系图谱、Claims、证据、来源、覆盖率和永久队列视图。
- 新增中文 GitHub 首页、贡献指南、Issue 模板、行为准则、安全政策、双许可和 Pages 自动部署。
- 新增可复现的浏览器安全公开数据快照；公开快照排除证据短引文。
- 新增公开导出的计数、确定性、关系图谱与版权边界回归测试。
- 保留 v0.2.0 持久化、完整导出、来源核验、对称关系和多类型实体修复。

## v0.2.0 — 2026-08-11

- 建立可持续扩张的阶段性数据基线、永久队列、增量迁移与完整持久表导出。
- 修复日常流水线覆盖研究增量、对称边反向查询、次级分类视图和来源核验状态问题。
