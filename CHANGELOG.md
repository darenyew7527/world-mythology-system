# 更新日志 / Changelog

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
