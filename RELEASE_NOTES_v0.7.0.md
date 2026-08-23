# 世界神话系统 v0.7.0 — 古埃及太阳复合神格

v0.7 建立第一批有来源定位的古埃及太阳复合神格、神庙、节庆、葬仪文本和馆藏对象网络。它是可持续扩张的阶段性知识基线，不代表资料已经全部完成。

## 本批新增

- Amun-Ra、Ra-Horakhty、Khepri、Mut、Khonsu 与 Theban Triad。
- Opet Festival、Karnak 阿蒙-拉大神庙、《亡灵书》第17咒文、太阳神夜行冥界事件。
- 五件馆藏对象：Amun-Re 圣甲虫、Re-Harakhty 木碑、Ra Horakhty 护符、Khepri 赞歌石碑、Nauny 葬仪纸草。
- “古埃及太阳复合形态”比较集：Ra、Atum、Khepri、Amun、Amun-Ra、Ra-Horakhty。

## 证据边界

- Amun-Ra 和 Ra-Horakhty 是独立的复合实体。数据库使用 `COMPOSITE_EXPRESSION_OF` 连接组成神，不把复合名当作全局拼写别名。
- 《亡灵书》第17咒文中 Khepri 与 Ra-Horakhty 的认同只保存在该文本见证的范围内，不建立全局重定向。
- 神话中的太阳舟与夜行冥界属于神话宇宙论层；卡纳克、卢克索、阿布辛贝和馆藏对象属于现实遗址／物质证据层。
- 所有新增来源保持诚实的 `URL_SYNTAX_VALID` 状态；未声称已经进行网页内容哈希或长期可用性核验。

## 数量与质量

- 522 个登记实体，其中 517 个可浏览规范实体。
- 143 条来源、321 条 Claims、317 条 Evidence、289 条直接关系。
- 本批 35 条 Claims 全部连接 Evidence；SQLite 完整性、外键、来源检查、隐私检查与回归测试通过后才生成发布包。

下一轮仍由永久 `collection_queue` 驱动；本版本不设 `ALL COMPLETE` 终点。
